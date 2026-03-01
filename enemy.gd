extends CharacterBody2D
class_name Enemy

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var speed = 75
var player = null
var hp = 100
var iframe = false
var iframe_time = 0.5
var weapon: Node2D

var can_melee = true
var melee_cooldown = 0.5
var attack_range = 40

var shoot_timer

@export var direction = -1 #1 is right, -1 is left
@export var follow_distance = 600
@export var bullet_scene: PackedScene
@export var shoot_cooldown = 1.2
@export var damage = 10
@export var can_shoot = true
@export var melee: PackedScene # melee attack


func _ready():
	add_to_group("enemy")
	player = get_tree().get_first_node_in_group("player")

	if can_shoot:
		# Timer for pew pew
		shoot_timer = Timer.new()
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
		
		if distance < follow_distance:
			
			direction = sign(player.global_position.x - global_position.x)
			$AnimatedSprite2D.flip_h = direction < 0

			if can_shoot and $ShootTimer.is_stopped():
				$ShootTimer.start()
		# elif is_on_wall():
		# 	direction = direction * -1
		# 	$AnimatedSprite2D.flip_h = not $AnimatedSprite2D.flip_h
			
		# 	if can_shoot and not $ShootTimer.is_stopped():
		# 		$ShootTimer.stop()
	
	#move left/right
	velocity.x = speed * direction
	
	#actually move the object
	move_and_slide()

# called periodically by the shoot timer
func _on_ShootTimer_timeout():
	if not player or not bullet_scene:
		return
	
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = global_position
	bullet.rotation = (player.global_position - global_position).angle()

func melee_attack():
	if not melee or not can_melee:
		return

	var distance = global_position.distance_to(player.global_position)
	if distance <= attack_range:
		can_melee = false
		
		var attack = melee.instantiate()
		attack.targetGroup = "player"
		get_tree().current_scene.add_child(attack)
		attack.global_position = global_position
		attack.rotation = (player.global_position - global_position).angle()
		await get_tree().create_timer(melee_cooldown).timeout
		can_melee = true

func _on_hurt_zone_body_entered(body):
	pass
	# if body.is_in_group("player"):
	# 	body.take_damage(damage)

func die():
	set_physics_process(false)
	if $HurtZone:
		$HurtZone.queue_free()
	if $TopZone:
		$TopZone.queue_free()
	position.y += 10
	$AnimatedSprite2D.play("squashed")
	await get_tree().create_timer(1.5).timeout
	queue_free()

func take_damage(amount):
	if iframe:
		return
	hp -= amount
	print(hp)
	if hp <= 0:
		die()
	iframe = true
	await get_tree().create_timer(iframe_time).timeout
	iframe = false
