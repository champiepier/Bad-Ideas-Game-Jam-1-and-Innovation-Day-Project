extends Node

var current_frame: int = 0

var state_change_time_left: float = 0.0

var position_log: PackedVector2Array = PackedVector2Array()

func play_sfx(stream: AudioStream):
	
	if stream == null: return
	
	var player = AudioStreamPlayer.new()
	add_child(player)
	player.stream = stream
	player.play()
	player.finished.connect(player.queue_free)
		
func get_position_points(tracked_obj):
	
		current_frame += 1
		
		if current_frame >= 10:
			position_log.append(tracked_obj.global_position)
			current_frame = 0
