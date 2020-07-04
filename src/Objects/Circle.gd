extends Area2D


export var radius = 100 # 当前圆圈的大小

enum MODES {STATIC, LIMITED}  # Static 状态不倒计时， limited 状态开始倒计时


var mode = MODES.STATIC

var move_range = 100
var move_time = 1.0 

var speed_rotation = PI   # 弧度制，每秒转180度
var margin = 25 # 箭头于圆圈的间隔

var num_orbit = 3 # 倒计时时间 3s
var current_orbit = 0  # 当前倒计时时间
var orbit_start = null # 箭头刚被捕获时，相对圆圈的角度

var jumper = null  # 捕获的玩家箭头节点

onready var orbit_position = $Pivot/OrbitPosition


# 初始化
func init(_position, _radius = radius, _mode = MODES.LIMITED):
	position = _position
	radius = _radius
	
	# 初始转圈的方向为随机顺时针或者逆时针
	speed_rotation *= pow(-1, randi() % 2)
	
	# 给每个圆圈定义颜色,首先使圆圈材料资源独立
#	$Sprite.material = $Sprite.material.duplicate()
#
#	$SpriteEffect.material = $Sprite.material
	
	set_mode(_mode)	
	
	# 圆圈的大小不是固定的，需要动态调整碰撞图形大小以适应当前大小。
	# 首先要使的当前圆圈大小的属性生效
	var tex_scale = radius * 2 / $Sprite.texture.get_size().x  
	
	$Sprite.scale = Vector2.ONE * tex_scale 
	
	# 调整碰撞图形的大小,为防止所有圆圈共用这个资源，需要另外设置
	$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate()
	$CollisionShape2D.shape.radius = radius 
	
	
	# 调整OrbitPostion 的长度
	orbit_position.position.x = radius + margin 
	
#	print(orbit_position.position)
	
	# 设置移动
	set_tween()
	
	
	
# warning-ignore:unused_argument
func _physics_process(delta: float) -> void:
	$Pivot.rotate(speed_rotation * delta)
	
	if mode == MODES.LIMITED and jumper:
		check_orbits()


# 倒计圈数（相当于倒计时）
func check_orbits():
	if abs($Pivot.rotation - orbit_start) > (2 * PI):
		current_orbit -= 1
		
		if Settings.enable_sound:
			SoundManager.play_se("beep")
			
		if current_orbit <= 0:
			jumper.die()
			jumper = null
			implode()
			
		$Label.text = str(current_orbit)
		orbit_start = $Pivot.rotation 




# 内部爆炸
func implode():
	$AnimationPlayer.play("implode")
	yield($AnimationPlayer, "animation_finished")
	queue_free()
	
# 捕获箭头
func captured(target):
	jumper = target
	$AnimationPlayer.play("captured")
	
	# 使接收箭头的圆圈的初始臂指向箭头来的方向
	$Pivot.rotation = (jumper.position - position).angle()
	
	orbit_start = $Pivot.rotation

# 判别圆圈当前状态给予颜色赋值，状态显示
func set_mode(_mode):
	mode = _mode
	var color
	match mode:
		MODES.STATIC:
			$Label.hide()
		MODES.LIMITED:
			current_orbit = num_orbit
			$Label.text = str(current_orbit) 
			$Label.show()
	color = Settings.theme["circle_static"]
	$Sprite.material.set_shader_param("color", color)
	
func set_tween(object = null, _key = null):
	move_range *= -1
	$MoveTween.interpolate_property(self, "position:x", position.x , position.x + move_range,move_time,Tween.TRANS_QUAD, Tween.EASE_IN_OUT )
	$MoveTween.start()

