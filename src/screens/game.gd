extends Node2D



@onready var fish_pathway : PackedScene = preload("res://src/fish/fish_path.tscn")
@export var num_of_fish_rows : int = 4
@export var path_margin : float = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(num_of_fish_rows):
		var path = fish_pathway.instantiate()
		
		var path_interval = (get_viewport_rect().size.y - \
			$Water.position.y - path_margin)/num_of_fish_rows
		
		
		path.position.y = $Water.position.y + path_margin + path_interval * i
		
		add_child(path)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
