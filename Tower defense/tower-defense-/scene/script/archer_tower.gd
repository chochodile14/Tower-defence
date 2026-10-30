class_name Tour
extends Node2D
var prix_amelio = 10
enum Type {SOLO,ZONE,RALENTI}
var type = Type.RALENTI
@export var degats := 5
@onready var sprit : Sprite2D = $Archer
@onready var portee: Area2D = $Portee
@onready var cadence: Timer = $Timer
const NIVEAU_MAX := 3
var niveau := 0
var niveau_futur = niveau +1
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
			cible[0].take_dammage(degats)
		Type.ZONE:
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
	Global.gold -= prix_amelio
	prix_futur()
	if niveau_futur != NIVEAU_MAX:
		niveau_futur +=1


func _action_amelio():
		if Global.gold >= prix_amelio :
			ameliorer()
		else:
			print("pas asser d'or")
		print("niv ", niveau, " | dégâts ", degats, " | cadence ", cadence.wait_time)

func texte_stat_actuelle() -> String:
	match type:
		Type.SOLO, Type.ZONE:
			return "Degats: %d" % degats
		Type.RALENTI:
			return "Degats: %d%%" % int((1.0 - facteur_ralenti )*100)
	return""


func texte_stat_future() -> String:
	if niveau >= NIVEAU_MAX:
		return "MAX"
	match type:
		Type.SOLO, Type.ZONE:
			return "Dégâts: %d" % (degats + 3)
		Type.RALENTI:
			return "Ralenti: %d%%" % int((1.0 - maxf(facteur_ralenti - 0.08, 0.1)) * 100)
	return ""


func prix_futur():
	prix_amelio = 30 * niveau
