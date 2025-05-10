extends Node2D

const Shark = preload("res://enemies/shark/shark.tscn")

@onready var left = $Left
@onready var right = $Right

func _on_spawn_enemy_timer_timeout():
	for i in range(4):
		spawn_enemy()
	
func spawn_enemy():
	var rand_spawn_point_number = randi_range(1, 4)
	
	var selected_side_node = left
	var spawn_right = bool(randi_range(0, 1))
	
	if spawn_right == true:
		selected_side_node = right
	
	var selected_spawn_point = selected_side_node.get_node(str(rand_spawn_point_number))
	var spawn_position = selected_spawn_point.global_position
	
	var shark_instance = Shark.instantiate()
	shark_instance.global_position = spawn_position
	get_tree().current_scene.add_child(shark_instance)
	
	if spawn_right == true:
		shark_instance.flip_direction()
