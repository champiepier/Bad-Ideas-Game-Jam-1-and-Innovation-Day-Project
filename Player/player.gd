class_name Player
extends CharacterBody2D

@onready var fsm: FiniteStateMachine = $FiniteStateMachine
@onready var player_normal_form: PlayerNormalForm = $FiniteStateMachine/PlayerNormalForm as PlayerNormalForm
@onready var player_ball_form: PlayerBallForm = $FiniteStateMachine/PlayerBallForm as PlayerBallForm

@export var up_gravity: float = 800.0
@export var down_gravity: float = 900.0

@export var bug_eat_sfx: AudioStreamMP3

var speed: float

var just_touched_ground: bool = false
var can_change_states: bool = true

func _ready() -> void:
	if fsm:
		fsm.change_state(player_normal_form)
		
	speed = fsm.state.base_speed

func _physics_process(delta: float) -> void:
	
	check_just_touched_ground()
	handle_movement(delta)
	apply_gravity(delta)
	
	Global.state_change_time_left = $StateChangeCooldown.time_left
		
	move_and_slide()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("action") and can_change_states:
		toggle_form()
			
func toggle_form():
	if fsm.state == player_normal_form:
		fsm.change_state(player_ball_form)
	else:
		fsm.change_state(player_normal_form)
	can_change_states = false
	$StateChangeCooldown.start()
			
func check_just_touched_ground():
	if is_on_floor() and !just_touched_ground:
		just_touched_ground = true
	elif !is_on_floor():
		just_touched_ground = false
	
func handle_movement(delta):
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * speed, delta * fsm.state.friction)
	else:
		velocity.x = move_toward(velocity.x, 0, fsm.state.friction * delta)
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += fsm.state.base_jump
		
func apply_gravity(delta):
	if not is_on_floor():
		if velocity.y <= 0:
			velocity.y += up_gravity * delta
		else:
			velocity.y += down_gravity * delta
		
func eat_food(boost: float, duration: float):
	if fsm.state == player_normal_form:
		speed = (boost * fsm.state.base_speed)
		Global.play_sfx(bug_eat_sfx)
		await get_tree().create_timer(duration).timeout
		speed = fsm.state.base_speed
		
func _on_state_change_cooldown_timeout() -> void:
	can_change_states = true
