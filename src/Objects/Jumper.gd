extends Area2D

signal captured
signal died

var velocity = Vector2(100,0)
var jump_speed = 1000
var target = null
var trail_length = 25

onready var trail = $Trail/Points


func _unhandled_input(event: InputEvent) -> void:
	if target and event is InputEventScreenTouch and event.is_pressed() :
		jump()


func jump() -> void:
	
	if Settings.enable_sound:
		SoundManager.play_se("jump")

	target.implode() # 在一个节点中调用另一个节点的析构函数

	target = null
	
	# transform.x 是实时全局箭头运动方向的向量
	velocity = transform.x  * jump_speed



func _on_Jumper_area_entered(area: Area2D) -> void:
	
	if Settings.enable_sound:
		SoundManager.play_se("capture")
	
	target = area
	velocity = Vector2.ZERO
	
	# 使圆圈播放被捕获的动画,并使圆圈获得当前节点实例
	target.captured(self)

	# 当碰到新的圆圈会发送信号 捕获 将碰到节点信息传出去
	emit_signal("captured", area)

func _physics_process(delta: float) -> void:
	
	# 添加轨迹
	if trail.points.size() > trail_length:
		trail.remove_point(0)
	trail.add_point(position)
	
#	# 运动代码
	if target:
		transform = target.orbit_position.global_transform
	else:
		position += velocity * delta
	
#	position += transform.y * delta * 10
	
func die():
	target = null
	queue_free()


func _on_VisibilityNotifier2D_screen_exited() -> void:
	die()
	emit_signal("died")
