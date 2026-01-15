extends StaticBody2D

var can_interact: bool = false 

func _process(delta):
	if Input.is_action_just_pressed("interact") and can_interact :
		if $CanvasLayer.visible:
			$CanvasLayer.visible = false
		else:
			$CanvasLayer.visible = true
