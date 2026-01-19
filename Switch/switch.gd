extends StaticBody2D

signal switch_activated
signal switch_deactivated

var can_interact: bool = false
var is_activated: bool = false

func _process(delta):
	if Input.is_action_just_pressed("interact") and can_interact:
		if is_activated:
			$AnimatedSprite2D.play("deactivated")
			switch_deactivated.emit()
			is_activated = false
		else:
			$AnimatedSprite2D.play("activated")
			switch_activated.emit()
			is_activated = true


func _on_switch_activated():
	print("the switch was activated using a signal")


func _on_switch_deactivated():
	print ("the switch was deactivated using a signal")
