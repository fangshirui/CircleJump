extends Node2D

var Circle = preload("res://src/Objects/Circle.tscn")

var Jumper = preload("res://src/Objects/Jumper.tscn")

var player
var score = 0 setget set_score
var high_score = 0 
var level = 0


func  _ready() -> void:
	randomize()
	$HUD.hide()
	
	# 加载最高分
	load_score()
	
	
func new_game():
	
	
	self.score = 0
	level = 1
	
	$HUD.show()
	$HUD.show_massage("Go!")
	
	if Settings.enable_music:
		SoundManager.play_bgm("bgm")
	
	
	yield(get_tree().create_timer(1),"timeout")
	
	$Camera2D.position = $StartPosition.position
	player = Jumper.instance()
	player.position = $StartPosition.position
	add_child(player)
	
	player.connect("captured", self, "_on_Jumper_captured")
	player.connect("died", self, "_on_Jumper_died")
	
	spawn_circle($StartPosition.position)
	
func spawn_circle(_position = null):
	var c = Circle.instance()
	if  !_position :
		var x = rand_range(-150, 150)
		var y = rand_range( -500, -400)
		_position = player.target.position + Vector2(x, y)
	add_child(c)
	c.init(_position)
	
func _on_Jumper_captured(object):
	$Camera2D.position = object.position
	
#	spawn_circle() ,采用延迟调用。因为涉及到在树中添加系节点
	call_deferred("spawn_circle")
	self.score += 1
	
func set_score(value):
	score = value
	$HUD.update_score(score)
	
	# 设置关卡提示
	if score > 0 and score % Settings.circle_per_level == 0:
		level += 1
		$HUD.show_massage(
			"Level %s" % str(level)
		)
		

func _on_Jumper_died():
	
	if score > high_score:
		high_score = score
		save_score()
	get_tree().call_group("circles", "implode")
	$Screens.game_over(score, high_score)
	$HUD.hide()
	if Settings.enable_music:
		SoundManager.stop_bgm()
	if Settings.enable_sound:
		SoundManager.stop_se()
		

func load_score():
	var f = File.new()
	if f.file_exists(Settings.score_file):
		f.open(Settings.score_file, File.READ)
		high_score = f.get_var()
		f.close()
		
func save_score():
	var f = File.new()
	f.open(Settings.score_file, File.WRITE)
	f.store_var(high_score)
	f.close()
	
