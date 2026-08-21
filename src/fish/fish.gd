extends Node2D

signal killed
signal glitch_change

@export var glitching : bool = false
@export var type : int = 1


func _flip_sprite(flip_h: bool) -> void:
	$Sprite.flip_h = flip_h


func _ready() -> void:
	_on_glitch_change()


func _process(_delta: float) -> void:
	pass


func _on_fish_body_entered(body: Node2D) -> void:
	if body.name.begins_with("Hook"):
		killed.emit()
		if glitching:
			$Sprite.play("glitchdeath")
		else:
			$Sprite.play("fishdeath")


func _on_animation_finished() -> void:
	self.get_parent().queue_free()


func set_glitched(switch: bool) -> void:
	glitching = switch
	glitch_change.emit()


func _on_glitch_change() -> void:
	if glitching:
		$Sprite.play("glitch" + str(type))
	else:
		$Sprite.play("fish" + str(type))
