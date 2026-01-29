extends CharacterBody2D

class_name Player

@export var move_speed: float = 100
@export var push_strength: float = 100
@export var acceleration: float = 10

var is_attacking: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	update_treasure_label()
	update_hp_bar()
	if SceneManager.player_spawn_position != Vector2(0,0):
		position = SceneManager.player_spawn_position
	print()
	
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if SceneManager.player_hp <= 0:
		return
	if not is_attacking:
		move_player()
	push_blocks()
	
	update_treasure_label()
	
	if Input.is_action_just_pressed("interact"):
		attack()
		
	
	move_and_slide()
	

func move_player():
	var move_vector: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	velocity = velocity.move_toward(move_vector * move_speed, acceleration)
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
	update_hp_bar()
	if SceneManager.player_hp <= 0:
		die()
	
	var distance_to_player: Vector2 = global_position - body.global_position
	var knockback_direction: Vector2 = distance_to_player.normalized()
	
	var knockback_strength: float = 200
	velocity += knockback_direction * knockback_strength
	
func die():
	$AnimatedSprite2D.play("death")
	
	if $DeathTimer.is_stopped():
		$DeathTimer.start()
	
	
func _on_death_timer_timeout() -> void:
	SceneManager.player_hp = 3
	get_tree().call_deferred("reload_current_scene")
	
	
func update_hp_bar():
	if SceneManager.player_hp >= 3:
		%HPBar.play("3_hp")
	elif SceneManager.player_hp == 2:
		%HPBar.play("2_hp")
	elif SceneManager.player_hp == 1:
		%HPBar.play("1_hp")
	else:
		%HPBar.play("0_hp")

func attack():
	if not $AttackDurationTimer.is_stopped():
		return
	
	$Sword.visible = true
	%SwordArea2D.monitoring = true
	$AttackDurationTimer.start()
	is_attacking = true
	velocity = Vector2(0,0)
	
	var player_animation: String = $AnimatedSprite2D.animation
	if player_animation == "move_right":
		$AnimatedSprite2D.play("attack_right")
		$AnimationPlayer.play("attack_right")
	elif player_animation == "move_left":
		$AnimatedSprite2D.play("attack_left")
		$AnimationPlayer.play("attack_left")
	elif player_animation == "move_up":
		$AnimatedSprite2D.play("attack_up")
		$AnimationPlayer.play("attack_up")
	elif player_animation == "move_down":
		$AnimatedSprite2D.play("attack_down")
		$AnimationPlayer.play("attack_down")
		
	
func _on_sword_area_2d_body_entered(body):
	var distance_to_enemy:Vector2 = body.global_position - global_position
	var knockback_direction: Vector2 = distance_to_enemy.normalized()
	var knockback_strength:float = 150
	
	body.velocity += knockback_direction * knockback_strength
	body.HP -= 1
	if body.HP <= 0:
		body.queue_free()

func _on_attack_duration_timer_timeout() -> void:
	$Sword.visible = false
	%SwordArea2D.monitoring = false
	
	is_attacking = false
	
	var player_animation: String = $AnimatedSprite2D.animation
	if player_animation == "attack_right":
		$AnimatedSprite2D.play("move_right")
	elif player_animation == "attack_left":
		$AnimatedSprite2D.play("move_left")
	elif player_animation == "attack_up":
		$AnimatedSprite2D.play("move_up")
	elif player_animation == "attack_down":
		$AnimatedSprite2D.play("move_down") 
