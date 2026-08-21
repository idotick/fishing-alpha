extends Control

signal start

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.name = "MainMenu"
	$Title._initialize(50, 0.020, 0)
	$Title.position.y = -15


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$Title._update()


func _on_button_pressed() -> void:
	$SoundManager.play_sound("click")
	start.emit()
