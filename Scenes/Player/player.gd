extends CharacterBody2D

class_name Player

@export var move_speed: float = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(move_speed)
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var move_vector: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	velocity = move_vector * move_speed 
	if velocity.x > 0:
		#print("the player is moving right")
		$AnimatedSprite2D.play("move_right")
		
	elif velocity.x < 0:
		#print ("the player is moving left")
		$AnimatedSprite2D.play("move_left")
	elif velocity.y > 0:
		#print ("the player is moving down")
		$AnimatedSprite2D.play("move_down")
	elif velocity.y < 0:
		#print ("the player is moving up")
		$AnimatedSprite2D.play("move_up")
	
	else:
		#print("the player isn't moving.")
		$AnimatedSprite2D.stop()
	move_and_slide()
