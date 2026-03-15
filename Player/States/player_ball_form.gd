class_name PlayerBallForm
extends PlayerState

@export var actor: Player
@export var animator: AnimationPlayer

func _ready() -> void:
	set_physics_process(false)
	
func _enter_state() -> void:
	set_physics_process(true)
	animator.play("roll")
	base_speed = 2500
	base_jump = 0.0
	friction = 750
	
func _exit_state() -> void:
	set_physics_process(false)
	
func _physics_process(delta: float) -> void:
	pass
