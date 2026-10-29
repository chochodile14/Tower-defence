extends Area2D

func _on_body_entered(groupe: ennemis) -> void:
	Global.life -=1
