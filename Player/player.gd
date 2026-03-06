extends CharacterBody2D

@onready var camera_2d: Camera2D = $"../Camera2D"

@export var friction: float = 20.0
@export var decay = 2.0
@export var gravity = 150

enum STATES {Crashed, Ball, Dart}

var state = STATES.Dart

var is_landing = false
var current_frame: int = 0

var momentum = 75.0
var speed = 1000.0

var momentum_loss_speed = 5

func _physics_process(delta: float) -> void:
	
	get_position_points()
	
	match state:
		STATES.Dart:
			momentum_loss_speed = 10
			handle_dart_movement(delta)
		STATES.Ball:
			momentum_loss_speed = 1
			pass
		STATES.Crashed:
			pass
			
	if is_on_floor() and !is_landing:
		is_landing = true
		Engine.time_scale = 0
		await get_tree().create_timer(velocity.x/20000, true, false, true).timeout
		Engine.time_scale = 1
		rotation = deg_to_rad(0)
		camera_2d.rotation = deg_to_rad(0)
		bounce_player()
	elif !is_on_floor():
		is_landing = false
	
	
func handle_dart_movement(delta):
	
	var input = Input.get_axis("ui_up", "ui_down")
	
	if !is_on_floor():
		velocity.y = gravity + 125 * input
	
		rotation = lerp_angle(rotation, deg_to_rad(25*input), 0.1)
		camera_2d.rotation = lerp_angle(camera_2d.rotation, deg_to_rad(-2.5*input), 0.1)
		
		velocity.x = round(((momentum / (friction + (deg_to_rad(rotation * 10)))) * speed) - decay)
		
		if velocity.x > 0:
			decay += 1
			
	else:
		velocity.x = move_toward(velocity.x, 0.0, momentum_loss_speed)
	
	move_and_slide()
	
func bounce_player():
	match state:
		STATES.Ball:
			pass
		STATES.Dart:
			pass
	
func get_position_points():
	current_frame += 1
	
	if current_frame == 10:
		Global.position_log.append(global_position)
		current_frame = 0
