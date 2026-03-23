extends CharacterBody2D

@export var food_type: FoodTypes

func _ready() -> void:
	food_type = food_type.duplicate(true)
	$Sprite2D.texture = food_type.sprite

func _on_eat_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		queue_free()
