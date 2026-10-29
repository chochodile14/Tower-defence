extends Button
const TOUR_SCENE = preload("res://scene/tower/archer_tower.tscn")
const PRIX= {
	Tour.Type.SOLO : 25,
	Tour.Type.RALENTI : 35,
	Tour.Type.ZONE : 40,
}
@onready var PanelTower : VBoxContainer = $PanelTower
@onready var PanelUpgrade : VBoxContainer = $PanelUpgrade
signal demande_menu(emplacement)
signal Panel_Open(panel)
var tour = null

func _ready() -> void:
	add_to_group("emplacement")
	PanelTower.visible = false
	pressed.connect(_on_pressed)
	$"PanelTower/Light tower".pressed.connect(func(): _acheter(Tour.Type.RALENTI))
	$"PanelTower/Bomber tower".pressed.connect(func(): _acheter(Tour.Type.ZONE))
	$"PanelTower/Archer tower".pressed.connect(func(): _acheter(Tour.Type.SOLO))


func _on_pressed():
	demande_menu.emit(self)
	if tour != null:
		return
	for e in get_tree().get_nodes_in_group("emplacement"):
		if e != self:
			e.PanelTower.visible = false
			e.PanelUpgrade.visible = true
	PanelTower.visible = not PanelTower.visible
	PanelUpgrade.visible = not PanelUpgrade.visible

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
	
