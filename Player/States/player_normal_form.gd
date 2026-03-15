class_name PlayerNormalForm
extends PlayerState

@export var actor: Player
@export var animator: AnimationPlayer

func _ready() -> void:
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)
	animator.play("run")
	base_speed = 1500
	base_jump = -600.0
	friction = 3500

func _exit_state() -> void:
	set_physics_process(false)
	
func _physics_process(delta: float) -> void:
	pass
