class_name PlayerNormalForm
extends State

@export var actor: Player
@export var animator: AnimationPlayer

func _ready() -> void:
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)
	animator.play("run")

func _exit_state() -> void:
	set_physics_process(false)
