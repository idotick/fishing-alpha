extends Node2D

signal killed

@export var glitched : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Glitched.visible = glitched
	$Default.visible = !glitched


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
