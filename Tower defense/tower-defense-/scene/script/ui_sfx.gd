extends Node

const DOSSIER := "res://scene/sfx battle/"
const VARIANTES := 6        
const NB_LECTEURS := 12     
const SONS := {
	"survol":  ["DSGNTonl_INTERFACE-Tonal Click", -14.0],
	"clic":    ["UIClick_INTERFACE-Metallic Click", -4.0],
	"achat":   ["DSGNTonl_USABLE-Coin Spend", -8.0],
	"amelio":  ["DSGNSynth_BUFF-Stats Up", -8.0],
	"refus":   ["UIMisc_INTERFACE-Denied", -4.0],
	"defaite": ["DSGNMisc_SKILL IMPACT-Dramatic Finish", -6.0],
}

var _lecteurs: Array[AudioStreamPlayer] = []
var _suivant := 0
var _cache := {}


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	for i in NB_LECTEURS:
		var lecteur := AudioStreamPlayer.new()
		add_child(lecteur)
		_lecteurs.append(lecteur)
	# Chaque noeud qui entre dans le jeu est inspecté : si c'est un bouton, on le branche.
	get_tree().node_added.connect(_brancher)
	_brancher_arbre(get_tree().root)


func _brancher_arbre(noeud: Node) -> void:
	_brancher(noeud)
	for enfant in noeud.get_children():
		_brancher_arbre(enfant)


func _brancher(noeud: Node) -> void:
	var bouton := noeud as BaseButton
	if bouton == null or bouton.has_meta("sfx_branche"):
		return
	bouton.set_meta("sfx_branche", true)
	bouton.mouse_entered.connect(_sur_survol.bind(bouton))
	bouton.pressed.connect(jouer.bind("clic"))


func _sur_survol(bouton: BaseButton) -> void:
	if not bouton.disabled:
		jouer("survol")


func jouer(role: String) -> void:
	if not SONS.has(role):
		push_warning("UiSfx : son inconnu '%s'" % role)
		return
	var infos: Array = SONS[role]
	var chemin := "%s%s_HY_PC-%03d.wav" % [DOSSIER, infos[0], randi_range(1, VARIANTES)]
	if not ResourceLoader.exists(chemin):
		push_warning("UiSfx : fichier introuvable : " + chemin)
		return
	if not _cache.has(chemin):
		_cache[chemin] = load(chemin)
	var lecteur := _lecteurs[_suivant]
	_suivant = (_suivant + 1) % NB_LECTEURS
	lecteur.stream = _cache[chemin]
	lecteur.volume_db = infos[1]
	lecteur.pitch_scale = randf_range(0.96, 1.04)
	lecteur.play()
