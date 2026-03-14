extends CharacterBody2D

@onready var camera_2d: Camera2D = $"../Camera2D"
@onready var space_held_timer: Timer = $SpaceHeldTimer

@export var gravity: float = 800.0
@export var friction: float = 10
@export var decay: float = 0

@export var bounce_curve: Curve

const BASE_BOUNCE_HEIGHT = -500.0

var max_bounce = BASE_BOUNCE_HEIGHT * 2

var momentum_percent = 75.0

var input_dir: float = 0

var is_holding_space: bool = false

enum STATES {Ball, Normal}
var state = STATES.Normal
var current_frame: int = 0
var base_speed = 5000.0
var just_touched_ground: bool = false
var is_in_air: bool = false
var can_change_states: bool = true

func _physics_process(delta: float) -> void:
	
	get_position_points()
	
	if is_on_floor() and !just_touched_ground:
		just_touched_ground = true
	elif !is_on_floor():
		just_touched_ground = false
	
	match state:
		STATES.Normal:
			normal_movement(delta)
		STATES.Ball:
			ball_movement(delta)
			
	
	if !is_on_floor():		
		input_dir = Input.get_axis("up", "down")
		rotation = lerp_angle(deg_to_rad(rotation), deg_to_rad(input_dir * 25), 0.5)
	else:
		rotation = 0.0
	
	if not is_on_floor():
		velocity.y += (gravity * delta)
		
	print(velocity)
	
	move_and_slide()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("action"):
		if can_change_states:
			if state == STATES.Normal:
				state = STATES.Ball
			can_change_states = false
			$StateChangeCooldown.start()
			
	if event.is_action_released("dash"):
		position = position.move_toward(position + Vector2(25, 25), 0.5)
	
func normal_movement(delta):
	
	$Sprite2D.texture = load("res://Assets/icon.svg")
	
	velocity.x = (momentum_percent / 100.0) * base_speed
	momentum_percent += deg_to_rad(rotation)
	
	if just_touched_ground:
		momentum_percent = move_toward(momentum_percent, 0.0, 0.5)
	
func ball_movement(delta):
	
	$Sprite2D.texture = load("res://Assets/icon-ball.png")
		
	velocity.x = (momentum_percent / 100.0) * base_speed
	momentum_percent += deg_to_rad(rotation)
	
func get_position_points():
	current_frame += 1
	
	if current_frame >= 10:
		Global.position_log.append(global_position)
		current_frame = 0
		
func _on_state_change_cooldown_timeout() -> void:
	can_change_states = true
