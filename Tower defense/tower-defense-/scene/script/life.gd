extends Node2D
@onready var label : Label = $Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label.text = str(Global.life)
