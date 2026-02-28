extends CharacterBody2D

var speed = 450
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 4
var jumpForce = 1100 
var timer = 10 # wtf does ts do delet later??
var can_dash = true
var dash_power = 1700
var dash_cooldown = 0 # seconds
var hp = 100

# weapons
# 1 = pistol, 2 = shotgun
var weaponDamage = [10, 15]

func _ready():
	print("Hello World")

func _physics_process(delta):
	
	# die
	if hp <= 0:
		die()

	#Fall With Gravity
	velocity.y += gravity * delta
	
	#Jump
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = -jumpForce
	
	#Left/Right Movement
	var ACCLERATION_CONSTANT = 6
	velocity.x = max(0, velocity.x - speed * delta * ACCLERATION_CONSTANT) if velocity.x > 0 else min(0, velocity.x + speed * delta * ACCLERATION_CONSTANT)
	if not Input.is_action_pressed("ui_down"):
		if Input.is_action_pressed("ui_right") and velocity.x < speed:
			velocity.x = speed
		elif Input.is_action_pressed("ui_left") and velocity.x > -speed:
			velocity.x = -speed
	
	if Input.is_action_just_pressed("dash"):
		if not can_dash:
			return
		can_dash = false
		velocity.x = dash_power * (1 if $Sprites.flip_h == false else -1)
		await get_tree().create_timer(dash_cooldown).timeout
		can_dash = true
	
	#Play Character Animations and Poses
	if Input.is_action_pressed("ui_down"):
		$Sprites.play("shoot")
	elif not is_on_floor():
		$Sprites.play("air")
	elif Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left"):
		$Sprites.play("walk")
	else:
		$Sprites.play("idle")
	
	#Flip Character Sprites Left/Right
	if Input.is_action_pressed("ui_right"):
		$Sprites.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		$Sprites.flip_h = true
	
	#Move Character
	move_and_slide()

func _on_fall_zone_body_entered(body):
	die()

func _on_teleport_area_body_entered(body):
	position.x = 4600
	position.y = -2500
	$Camera2D.limit_right = 5500

func die():
	set_physics_process(false)
	$Sprites.play("die")
	await get_tree().create_timer(1).timeout
	position.y += 20
	if $Sprites.flip_h == false:
		position.x += 20
		set_rotation_degrees(90)
	else:
		set_rotation_degrees(-90)
		position.x -= 20
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://game_over.tscn")
