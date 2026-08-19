extends Control



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	var game : Node = preload("res://src/screens/game.tscn").instantiate()
	var vis_tween : Tween = create_tween()
	var aud_tween : Tween = create_tween()
	
	vis_tween.tween_property(self, "modulate", Color("000000"), 1)
	aud_tween.tween_property($Music, "volume_db", linear_to_db(0.001), 1)
	
	await vis_tween.finished
	await aud_tween.finished
	
	self.get_parent().add_child(game)
	self.queue_free()
