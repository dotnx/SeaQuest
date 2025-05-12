extends Node2D

var value = 0

const SPEED = 15

@onready var label = $Label

func _ready():
	label.text = str(value)
	rotation_degrees = randf_range(0, 360)

func _physics_process(delta):
	global_position.y -= SPEED * delta
	rotation_degrees = lerp(rotation_degrees, 0.0, 18 * delta)
