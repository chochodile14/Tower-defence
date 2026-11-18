extends Node2D
func _ready() -> void:
	UiSfx.jouer("defaite")


func _on_restart_pressed() -> void:
	Global.life = 5
	Global.wave = 0
	Global.max_wave = 10
	Global.gold = 50
	get_tree().change_scene_to_file("res://scene/game/game.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
