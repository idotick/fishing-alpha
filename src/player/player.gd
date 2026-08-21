extends CharacterBody2D


var SPEED = 150.0

@onready var string_x = $StringStart.position.x
var frozen : bool = false


func get_string_end() -> Vector2:
	return $StringEnd.global_position


func _process(_delta: float) -> void:
	$Hook.visible = !frozen
	$Hook.position = $StringEnd.position
	
	if velocity.x < 0:
		$Sprite.play("left")
		$Hook.hide()
	elif velocity.x > 0:
		$Sprite.play("right")
		$Hook.hide()
	else:
		$String.clear_points()
		$String.add_point($StringStart.position)
		$String.add_point($StringEnd.position)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	var direction := Input.get_axis("left", "right")
	if direction and !frozen:
		$String.clear_points()
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$Sprite.play("default")
		
	move_and_slide()
