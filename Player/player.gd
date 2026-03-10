extends CharacterBody2D

@onready var camera_2d: Camera2D = $"../Camera2D"

@export var gravity: float = 1500.0
@export var friction: float = 10
@export var decay: float = 10.0

@export var bounce_curve: Curve

const BASE_BOUNCE_HEIGHT = -500.0

var max_bounce = BASE_BOUNCE_HEIGHT * 2

var momentum_percent = 75.0

enum STATES {Ball, Normal}
var state = STATES.Normal
var current_frame: int = 0
var base_speed = 2000.0
var just_touched_ground: bool = false
var is_in_air: bool = false
var can_change_states: bool = true

func _physics_process(delta: float) -> void:
	
	get_position_points()
	
	if is_on_floor() and !just_touched_ground:
		just_touched_ground = true
		var speed_ratio = clamp(abs(velocity.x) / base_speed, 0.0, 1.0)
		velocity.y = max_bounce * bounce_curve.sample(speed_ratio)
	elif !is_on_floor():
		just_touched_ground = false
		
	
	match state:
		STATES.Normal:
			normal_movement(delta)
		STATES.Ball:
			ball_movement(delta)
			
	if not is_on_floor():
		velocity.y += gravity * delta
		
		
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("action"):
		if can_change_states:
			if state == STATES.Normal:
				state = STATES.Ball
			else:
				state = STATES.Normal
				
			can_change_states = false
			$StateChangeCooldown.start()
	
func normal_movement(delta):
	
	$anims.play("run")
	
	momentum_percent = move_toward(momentum_percent, 0.0, 5.0 * delta)
	
	velocity.x = (momentum_percent / 100.0) * base_speed
	
	
	move_and_slide()
	
func ball_movement(delta):
	
	$anims.play("roll")
	
	momentum_percent = move_toward(momentum_percent, 0.0, 2.0 * delta)
		
	velocity.x = (momentum_percent / 100.0) * base_speed
	
	move_and_slide()
	
func get_position_points():
	current_frame += 1
	
	if current_frame >= 10:
		Global.position_log.append(global_position)
		current_frame = 0


func _on_state_change_cooldown_timeout() -> void:
	can_change_states = true
