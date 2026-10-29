extends Area2D

func _on_body_entered(body: RigidBody2D) -> void:
	print("DETECTE : ", body.name)
	if body.is_in_group("ennemis") and not body.fini:
		body.fini = true
		Global.life -=1
		Global.spawn -= 1
		body.get_parent().queue_free()
		print("degat reçut", Global.life)
	
