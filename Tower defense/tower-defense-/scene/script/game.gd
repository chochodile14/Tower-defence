extends Node2D

var emplacement_actif = null
var ennemy_scene = preload("res://scene/ennemies/champi.tscn")


func _ready() -> void:
	add_to_group("game")
	for e in get_tree().get_nodes_in_group("emplacement"):
		e.demande_menu.connect(_sur_emplacement_clique)
	for i in get_tree().get_nodes_in_group("emplacement"):
		i.Panel_Open.connect(_sur_emplacement_clique)
	print("game")
	spawn_enemy()


func _process(delta: float) -> void:
	if Global.spawn == 0:
		spawn_enemy()
#apparaition de l'ennemie
func spawn_enemy() -> void:
	var path_follow = PathFollow2D.new()
	var enemy = ennemy_scene.instantiate()
	path_follow.add_child(enemy)
	$Path2D.add_child(path_follow)
	Global.spawn += 1
#-------------------------------------------------------------------------------
#func achat de tour
#-------------------------------------------------------------------------------



#poser tour quand clic a position de clic
#func _unhandled_input(event: InputEvent) -> void: 
#	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and Global.gold >= 25:
#		Global.gold -= 25
#		var tour = tower.instantiate()
#		add_child(tour)
#		tour.global_position = get_global_mouse_position()
#apparaition du panel pour achat tour
func _sur_emplacement_clique(emplacement):
	emplacement_actif = emplacement
	print("empplacement cliqué : ",emplacement.name )
