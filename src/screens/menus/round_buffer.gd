extends Control


var round_num : int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.name = "MainMenu"
	$Label.text = "Round " + str(round_num) + " End"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
