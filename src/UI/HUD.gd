extends CanvasLayer

func show_massage(text):
	$Massage.text = text
	$AnimationPlayer.play("show_massage")

func hide():
	$ScoreBox.hide()
	
func show():
	$ScoreBox.show()
	
func update_score(value):
	$ScoreBox/HBoxContainer/Score.text = str(value)
	
