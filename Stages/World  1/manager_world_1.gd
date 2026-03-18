extends Node

@onready var can_change_again_bar: ProgressBar = $"../CanvasLayer/GUI/MarginContainer/ProgressBarContainer/CanChangeAgainBar"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	Global.call_deferred("get_position_points", %Player)
	
	can_change_again_bar.value = Global.state_change_time_left
