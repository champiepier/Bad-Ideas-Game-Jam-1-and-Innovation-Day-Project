extends Node

@onready var can_change_again_bar: ProgressBar = $"../CanvasLayer/GUI/MarginContainer/ProgressBarContainer/CanChangeAgainBar"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	Global.call_deferred("get_position_points", %Player)
	
	can_change_again_bar.value = Global.state_change_time_left

func _on_timer_timeout() -> void:
	%Player.can_go = true
