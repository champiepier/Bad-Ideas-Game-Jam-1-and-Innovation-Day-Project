extends CharacterBody2D

@onready var camera_2d: Camera2D = $"../Camera2D"

@export var gravity: float = 1500.0
@export var friction: float = 10
@export var decay: float = 10.0

enum STATES {Ball, Normal}
var state = STATES.Ball
var current_frame: int = 0
var speed = 2000.0
var just_touched_ground: bool = false
var is_in_air: bool = false
var can_change_states: bool = true

func _physics_process(delta: float) -> void:
	
	get_position_points()
	
	if is_on_floor() and !just_touched_ground:
		just_touched_ground = true
		Engine.time_scale = 0
		print("oof")
		await get_tree().create_timer(0.1, true, false, true).timeout
		Engine.time_scale = 1
	elif !is_on_floor():
		just_touched_ground = false
		
	
	match state:
		STATES.Normal:
			normal_movement(delta)
		STATES.Ball:
			ball_movement(delta)
	
	
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
	
	if velocity.x > 0:	
		decay += 1
	
	if !is_on_floor():
		velocity.y += gravity * delta
	
	velocity.x = speed - decay
	
	move_and_slide()
	
func ball_movement(delta):
	
	if velocity.x > 0:
		decay += 0.5
		
	if !is_on_floor():
		velocity.y += gravity * delta
		
	velocity.x = speed - decay
	
	move_and_slide()
	
func get_position_points():
	current_frame += 1
	
	if current_frame >= 10:
		Global.position_log.append(global_position)
		current_frame = 0


func _on_state_change_cooldown_timeout() -> void:
	can_change_states = true
