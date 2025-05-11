extends Label

func _ready():
	GameEvent.connect("update_points", Callable(self, "_points_updated"))

func _points_updated():
	text = str(Global.current_points)

# PointsDisplay: Changed vertical alignment from center to top because in Godot 4.4 the text shifts position after updating. Also adjusted Transform → Position y from 0 to 2 to restore the correct layout.
