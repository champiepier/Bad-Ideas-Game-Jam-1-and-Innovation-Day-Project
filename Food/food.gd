extends CharacterBody2D

@export var food_type: FoodTypes

func _ready() -> void:
	food_type = food_type.duplicate(true)
	$Sprite2D.texture = food_type.sprite

func _on_eat_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("CanEatBug"):
		var player = area.get_parent()
		player.eat_food(food_type.speed_boost, food_type.speed_boost_time)
		queue_free()
