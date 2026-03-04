extends CharacterBody2D

@onready var camera_2d: Camera2D = $"../Camera2D"

@export var friction: float = 0.15
@export var mass: float = 2.5
@export var acceleration: float = 700.0
@export var rotation_speed = 10.0

enum STATES {Normal, Ball, Dart}

var state = STATES.Normal

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var current_frame: int = 0
var momentum: float
var speed: int = 200

func _physics_process(delta: float) -> void:
	velocity = Vector2(gravity * delta * speed, gravity * delta * 5)
	
	momentum = velocity.x * mass
	
	var input_dir := Input.get_axis("up", "down")
	rotation += input_dir * rotation_speed * delta
	
	move_and_slide()
		
		
func get_position_points():
	get_position_points()
	current_frame += 1
	
	if current_frame == 5:
		Global.position_log.append(global_position)
		print(Global.position_log)
		current_frame = 0
