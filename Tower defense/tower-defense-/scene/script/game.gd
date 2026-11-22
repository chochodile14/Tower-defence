extends Node2D
@onready var can_spawn := false
@onready var timer_sp: float = 1.5
@onready var N_spawn: int = 0
@onready var N_spawn_Max: int= Global.wave*5+10
var emplacement_actif = null
var ennemys_scenes : Array = [preload("res://scene/ennemies/champi.tscn"),preload("res://scene/ennemies/second_monster.tscn")]
var boss = preload("res://scene/ennemies/boss.tscn")

func _ready() -> void:
	add_to_group("game")
	for e in get_tree().get_nodes_in_group("emplacement"):
		e.demande_menu.connect(_sur_emplacement_clique)
	for i in get_tree().get_nodes_in_group("emplacement"):
		i.Panel_Open.connect(_sur_emplacement_clique)
	print("game")
	await get_tree().create_timer(1.5).timeout
	can_spawn = true


func _process(delta: float) -> void:
	
	if Global.life <= 0:
		print("game over")
		get_tree().change_scene_to_file("res://scene/main/game_over.tscn")
	if can_spawn:
		couldown_spawn()
#-------------------------------------------------------------------------------
#func spawn respawn and wave
#-------------------------------------------------------------------------------
#apparaition de l'ennemie
func spawn_enemy() -> void:
	if N_spawn % 10 == 0 and N_spawn > 0:
		var path_follow = PathFollow2D.new()
		var enemy = boss.instantiate()
		path_follow.add_child(enemy)
		$Path2D.add_child(path_follow)
	var path_follow = PathFollow2D.new()
	var enemy = ennemys_scenes.pick_random().instantiate()
	path_follow.add_child(enemy)
	$Path2D.add_child(path_follow)


func couldown_spawn():
	if can_spawn:
		spawn_enemy()
		can_spawn = false
		await get_tree().create_timer(1.5).timeout
		can_spawn = true
		N_spawn +=1
		print(N_spawn, " / ", N_spawn_Max)
		if N_spawn == N_spawn_Max:
			Global.wave +=1
			N_spawn = 0
			N_spawn_Max += Global.wave*5+10

#-------------------------------------------------------------------------------
#func achat de tour
#-------------------------------------------------------------------------------


func _sur_emplacement_clique(emplacement):
	emplacement_actif = emplacement
	print("empplacement cliqué : ",emplacement.name )
