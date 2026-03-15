extends CharacterBody2D

@onready var ball_text: CompressedTexture2D = preload("res://Assets/icon-ball.png")
@onready var norm_text: CompressedTexture2D = preload("res://Assets/icon.svg")

@export var gravity: float = 800.0

@export var base_speed := 1500.0
@export var base_jump := -750.0
@export var base_tilt := deg_to_rad(30)

@export var friction := 1000.0
@export var acceleration := 1000.0

@export var state: STATES = STATES.Normal

enum STATES {Ball, Normal}

var just_touched_ground: bool = false
var can_change_states: bool = true

func _physics_process(delta: float) -> void:
		
	if is_on_floor() and !just_touched_ground:
		just_touched_ground = true
	elif !is_on_floor():
		just_touched_ground = false
		
	match state:
		STATES.Normal:
			$Sprite2D.texture = norm_text
			normal_movement(delta)
		STATES.Ball:
			$Sprite2D.texture = ball_text
			ball_movement(delta)
			
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * base_speed, delta * acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
		
	if !is_on_floor():
		var tilt_dir = Input.get_axis("up", "down")
		var target_dir = tilt_dir * base_tilt
		rotation = lerp_angle(rotation, target_dir, 0.1)
	else:
		rotation = lerp_angle(rotation, 0, 0.5)
		
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = base_jump
		
	move_and_slide()
	
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
	
	base_speed = 1500
	friction = 1000
	acceleration = 1000
	
func ball_movement(delta):
	
	base_speed = 3000
	friction = 500
	acceleration = 2000
		
func _on_state_change_cooldown_timeout() -> void:
	can_change_states = true
