extends Control

signal close

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_levi_visibility_changed() -> void:
	$AnimatedSprite2D.play("default")


func _on_levi_finished() -> void:
	close.emit()
