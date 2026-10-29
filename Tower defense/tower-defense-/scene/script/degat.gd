extends Area2D

func _on_body_entered(body: RigidBody2D) -> void:
	if body.is_in_group("ennemis"):
		Global.life -=1
		print("degat reçut", Global.life)
	
