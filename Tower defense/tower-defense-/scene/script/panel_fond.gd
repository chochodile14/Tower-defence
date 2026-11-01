extends VBoxContainer
# Dessine un fond (le style "panel" du thème) DERRIÈRE le contenu du VBoxContainer.
# Pourquoi : un VBoxContainer n'a pas de fond. Ce script évite de changer le type du noeud
# (donc aucun chemin $"..." ni signal à modifier dans emplacement.gd).

const MARGE := 12.0   # le fond dépasse du contenu de 12 px de chaque côté

func _ready() -> void:
	resized.connect(queue_redraw)
	sort_children.connect(queue_redraw)


func _draw() -> void:
	var style := get_theme_stylebox("panel", "PanelContainer")
	var zone := Rect2(Vector2(-MARGE, -MARGE), size + Vector2(MARGE, MARGE) * 2.0)
	draw_style_box(style, zone)
