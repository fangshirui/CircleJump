extends Node

signal start_game

var buttons_tex_sound = {true: preload("res://assets/images/buttons/audioOn.png"),
false: preload("res://assets/images/buttons/audioOff.png")}
		
var buttons_tex_music = {true: preload("res://assets/images/buttons/musicOn.png"),
false: preload("res://assets/images/buttons/musicOff.png")}

var current_screen = null

func _ready():
	register_buttons()
	change_screen($TitleScreen)
	
func register_buttons():
	var buttons = get_tree().get_nodes_in_group("buttons")
	for button in buttons:
		button.connect("pressed", self, "_on_button_pressed", [button])

	
func change_screen(new_screen):
	if current_screen:
		current_screen.disappear()
		yield(current_screen.tween, "tween_completed")
	current_screen = new_screen
	if new_screen:
		current_screen.appear()
		yield(current_screen.tween, "tween_completed")
	
	
	
func _on_button_pressed(button : TextureButton):
	if Settings.enable_sound:
		SoundManager.play_se("click")
	match button.name:
		"Home":
			change_screen($TitleScreen)
		"Play":
			change_screen(null)
			yield(get_tree().create_timer(0.5), "timeout")
			emit_signal("start_game")
		"Settings":
			change_screen($SettingsScreen)
		"Sound":
			Settings.enable_sound = !Settings.enable_sound
			button.texture_normal = buttons_tex_sound[Settings.enable_sound]
		"Music":
			Settings.enable_music = !Settings.enable_music
			button.texture_normal = buttons_tex_music[Settings.enable_music]
			

func game_over(score, high_score):
	var score_box = $GameOverScreen/MarginContainer/VBoxContainer/Scores
	score_box.get_node("Score").text = "Score: %s" % str(score)
	score_box.get_node("Best").text =  "Best: %s" % str(high_score)
	change_screen($GameOverScreen)
