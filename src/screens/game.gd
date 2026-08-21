extends Node2D

signal win
signal glitch_change(round_num: int)

@onready var hook : PackedScene = preload("res://src/hook/hook.tscn")
@onready var fish_pathway : PackedScene = preload("res://src/fish/fish_path.tscn")

@export var num_of_fish_rows : int = 4
@export var path_margin : float = 100
@export var hook_limit : int = 1
@export var splash_probability : float = 0.01
@export var win_catch : float = 0.50

@onready var RNG = RandomNumberGenerator.new()
@onready var score : float = 0
@onready var glitched : bool = false


var max_score : int = 0
var active_hooks : Array[Node2D] = []
var glitch_chance : float = 0


func set_glitch_chance(rnd: int, chance: float):
	glitch_chance = chance
	
	glitch_change.emit(rnd)


func is_glitched() -> bool:
	return glitched


func _ready() -> void:
	RNG.randomize()
	self.name = "Game"
	
	for i in range(num_of_fish_rows):
		var path = fish_pathway.instantiate()
		
		var path_interval = (get_viewport_rect().size.y - \
			$Water.position.y - path_margin)/num_of_fish_rows
		
		path.position.y = $Water.position.y + path_margin + path_interval * i
		
		$Fishes.add_child(path)
		
		for fish in path.fishes:
			fish.killed.connect(_scored)
			max_score += 5
	
	print("Win condition: " + str(win_catch * max_score))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if score >= win_catch * max_score:
		win.emit()
	
	$String.clear_points()
	$Score.set_text(str(int(score)))
	
	var n_springs = $Water.water_springs.size()
	var r_index = RNG.randi_range(0, n_springs/splash_probability)
	if r_index < n_springs - 1:
		$Water.splash(r_index, RNG.randi_range(-1, 1))
	
	if Input.is_action_just_pressed("cast") and active_hooks.size() < hook_limit:
		$SoundManager.play_sound("cast")
		var new_hook = hook.instantiate()
		new_hook.global_position = $Player.get_string_end()
		new_hook.reeled.connect(_allow_hook_gen)
		
		add_child(new_hook)
		active_hooks.append(new_hook)
	
	if active_hooks.size() >= hook_limit:
		$Player.frozen = true
	
	for h in active_hooks:
		$String.add_point($Player.get_string_end())
		$String.add_point(h.global_position)


func _allow_hook_gen() -> void:
	$Player.frozen = false
	active_hooks.pop_front()


func _scored():
	$SoundManager.play_sound("score")
	score += 5


func _on_glitch_change(round_num: int) -> void:
	if RNG.randf() < glitch_chance:
		$Player.SPEED *= randf_range(4, 7)
		modulate = Color("80448aff")
		glitched = true
		hook_limit += round_num
	else:
		modulate = Color("ffffffff")
	
	for path in $Fishes.get_children():
		path.set_glitched(glitched)
	
	$Water._determine_shader_tint(glitched)
