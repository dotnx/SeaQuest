extends Area2D

var velocity = Vector2(0, 0)
var can_shoot = true

enum states {DEFAULT, PAUSED, OXYGEN_REFUEL, PEOPLE_REFUEL}
var state = states.DEFAULT

const SPEED = Vector2(125, 90)

const OXYGEN_DECREASE_SPEED = 2.5
const OXYGEN_INCREASE_SPEED = 60
const OXYGEN_REFUEL_Y_POSITION = 38
const OXYGEN_REFUEL_MOVE_SPEED = 70

const MAX_X_POSITION = 248
const MIN_X_POSITION = 13
const MAX_Y_POSITION = 205
const MIN_Y_POSITION = OXYGEN_REFUEL_Y_POSITION

const BULLET_OFFSET = 7
const Bullet = preload("res://player/player_bullet/player_bullet.tscn")
const ShootSound = preload("res://player/player_bullet/player_shoot.ogg")

@onready var reload_timer = $ReloadTimer
@onready var sprite = $AnimatedSprite2D
@onready var decrease_people_timer = $DecreasePeopleTimer

func _ready():
	GameEvent.connect("full_crew_oxygen_refuel", Callable(self, "_full_crew_oxygen_refuel"))
	GameEvent.connect("less_people_oxygen_refuel", Callable(self, "_less_people_oxygen_refuel"))
	GameEvent.connect("game_over", Callable(self, "_game_over"))
	
func _process(delta):
	if state == states.DEFAULT:
		process_movement_input()
		direction_follows_input()
		process_shooting()
		lose_oxygen()
		death_when_reaches_zero()
	elif state == states.OXYGEN_REFUEL:
		oxygen_refuel()
		move_to_shore_line()
	elif state == states.PEOPLE_REFUEL:
		move_to_shore_line()

func _physics_process(delta):
	if state == states.DEFAULT:
		movement()
	
	clamp_position()
	GameEvent.emit_signal("camera_follow_player", global_position.y)

func process_movement_input():
	velocity.x = Input.get_axis("move_left", "move_right")
	velocity.y = Input.get_axis("move_up", "move_down")
	
	velocity = velocity.normalized()

func direction_follows_input():
	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true

func process_shooting():
	if Input.is_action_pressed("shoot") and can_shoot == true:
		var bullet_instance = Bullet.instantiate()
		get_tree().current_scene.add_child(bullet_instance)
		
		SoundManager.play_sound(ShootSound)
		
		if sprite.flip_h == true:
			bullet_instance.flip_direction()
			bullet_instance.global_position = global_position - Vector2(BULLET_OFFSET, 0)
		else:
			bullet_instance.global_position = global_position + Vector2(BULLET_OFFSET, 0)
		
		reload_timer.start()
		can_shoot = false

func lose_oxygen():
	var oxygen_decrease_delta = OXYGEN_DECREASE_SPEED * get_process_delta_time()
	Global.oxygen_level = move_toward(Global.oxygen_level, 0, oxygen_decrease_delta)

func oxygen_refuel():
	Global.oxygen_level += OXYGEN_INCREASE_SPEED * get_process_delta_time()
	
	if Global.oxygen_level > 99:
		state = states.DEFAULT
		sprite.play("default")
		GameEvent.emit_signal("pause_enemies", false)

func death_when_reaches_zero():
	if Global.oxygen_level <= 0:
		death()

func death_when_refueling_while_full():
	if Global.oxygen_level > 80:
		death()

func death():
	GameEvent.emit_signal("game_over")
	GameEvent.emit_signal("pause_enemies", true)

func move_to_shore_line():
	var move_speed = OXYGEN_REFUEL_MOVE_SPEED * get_process_delta_time()
	global_position.y = move_toward(global_position.y, OXYGEN_REFUEL_Y_POSITION, move_speed)

func movement():
	global_position += velocity * SPEED * get_physics_process_delta_time()

func clamp_position():
	global_position.x = clamp(global_position.x, MIN_X_POSITION, MAX_X_POSITION)
	global_position.y = clamp(global_position.y, MIN_Y_POSITION, MAX_Y_POSITION)

func _on_reload_timer_timeout():
	can_shoot = true

func remove_one_person():
	if Global.saved_people_count > 0:
		Global.saved_people_count -= 1
		GameEvent.emit_signal("update_collected_people_count")

func _full_crew_oxygen_refuel():
	state = states.PEOPLE_REFUEL
	sprite.play("flash")
	decrease_people_timer.start()
	death_when_refueling_while_full()
	GameEvent.emit_signal("pause_enemies", true)

func _less_people_oxygen_refuel():
	state = states.OXYGEN_REFUEL
	sprite.play("flash")
	remove_one_person()
	death_when_refueling_while_full()
	GameEvent.emit_signal("pause_enemies", true)
	
func _on_decrease_people_timer_timeout():
	remove_one_person()
	
	if Global.saved_people_count <= 0:
		state = states.OXYGEN_REFUEL
		decrease_people_timer.stop()

func _game_over():
	queue_free()
