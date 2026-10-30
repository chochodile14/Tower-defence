extends Button
const TOUR_SCENE = preload("res://scene/tower/archer_tower.tscn")
const PRIX= {
	Tour.Type.SOLO : 25,
	Tour.Type.RALENTI : 35,
	Tour.Type.ZONE : 40,
}
@onready var StatPre : Label = $PanelUpgrade/StatPre
@onready var StatAft : Label = $PanelUpgrade/StatAft
@onready var PrixAmelio : Label = $PanelUpgrade/PrixAmelio
@onready var PanelTower : VBoxContainer = $PanelTower
@onready var PanelUpgrade : VBoxContainer = $PanelUpgrade
signal demande_menu(emplacement)
signal Panel_Open(panel)
var tour = null

func _ready() -> void:
	add_to_group("emplacement")
	PanelUpgrade.visible = false
	PanelTower.visible = false
	pressed.connect(_on_pressed)
	$"PanelTower/Light tower".pressed.connect(func(): _acheter(Tour.Type.RALENTI))
	$"PanelTower/Bomber tower".pressed.connect(func(): _acheter(Tour.Type.ZONE))
	$"PanelTower/Archer tower".pressed.connect(func(): _acheter(Tour.Type.SOLO))


func _on_pressed():
	demande_menu.emit(self)
	for e in get_tree().get_nodes_in_group("emplacement"):
		if e != self:
			e.PanelTower.visible = false
			e.PanelUpgrade.visible = false
	if tour != null:
		_maj_panel_upgrade()
		PanelUpgrade.visible = not PanelUpgrade.visible
	else:
		PanelTower.visible = not PanelTower.visible
	

func _acheter(type: Tour.Type):
	if tour !=null:
		return
	var prix = PRIX[type]
	if Global.gold < prix :
		print("pas asser d'or")
		return
	Global.gold -= prix
	tour = TOUR_SCENE.instantiate()
	tour.type = type
	get_parent().add_child(tour)
	tour.global_position = global_position + size/2
	PanelTower.visible = false
	
func _maj_panel_upgrade():
	if tour == null:
		return
	StatAft.text = tour.texte_stat_future()
	StatPre.text = tour.texte_stat_actuelle()
	PrixAmelio.text = tour.texte_prix()


func _on_amelio_pressed() -> void:
	tour._action_amelio()
	_maj_panel_upgrade()
