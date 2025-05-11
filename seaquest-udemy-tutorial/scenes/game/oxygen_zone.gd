extends Area2D

const PlayerSurfaceSound = preload("res://player/player_surface.ogg")

func _on_area_entered(area):
	if area.is_in_group("Player"):
		if Global.saved_people_count >= 7:
			GameEvent.emit_signal("full_crew_oxygen_refuel")
			print("Full crew refuel")
		else:
			GameEvent.emit_signal("less_people_oxygen_refuel")
			print("Refueled too early")
		
		SoundManager.play_sound(PlayerSurfaceSound)
