extends Node2D

var previous_amount = 0

@onready var progress_bar = $TextureProgress
@onready var flash_timer = $FlashTimer

func _process(delta):
	progress_bar.value = Global.oxygen_level
	
	var amount_rounded = round(Global.oxygen_level)
	
	if amount_rounded == previous_amount:
		return
		
	if amount_rounded == 25:
		alert(1.25, 5)
	elif amount_rounded == 15:
		alert(1.3, 7)
	elif amount_rounded == 10:
		alert(1.35, 10)
	elif amount_rounded == 7:
		alert(1.4, 15)
	elif amount_rounded == 5:
		alert(1.5, 20)
	elif amount_rounded == 2:
		alert(1.6, 25)
	elif amount_rounded == 1:
		alert(1.8, 35)
	
	previous_amount = amount_rounded

func _physics_process(delta):
	scale = lerp(scale, Vector2(1, 1), 6 * delta)
	rotation_degrees = lerp(rotation_degrees, 0.0, 6 * delta)

func alert(scale_value, rotation_value):
	scale = Vector2(scale_value, scale_value)
	rotation_degrees = randf_range(-rotation_value, rotation_value)
	modulate = Color(50, 50, 50)
	flash_timer.start()

func _on_flash_timer_timeout():
	modulate = Color(1, 1, 1)
