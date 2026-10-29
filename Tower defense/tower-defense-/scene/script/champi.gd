extends RigidBody2D
var life = 10
var fini := false
var vitesse := 200.0
var facteur := 1.0
var ralenti_restant := 0.0
@onready var path_follow: PathFollow2D = get_parent()
@onready var animation : AnimatedSprite2D = $AnimatedSprite2D
signal dead
func _ready() -> void:
	add_to_group("ennemis")

func _ralentir(f:float , duree: float):
	facteur = f
	ralenti_restant=duree



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	animation.play("walk")
	if ralenti_restant > 0.0:
		ralenti_restant -= delta
		$AnimatedSprite2D.modulate = Color.CADET_BLUE
	else:
		facteur = 1.0
	path_follow.progress += vitesse * facteur * delta
	if path_follow.progress_ratio >= 1.0 and not fini:
		fini = true
		Global.spawn -= 1
		print("ARRIVÉ AU BOUT | spawn = ", Global.spawn)
		path_follow.queue_free()


func take_dammage(amount:int):
	if fini:
		return
	life -= amount
	if life <= 0 :
		fini = true
		Global.gold +=1
		print("MORT | spawn = ", Global.spawn)
		Global.spawn -=1
		get_parent().queue_free()
