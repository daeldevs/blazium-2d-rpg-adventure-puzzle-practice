extends StaticBody2D

func _process(delta):
	if Input.is_action_just_pressed("interact"):
		if $CanvasLayer.visible:
			$CanvasLayer.visible = false
		else:
			$CanvasLayer.visible = true
