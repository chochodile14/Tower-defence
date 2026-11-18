extends ScrollContainer
@export var text_node : RichTextLabel
@export_range(1,1000000,0.1) var credit_timer: float = 1.0
@export_range(1,1000000,0.1) var margin_increment: float = 0
@onready var margin : MarginContainer = $MarginContainer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = create_tween()
	await get_tree().create_timer(0.01).timeout
	var text_box_size = text_node.size.y
	var windows_size = DisplayServer.window_get_size().y
	margin.add_theme_constant_override("margin_top", windows_size + margin_increment)
	margin.add_theme_constant_override("margin_bottom", windows_size + margin_increment)
	var scroll_amount = ceil(text_box_size * 3/4 + windows_size * 2 + margin_increment)
	tween.tween_property(
		self,
		"scroll_vertical",
		scroll_amount,
		credit_timer
	)
	
	tween.play()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
