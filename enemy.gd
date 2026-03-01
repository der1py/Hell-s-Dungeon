extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var speed = 75
var player = null
var can_shoot = true
var hp = 100

@export var direction = -1 #1 is right, -1 is left
@export var follow_distance = 600
@export var bullet_scene: PackedScene
@export var shoot_cooldown = 1.2

func _ready():
	player = get_tree().get_first_node_in_group("player")

	# Timer 控制射击
	var shoot_timer = Timer.new()
	shoot_timer.name = "ShootTimer"
	shoot_timer.wait_time = shoot_cooldown
	shoot_timer.one_shot = false
	shoot_timer.autostart = false
	add_child(shoot_timer)
	shoot_timer.timeout.connect(_on_ShootTimer_timeout)
	$AnimatedSprite2D.flip_h = false if direction == -1 else true
	
func _physics_process(delta):
	
	#fall with gravity
	velocity.y += gravity * delta
	
	# Follow player if close enough
	if player:
		var distance = global_position.distance_to(player.global_position)
		var to_player = player.global_position - global_position
		
		if distance < follow_distance:
			if can_shoot:
				pass
				# shoot()
			
			direction = sign(player.global_position.x - global_position.x)
			$AnimatedSprite2D.flip_h = direction < 0

			if $ShootTimer.is_stopped():
				$ShootTimer.start()
		elif is_on_wall():
			direction = direction * -1
			$AnimatedSprite2D.flip_h = not $AnimatedSprite2D.flip_h
			
			if not $ShootTimer.is_stopped():
				$ShootTimer.stop()
	
	#move left/right
	velocity.x = speed * direction
	
	#actually move the object
	move_and_slide()

func _on_ShootTimer_timeout():
	if not player or not bullet_scene:
		return
	
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = global_position
	bullet.rotation = (player.global_position - global_position).angle()
	
func _on_hurt_zone_body_entered(body):
	if body.is_in_group("player"):
		body.hp -= 10

func shoot():
	if not can_shoot or not player:
		return

	can_shoot = false

	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = global_position
	bullet.rotation = (player.global_position).angle()
	# bullet.direction = Vector2.RIGHT.rotated(weapon.rotation)

	await get_tree().create_timer(shoot_cooldown).timeout
	can_shoot = true

func _on_top_zone_body_entered(body):
	set_physics_process(false)
	$HurtZone.queue_free()
	$TopZone.queue_free()
	position.y += 10
	$AnimatedSprite2D.play("squashed")
	body.velocity.y = -500
	await get_tree().create_timer(1.5).timeout
	queue_free()


	
