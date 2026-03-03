extends CharacterBody2D

@export var friction: float = 0.0
@export var mass: float = 2.5

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var current_frame: int = 0
var momentum: float
var speed: int = 200

func _physics_process(delta: float) -> void:
	velocity = Vector2(gravity * delta * speed, gravity * delta)
	
	momentum = velocity.x * mass
	
	if Input.is_action_pressed("action"):
		velocity = Vector2(10, 500)
	
	move_and_slide()
		
		
func get_position_points():
	get_position_points()
	current_frame += 1
	
	if current_frame == 5:
		Global.position_log.append(global_position)
		print(Global.position_log)
		current_frame = 0
