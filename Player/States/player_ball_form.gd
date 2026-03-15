class_name PlayerBallForm
extends State

@export var actor: Player
@export var animator: AnimationPlayer

func _ready() -> void:
	set_physics_process(false)
	
func _enter_state() -> void:
	set_physics_process(true)
	animator.play("roll")

func _exit_state() -> void:
	set_physics_process(false)
