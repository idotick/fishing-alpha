extends Node2D


@export var mass : float = 20
@export var spring_constant: float = 0.015
@export var dampening: float = 0.05


var height : float
var target_height : float
var velocity : float

func _initialize(m, k, d) -> void:
	height = position.y
	target_height = position.y
	velocity = 0
	
	mass = m
	spring_constant = k
	dampening = d


func _update() -> void:
	height = position.y
	
	var x = height - target_height
	var loss = - dampening * velocity
	var force = - spring_constant * x + loss
	
	velocity += force/mass
	
	position.y += velocity
