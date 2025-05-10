extends Sprite2D

const EMPTY_TEXTURE = preload("res://user_interface/people-count/person_empty_ui.png")
const FULL_TEXTURE = preload("res://user_interface/people-count/person_ui.png")

@export var order_number = 1

func _process(delta):
	if Global.saved_people_count >= order_number:
		texture = FULL_TEXTURE
