extends Node2D



func _on_restart_pressed() -> void:
	Global.life = 5
	Global.gold = 50
	Global.spawn = 0
	get_tree().change_scene_to_file("res://scene/game/game.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
