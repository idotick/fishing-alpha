extends Path2D

signal glitch_change

@onready var fish : PackedScene = preload("res://src/fish/fish.tscn")
@onready var RNG : RandomNumberGenerator = RandomNumberGenerator.new()

var glitching : bool = false
var paths : Array[PathFollow2D] = []
var fishes : Array[Node2D] = []
var path_direct: Array[int] = []


func _ready() -> void:
	RNG.randomize()
	
	var n_fishes = RNG.randi_range(5, 15)
	
	for i in n_fishes:
		var follow = PathFollow2D.new()
		var fih = fish.instantiate()
		fih.type = RNG.randi_range(1, 9)
		
		fishes.append(fih)
		
		self.add_child(follow)
		follow.add_child(fih)
		
		path_direct.append([-1, 1].pick_random())
		follow.progress_ratio = RNG.randf()


func set_glitched(switch: bool):
	glitching = switch
	glitch_change.emit()


func _process(_delta: float) -> void:
	paths.clear()
	fishes.clear()
	
	for path in get_children():
		paths.append(path)
		for fih in path.get_children():
			fishes.append(fih)
	
	for i in range(paths.size()):
		paths[i].progress_ratio += path_direct[i] * RNG.randf()/500
		fishes[i]._flip_sprite(path_direct[i] > 0)
	
	
	for i in range(paths.size()):
		if RNG.randf() < 0.1 and fishes[i].glitching:
			path_direct[i] = [-1, 1].pick_random()


func _on_glitch_change() -> void:
	for fih in fishes:
		fih.set_glitched(glitching)
