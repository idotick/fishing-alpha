extends Control

signal resume
signal reset
signal exit


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		queue_free()


func _on_resume_pressed() -> void:
	$SoundManager.play_sound("click")
	resume.emit()


func _on_reset_pressed() -> void:
	$SoundManager.play_sound("click")
	reset.emit()


func _on_exit_pressed() -> void:
	$SoundManager.play_sound("click")
	exit.emit()
