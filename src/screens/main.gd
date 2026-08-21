extends Control

signal semitone_change

@onready var main_menu_path := "res://src/screens/menus/main.tscn"
@onready var game_screen_path := "res://src/screens/game.tscn"
@onready var round_buffer_path := "res://src/screens/menus/round_buffer.tscn"
@onready var pause_menu_path := "res://src/screens/menus/pause.tscn"

@onready var RNG := RandomNumberGenerator.new()

var current_scene : Node
var paused : bool = false
var buffering : bool = false
var round_num : int = 1
var glitch_chance : float = 0
var appeared : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	RNG.randomize()
	current_scene = $Screen.get_children()[0]
	get_window().min_size = Vector2i(640, 360)


func _reset_vis_aud() -> void:
	$Screen.modulate = Color("#ffffff")
	modulate = Color("#ffffff")
	$TitleMusic.volume_db = -10
	$GameMusic.volume_db = -10


func _use_name(node: Node, target: String) -> bool:
	return node.name == target


func disable_screen() -> void:
	current_scene.process_mode = Node.PROCESS_MODE_DISABLED
	$Screen.modulate = Color(0.291, 0.291, 0.291, 1.0)


func enable_screen() -> void:
	current_scene.process_mode = Node.PROCESS_MODE_INHERIT
	$Screen.modulate = Color(1.0, 1.0, 1.0, 1.0)


func _process(_delta: float) -> void:
	current_scene = $Screen.get_children()[0]
	
	if Input.is_action_just_pressed("pause"):
		if $Screen.get_children().find_custom(_use_name.bind("MainMenu")) == -1:
			$SoundManager.play_sound("pause")
			paused = !paused
	
	if paused and !buffering:
		if get_children().find_custom(_use_name.bind("PauseMenu")) == -1:
			var pause_scene = load(pause_menu_path)
			var pause = pause_scene.instantiate()
			add_child(pause)
					
			pause.resume.connect(_resume)
			pause.reset.connect(_reset)
			pause.exit.connect(_exit)
		
		disable_screen()
	else:
		enable_screen()


func _game_win() -> void:
	if !buffering:
		var round_buffer = load(round_buffer_path)
		var rnd_buf = round_buffer.instantiate()
		
		rnd_buf.round_num = round_num
		
		add_child(rnd_buf)
		buffering = true
	
		$RoundBufferTimer.start()
		$SoundManager.play_sound("wave_complete")
	
	disable_screen()


func _resume() -> void:
	paused = false
	for view in get_children():
		if view.name == "PauseMenu":
			view.queue_free()


func _reset() -> void:
	var game_screen = load(game_screen_path)
	var game = game_screen.instantiate()
	$Screen.get_children()[0].queue_free()
	$Screen.add_child(game)
	
	glitch_chance += 0.02 * round_num
	game.set_glitch_chance(round_num, glitch_chance)
	if game.is_glitched():
		_change_game_semitones(24)
	else:
		_change_game_semitones(0)
	print("Chance to glitch next round: " + str(glitch_chance))
	
	if glitch_chance >= 1 and !appeared:
		$GameMusic.stop()
		$Danger.play()
		$Levi.show()
		appeared = true

	_resume()


func _exit() -> void:
	var main_menu = load(main_menu_path)
	var title = main_menu.instantiate()
	var vis_tween : Tween = create_tween()
	var aud_tween : Tween = create_tween()
	
	vis_tween.tween_property($Screen, "modulate", Color("000000"), 0.5)
	aud_tween.tween_property($GameMusic, "volume_db", linear_to_db(0.001), 0.5)
	
	await vis_tween.finished
	await aud_tween.finished
	
	$GameMusic.stop()
	$TitleMusic.play()
	_reset_vis_aud()
	
	$Screen.get_children()[0].queue_free()
	$Screen.add_child(title)
	
	title.start.connect(_on_game_start)
	_resume()


func _on_round_buffer_timeout() -> void:
	get_children()[get_children().find_custom(_use_name.bind("RoundBuffer"))]\
		.queue_free()
	buffering = false
	
	round_num += 1
	enable_screen()
	_reset()


func _on_game_start() -> void:
	var vis_tween : Tween = create_tween()
	var aud_tween : Tween = create_tween()
	
	vis_tween.tween_property(self, "modulate", Color("000000"), 1)
	aud_tween.tween_property($TitleMusic, "volume_db", linear_to_db(0.001), 1)
	
	await vis_tween.finished
	await aud_tween.finished
	
	$TitleMusic.stop()
	$GameMusic.play()
	
	_reset_vis_aud()
	_reset()


func _on_game_music_finished() -> void:
	$MusicDelay.wait_time = RNG.randi_range(3, 10)
	$MusicDelay.start()


func _on_music_delay_timeout() -> void:
	$GameMusic.play()


func _change_game_semitones(semitones: float) -> void:
	if ceil($GameMusic.stream.get_random_pitch_semitones()) == semitones:
		return
		
	$GameMusic.stream.set_random_pitch_semitones(semitones)
	semitone_change.emit()


func _on_screen_child_entered_tree(node: Node) -> void:
	await node.ready
	
	if node.name.begins_with("Game"):
		node.win.connect(_game_win)


func _on_semitone_change() -> void:
	$GameMusic.play()


func _on_levi_close() -> void:
	$Danger.stop()
	$SoundManager.play_sound("roar")
	$Levi.hide()
	get_tree().quit()
