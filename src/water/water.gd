extends StaticBody2D


@onready var spring : PackedScene = preload("res://src/water/spring.tscn")

@export var pivot_distance : float = 64.0
@export var pivot_mass : float = 20
@export var spread : float = 0.0003

@export var spring_constant: float = 0.015
@export var target_height : float = 80
@export var dampening: float = 0.05

var water_springs: Array = []


func _determine_shader_tint(is_glitching) -> void:
	$Area.material.set_shader_parameter("glitch", is_glitching)


func _ready() -> void:
	var n_pivot = get_viewport_rect().size.x/pivot_distance + 1
	$Collision.polygon.clear()
	
	for i in range(n_pivot):
		var water_spring = spring.instantiate()
		
		water_spring._initialize(pivot_mass, spring_constant, dampening)
		
		water_spring.position.x = pivot_distance * i
		
		water_springs.append(water_spring)
		add_child(water_spring)
	
	splash(1, 2)


func _physics_process(_delta: float) -> void:
	for s in water_springs:
		s._update()
	
	var left_deltas = []
	var right_deltas = []
	
	for i in range(water_springs.size()):
		left_deltas.append(0)
		right_deltas.append(0)
	
	for i in range(water_springs.size()):
		if i > 0:
			left_deltas[i] = spread * (water_springs[i].height - water_springs[i - 1].height)
			water_springs[i - 1].velocity += left_deltas[i]
		
		if i < water_springs.size() - 1:
			right_deltas[i] = spread * (water_springs[i].height - water_springs[i + 1].height)
			water_springs[i + 1].velocity += right_deltas[i]
	
	var vertices = []
	for i in range(water_springs.size()):
		if i < water_springs.size() - 1:
			vertices.append(water_springs[i].position)
		else:
			var f_spring = water_springs[0]
			var l_spring = water_springs[i]
			
			var screen_size = get_viewport_rect().size
			
			vertices.append(l_spring.position)
			vertices.append(Vector2(screen_size.x, l_spring.position.y))
			vertices.append(Vector2(screen_size.x, screen_size.y))
			vertices.append(Vector2(f_spring.position.x, screen_size.y))
	
	$Collision.polygon = vertices
	$Area.polygon = vertices
		


func splash(index, speed) -> void:
	water_springs[index].velocity += speed
