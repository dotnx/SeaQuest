extends Control

@onready var current_score_label = $CurrentScoreLabel
@onready var game_over_delay_timer = $GameOverDelay

func _ready():
	GameEvent.connect("game_over", Callable(self, "_activate_game_over"))
	
	visible = false

func _process(delta):
	if Input.is_action_just_pressed("shoot") and visible == true:
		get_tree().reload_current_scene()

func _activate_game_over():
	current_score_label.text = "Score " + str(Global.current_points)
	game_over_delay_timer.start()

func _on_game_over_delay_timeout():
	visible = true
