extends Marker2D
 
@export var facing_left = false

const Shark = preload("res://enemies/shark/shark.tscn")

@onready var timer = $Timer

func _ready():
	timer.wait_time = randf_range(2.5, 5)
	timer.start()
	
func _on_timer_timeout():
	var shark_instance = Shark.instantiate()
	get_tree().current_scene.add_child(shark_instance)
	shark_instance.global_position = global_position
	
	if facing_left:
		shark_instance.flip_direction()
	
	timer.wait_time = randf_range(2.5, 5)
