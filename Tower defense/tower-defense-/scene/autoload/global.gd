extends Node
@onready var wave : int = 0
@onready var max_wave: int = 10
@onready var gold = 50
@onready var life = 1000000000#juste pour les test normalment =5
@onready var mob_in_wave = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if wave >= max_wave:
		get_tree().change_scene_to_file("res://scene/main/credit.tscn")
		await get_tree().create_timer(65).timeout
		queue_free()
