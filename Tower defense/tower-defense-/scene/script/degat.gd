extends Area2D

func _ready() -> void:
	print("DEGAT position = ", global_position)



func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("ennemis") and not area.fini:
		area.fini = true
		Global.life -= 1
		area.get_parent().queue_free()
