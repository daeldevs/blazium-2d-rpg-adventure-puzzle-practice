extends CharacterBody2D

class_name Player

@export var move_speed: float = 100
@export var push_strength: float = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	update_treasure_label()
	if SceneManager.player_spawn_position != Vector2(0,0):
		position = SceneManager.player_spawn_position
	
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	move_player()
	push_blocks()
	
	update_treasure_label()
	
	move_and_slide()
	

func move_player():
	var move_vector: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	velocity = move_vector * move_speed 
	if velocity.x > 0:
		#print("the player is moving right")
		$AnimatedSprite2D.play("move_right")
		$InteractArea2D.position = Vector2(5,-2)
		
		
	elif velocity.x < 0:
		#print ("the player is moving left")
		$AnimatedSprite2D.play("move_left")
		$InteractArea2D.position = Vector2(-5,2)
	elif velocity.y > 0:
		#print ("the player is moving down")
		$AnimatedSprite2D.play("move_down")
		$InteractArea2D.position = Vector2(0,8)
		
	elif velocity.y < 0:
		#print ("the player is moving up")
		$AnimatedSprite2D.play("move_up")
		$InteractArea2D.position = Vector2(0,-4)
	
	else:
		#print("the player isn't moving.")
		$AnimatedSprite2D.stop()
		

func push_blocks():
	var collision: KinematicCollision2D = get_last_slide_collision()
	if collision:
		var collider_node = collision.get_collider()
		if collider_node.is_in_group("pushable"):
			var collision_normal: Vector2 = collision.get_normal()
			collider_node.apply_central_force(-collision_normal * push_strength)
		if collider_node.is_in_group("wall"):
			#print ("I'm touching a wall!")
			pass
	

func update_treasure_label():
	var treasure_amount: int = SceneManager.opened_chests.size()
	%TreasureLabel.text = str(treasure_amount)

func _on_area_2d_body_entered(body):
	if body.is_in_group("interactable"):
		body.can_interact = true


func _on_area_2d_body_exited(body):
	if body.is_in_group("interactable"):
		body.can_interact = false


func _on_hitbox_area_2d_body_entered(body: Node2D) -> void:
	SceneManager.player_hp -= 1
	print(SceneManager.player_hp)
	if SceneManager.player_hp <= 0:
		die()
	
	
func die():
	SceneManager.player_hp = 3
	get_tree().call_deferred("reload_current_scene")
