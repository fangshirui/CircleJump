extends Node

var score_file = "user://highscore.save"

var enable_sound = true
var enable_music = true

var circle_per_level = 5

var color_schemes = {
		"NEON1":{
			"background": Color8(0, 0, 0),
			"player_body": Color(203, 255, 0),
			"player_trail": Color(204, 0, 255),
			"circle_static": Color(0, 255, 102),
			"circle_limited": Color(204, 0, 255),
		},
	}

var theme = color_schemes["NEON1"]
