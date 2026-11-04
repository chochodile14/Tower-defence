extends RigidBody2D
var life = 10
var fini := false
var vitesse := 200.0
var facteur := 1.0
var ralenti_restant := 0.0
var flash_tween :Tween
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
	if Global.life <= 0 :
		animation.play("Death")
	else :
		animation.play("walk")
	if ralenti_restant > 0.0:
		ralenti_restant -= delta
		$AnimatedSprite2D.modulate = Color.CADET_BLUE
	else:
		facteur = 1.0
	path_follow.progress += vitesse * facteur * delta
	if path_follow.progress_ratio > 0.85:
		print("CHAMPI position = ", global_position, " | ratio = ", path_follow.progress_ratio)

func take_dammage(amount:int):
	if fini:
		return
	life -= amount
	if flash_tween:
		flash_tween.kill()
	
	$AnimatedSprite2D.modulate = Color.FIREBRICK
	flash_tween=create_tween()
	flash_tween.tween_property($AnimatedSprite2D,"modulate" , Color.WHITE,0.15)
	if life <= 0 :
		fini = true
		Global.gold +=1
		print("MORT | spawn = ", Global.spawn)
		$AnimatedSprite2D.play("Death")
		print("Anim: ", animation.animation, " | joue: ", animation.is_playing())
		await get_tree().create_timer(0.3).timeout
		print("Après 0.3s: ", animation.animation)
		Global.spawn -=1
		get_parent().queue_free()
