extends Node

var current_frame: int = 0

var position_log: PackedVector2Array = PackedVector2Array()
		
func get_position_points(tracked_obj):
	
		current_frame += 1
		
		if current_frame >= 10:
			position_log.append(tracked_obj.global_position)
			current_frame = 0
