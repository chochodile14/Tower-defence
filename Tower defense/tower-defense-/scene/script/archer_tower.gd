class_name Tour
extends Node2D
enum Type {SOLO,ZONE,RALENTI}
var type = Type.RALENTI
@export var degats := 5
@onready var sprit : Sprite2D = $Archer
@onready var portee: Area2D = $Portee
@onready var cadence: Timer = $Timer
const NIVEAU_MAX := 3
var niveau := 1
var facteur_ralenti := 0.4


func _ready() -> void:
	cadence.timeout.connect(_tirer)
	add_to_group("tour")
	match type :
		Type.SOLO: 
			sprit.modulate = Color.RED
			degats = 7
		Type.ZONE: 
			sprit.modulate = Color.ORANGE
			degats = 5
		Type.RALENTI: 
			sprit.modulate = Color.LIGHT_BLUE
			degats = 3

func _tirer() -> void:
	var cible = _enemis_en_portee()
	if cible.is_empty():
		return
	match type:
		Type.SOLO:
			degats = 7
			cible[0].take_dammage(degats)
		Type.ZONE:
			degats = 5
			for c in cible:
				c.take_dammage(degats)
		Type.RALENTI:
			cible[0].take_dammage(degats)
			for c in cible:
				c._ralentir(facteur_ralenti,2.0)

	print("tick | zones: ", portee.get_overlapping_areas(), " | corps: ", portee.get_overlapping_bodies())


func _enemis_en_portee():
	var liste = []
	for corps in portee.get_overlapping_bodies():
		if corps.is_in_group("ennemis"):
			liste.append(corps)
	return liste
#-------------------------------------------------------------------------------
#Fonction d'amelio
#-------------------------------------------------------------------------------

func prix_amelioration() -> int:
	return 30 * niveau

func ameliorer():
	if niveau >= NIVEAU_MAX :
		return
	niveau +=1
	match type :
		Type.SOLO , Type.ZONE :
			degats +=3
		Type.RALENTI:
			facteur_ralenti = maxf(facteur_ralenti - 0.08, 0.1)
	cadence.wait_time *= 0.85
	sprit.scale *= 1.1
		
func _input(event):
	if event.is_action_pressed("ui_accept"):
		ameliorer()
		print("niv ", niveau, " | dégâts ", degats, " | cadence ", cadence.wait_time)
