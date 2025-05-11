extends Area2D

var velocity = Vector2(1, 0)
var points_value = 30

enum states {DEFAULT, PAUSED}
var current_state = states.DEFAULT

const SPEED = 25
const SaveSound = preload("res://person/saving_person.ogg")
const DeathSound = preload("res://person/person_death.ogg")

@onready var sprite = $AnimatedSprite2D

func _ready():
	GameEvent.connect("pause_enemies", Callable(self, "_pause"))

func _physics_process(delta):
	if current_state == states.DEFAULT:
		global_position += velocity * SPEED * delta

func _process(delta):
	if global_position.x > Global.SCREEN_BOUND_MAX_X or global_position.x < Global.SCREEN_BOUND_MIN_X:
		queue_free()

func flip_direction():
	velocity = -velocity
	sprite.flip_h = !sprite.flip_h

func _on_area_entered(area):
	if area.is_in_group("Player"):
		Global.saved_people_count += 1
		GameEvent.emit_signal("update_collected_people_count")
		Global.current_points += points_value
		GameEvent.emit_signal("update_points")
		
		SoundManager.play_sound(SaveSound)
		
		queue_free()
	elif area.is_in_group("PlayerBullet"):
		SoundManager.play_sound(DeathSound)
		area.queue_free()
		queue_free()

func _pause(pause):
	if pause:
		current_state = states.PAUSED
	else:
		current_state = states.DEFAULT
