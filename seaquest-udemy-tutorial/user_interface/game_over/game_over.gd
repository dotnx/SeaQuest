extends Control

const GameOverSound = preload("res://player/game_over.ogg")

@onready var current_score_label = $CurrentScoreLabel
@onready var high_score_label = $HighScoreLabel
@onready var game_over_delay_timer = $GameOverDelay

func _ready():
	GameEvent.connect("game_over", Callable(self, "_activate_game_over"))
	
	visible = false

func _process(delta):
	if Input.is_action_just_pressed("shoot") and visible == true:
		Global.current_points = 0
		Global.saved_people_count = 0
		Global.oxygen_level = 100
		get_tree().reload_current_scene()

func _activate_game_over():
	current_score_label.text = "Score " + str(Global.current_points)
	
	if Global.current_points > Global.highscore:
			Global.highscore = Global.current_points
	
	high_score_label.text = "Highscore " + str(Global.highscore)
	game_over_delay_timer.start()

func _on_game_over_delay_timeout():
	visible = true
	SoundManager.play_sound(GameOverSound)
