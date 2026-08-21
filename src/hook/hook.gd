extends RigidBody2D

signal reeled

@export var reel_speed : float = 250.0
@export var min_reel_stop : float = 5

var origin : Vector2 = Vector2(0, 0)
var returning : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.name = "Hook"
	origin = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if returning:
		var distance = position.distance_to(origin)
		var direction = position.direction_to(origin)
		
		if distance <= min_reel_stop:
			reeled.emit()
			queue_free()
		
		linear_velocity = direction * reel_speed


func _on_collided(body: Node) -> void:
	if body.name == "Borders":
		returning = true
