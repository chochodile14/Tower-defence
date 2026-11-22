extends Node2D
@onready var Wave_in : Label = $Wave_in
@onready var Wave_max : Label = $wave_max


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Wave_in.text = str(Global.wave)
	Wave_max.text = str(Global.max_wave)
