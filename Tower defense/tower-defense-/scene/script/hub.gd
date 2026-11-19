extends Control

## Scène lancée par « Start » : à renseigner dans l'inspecteur (nœud Hub > Scene Jeu).
@export_file("*.tscn") var scene_jeu: String = ""

const DUREE_FONDU := 0.45

@onready var _boutons: Array = [%Start, %Credits, %Quit]

var _pret := false      # vrai quand l'intro est terminée
var _occupe := false    # vrai pendant le fondu de sortie
var _actif: Button = null
var _tween_intro: Tween
var _tween_curseur: Tween
var _tweens_boutons := {}


func _ready() -> void:
	%Start.pressed.connect(_on_start_pressed)
	%Credits.pressed.connect(_ouvrir_credits)
	%Quit.pressed.connect(_on_quit_pressed)
	%Retour.pressed.connect(_fermer_credits)
	for b in _boutons:
		b.mouse_entered.connect(_selectionner.bind(b))
		b.focus_entered.connect(_selectionner.bind(b))
		b.pressed.connect(_ecraser.bind(b))
	_intro()


# ---------------------------------------------------------------- INTRO

func _intro() -> void:
	# État de départ : tout est caché sous un voile noir.
	%Voile.color.a = 1.0
	%Filet.scale.x = 0.0
	%Losange.scale = Vector2.ZERO
	%Plaque.modulate.a = 0.0
	for b in _boutons:
		b.modulate.a = 0.0

	# Les tailles ne sont connues qu'après la première mise en page.
	await get_tree().process_frame
	for c in [%Filet, %Losange, %Plaque] + _boutons:
		c.pivot_offset = c.size / 2.0
	%Plaque.scale = Vector2(0.94, 0.94)
	for b in _boutons:
		b.scale = Vector2(0.88, 0.88)

	var t := create_tween().set_parallel(true)
	_tween_intro = t
	t.tween_property(%Voile, "color:a", 0.0, 0.7)
	t.tween_property(%Filet, "scale:x", 1.0, 0.55).set_delay(0.2) \
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	t.tween_property(%Losange, "scale", Vector2.ONE, 0.4).set_delay(0.45) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	t.tween_property(%Plaque, "modulate:a", 1.0, 0.5).set_delay(0.5)
	t.tween_property(%Plaque, "scale", Vector2.ONE, 0.6).set_delay(0.5) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	for i in _boutons.size():
		var b: Button = _boutons[i]
		var d := 0.9 + i * 0.12
		t.tween_property(b, "modulate:a", 1.0, 0.25).set_delay(d)
		t.tween_property(b, "scale", Vector2.ONE, 0.45).set_delay(d) \
			.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	t.tween_callback(_fin_intro).set_delay(1.6)


func _fin_intro() -> void:
	if _pret:
		return
	_pret = true
	%Start.grab_focus()  # déclenche _selectionner(Start) : curseur + mise en avant


func _input(event: InputEvent) -> void:
	# Un clic ou une touche pendant l'intro la termine tout de suite.
	if _tween_intro and not _pret and _tween_intro.is_running():
		if (event is InputEventMouseButton or event is InputEventKey) and event.is_pressed():
			_tween_intro.custom_step(10.0)
			get_viewport().set_input_as_handled()
			return
	if event.is_action_pressed("ui_cancel") and %PageCredits.visible:
		_fermer_credits()
		get_viewport().set_input_as_handled()


# ------------------------------------------------- SURVOL / SÉLECTION

func _selectionner(b: Button) -> void:
	if not _pret or _occupe or b == _actif:
		return
	var premier := _actif == null
	_actif = b
	for autre in _boutons:
		var choisi: bool = (autre == b)
		var ancien: Tween = _tweens_boutons.get(autre)
		if ancien:
			ancien.kill()
		var t := create_tween().set_parallel(true)
		_tweens_boutons[autre] = t
		t.tween_property(autre, "scale", Vector2.ONE * (1.0 if choisi else 1.0), 0.18) \
			.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		t.tween_property(autre, "modulate", Color.WHITE if choisi else Color(0.78, 0.78, 0.78), 0.18)
	_placer_curseur(b, premier)


func _placer_curseur(b: Button, instantane := false) -> void:
	var y := b.global_position.y + b.size.y / 2.0 - 8.0
	var cible_g := Vector2(b.global_position.x - 30.0, y)
	var cible_d := Vector2(b.global_position.x + b.size.x + 28.0, y)
	if _tween_curseur:
		_tween_curseur.kill()
	_tween_curseur = create_tween().set_parallel(true)
	if instantane:
		%CurseurG.global_position = cible_g
		%CurseurD.global_position = cible_d
		_tween_curseur.tween_property(%CurseurG, "modulate:a", 1.0, 0.3)
		_tween_curseur.tween_property(%CurseurD, "modulate:a", 1.0, 0.3)
	else:
		_tween_curseur.tween_property(%CurseurG, "global_position", cible_g, 0.18) \
			.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		_tween_curseur.tween_property(%CurseurD, "global_position", cible_d, 0.18) \
			.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)


# Petit « écrasement » au clic : la touche cartoon, discrète.
func _ecraser(b: Button) -> void:
	var ancien: Tween = _tweens_boutons.get(b)
	if ancien:
		ancien.kill()
	var t := create_tween()
	_tweens_boutons[b] = t
	t.tween_property(b, "scale", Vector2(0.94, 0.94), 0.06)
	t.parallel().tween_property(b, "modulate", Color.WHITE, 0.06)
	t.tween_property(b, "scale", Vector2.ONE * 1.05, 0.18) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


# ----------------------------------------------------------- ACTIONS

func _on_start_pressed() -> void:
#	if _occupe:
#		return
#	if scene_jeu.is_empty():
#		push_error("Hub : renseigne « Scene Jeu » dans l'inspecteur (nœud Hub).")
#		return
	await _sortie()
	get_tree().change_scene_to_file("res://scene/game/game.tscn")


func _on_quit_pressed() -> void:
	if _occupe:
		return
	await _sortie()
	get_tree().quit()


func _sortie() -> void:
	_occupe = true
	var t := create_tween()
	t.tween_property(%Voile, "color:a", 1.0, DUREE_FONDU)
	await t.finished


# ----------------------------------------------------------- CRÉDITS

func _ouvrir_credits() -> void:
	if _occupe or %PageCredits.visible:
		return
	for b in _boutons:
		b.focus_mode = Control.FOCUS_NONE
	%PageCredits.modulate.a = 0.0
	%PageCredits.visible = true
	await get_tree().process_frame
	%PanelCredits.pivot_offset = %PanelCredits.size / 2.0
	%PanelCredits.scale = Vector2(0.92, 0.92)
	var t := create_tween().set_parallel(true)
	t.tween_property(%PageCredits, "modulate:a", 1.0, 0.25)
	t.tween_property(%PanelCredits, "scale", Vector2.ONE, 0.4) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	%Retour.grab_focus()


func _fermer_credits() -> void:
	if not %PageCredits.visible:
		return
	var t := create_tween()
	t.tween_property(%PageCredits, "modulate:a", 0.0, 0.2)
	await t.finished
	%PageCredits.visible = false
	for b in _boutons:
		b.focus_mode = Control.FOCUS_ALL
	%Credits.grab_focus()
