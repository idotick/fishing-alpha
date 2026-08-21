extends Node

@onready var wave_complete = $WaveComplete
@onready var cast = $Cast
@onready var score = $Score
@onready var click = $Click
@onready var pause = $Pause
@onready var roar = $ROAR

func play_sound(key):
	var sound = get(key)
	if sound is AudioStreamPlayer:
		sound.play()
	else:
		print("Sound " + key + " not found!")
