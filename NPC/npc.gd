extends StaticBody2D

var dialogue_lines: Array[String] = ["hi!", "How are you?", "Bye!"]

var can_interact: bool = false 

func _ready():
	print(dialogue_lines[0])
	print(dialogue_lines[2])

func _process(delta):
	if Input.is_action_just_pressed("interact") and can_interact :
		if $CanvasLayer.visible:
			$CanvasLayer.visible = false
			get_tree().paused = false
		else:
			$CanvasLayer.visible = true
			get_tree().paused = true
