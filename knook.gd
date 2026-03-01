extends CharacterBody2D

var speed = 450
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 4
var jumpForce = 1100 
var timer = 10 # wtf does ts do delet later??
var can_dash = true
var dash_power = 1500
var dash_cooldown = 0 # seconds
var hp = 100
var maxJumps = 2
var jumps = maxJumps
var can_melee = true
var melee_cooldown = 0.3
var rmb_cooldown = 0.1
var can_rmb = true
enum STATES { IDLE, DASHING, AIR, WALK, ATTACK1, ATTACK2, DEAD }
var state = STATES.IDLE

# how long each state lasts for
var default_time = 0.2 # default action time
var dash_time = 0.2

@export var melee: PackedScene
@export var attack_distance: float = 40

@export var boomerang: PackedScene

# weapons
# 1 = pistol, 2 = shotgun
var weaponDamage = [10, 15]

func _ready():
	add_to_group("player")
	print("Hello World")


func _physics_process(delta):
	# die
	if hp <= 0:
		die()

	# freeze all this shi when u dash lol
	if state != STATES.DASHING:
		handle_y_movement(delta)

		handle_attack_input()
		
		handle_x_movement(delta)
	
	if Input.is_action_just_pressed("dash"):
		if not can_dash:
			pass
		else:
			can_dash = false
			velocity.x = dash_power * (1 if $Sprites.flip_h == false else -1)
			state = STATES.DASHING
			await get_tree().create_timer(dash_time).timeout
			velocity.x = 0
			state = STATES.IDLE
			await get_tree().create_timer(max(dash_cooldown - dash_time, 0)).timeout
			can_dash = true
	
	#Play Character Animations and Poses
	animate()
	
	#Flip Character Sprites Left/Right
	if Input.is_action_pressed("ui_right"):
		$Sprites.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		$Sprites.flip_h = true
	
	#Move Character
	move_and_slide()

func handle_y_movement(delta):
	velocity.y += gravity * delta
	
	if is_on_floor():
		jumps = maxJumps

	if Input.is_action_just_pressed("ui_up") and jumps > 0 and state != STATES.ATTACK1 and state != STATES.ATTACK2:
		velocity.y = -jumpForce
		jumps -= 1

func handle_x_movement(delta):
	var ACCELERATION_CONSTANT = 6
	velocity.x = max(0, velocity.x - speed * delta * ACCELERATION_CONSTANT) if velocity.x > 0 else min(0, velocity.x + speed * delta * ACCELERATION_CONSTANT)
	
	# move if not currently attacking
	if (state != STATES.ATTACK1 and state != STATES.ATTACK2):
		if Input.is_action_pressed("ui_right") and velocity.x < speed:
			velocity.x = speed
			state = STATES.WALK
		elif Input.is_action_pressed("ui_left") and velocity.x > -speed:
			velocity.x = -speed
			state = STATES.WALK
		else:
			if is_on_floor():
				state = STATES.IDLE
			else:
				state = STATES.AIR

func handle_attack_input():
	# can only attack in these states
	if not (state == STATES.IDLE or state == STATES.WALK or state == STATES.AIR):
		return

	# melee attack
	if Input.is_action_pressed("lmb"):
		if not can_melee:
			pass
		else:
			var mouse_pos = get_global_mouse_position()
			if mouse_pos.x > global_position.x:
				$Sprites.flip_h = false   # facing right
			else:
				$Sprites.flip_h = true    # facing left
			can_melee = false
			velocity.x += 400 * (1 if $Sprites.flip_h == false else -1)
			melee_attack()

			state = STATES.ATTACK1
			await get_tree().create_timer(default_time).timeout
			state = STATES.IDLE

			await get_tree().create_timer(max(melee_cooldown - default_time, 0)).timeout
			can_melee = true
	
	# boomerang attack
	if Input.is_action_pressed("rmb"):
		if not can_rmb:
			pass
		else:
			can_rmb = false
			can_melee = false
			boomerang_attack()

			state = STATES.ATTACK2
			await get_tree().create_timer(default_time).timeout
			state = STATES.IDLE

			await get_tree().create_timer(max(rmb_cooldown - default_time, 0)).timeout
			can_rmb = true

func animate():
	if state == STATES.DEAD:
		$Sprites.play("die")
		return

	if state == STATES.ATTACK1:
		$Sprites.play("melee")
	elif state == STATES.ATTACK2:
		$Sprites.play("shoot")
	elif state == STATES.DASHING:
		$Sprites.play("dash")
	elif not is_on_floor():
		if Input.is_action_pressed("ui_up"):
			$Sprites.play("jump")
			$Sprites.set_frame_and_progress(0, 0) # restart animation
		elif $Sprites.animation == "air":
			$Sprites.play("air")
		else:
			$Sprites.play("jump")
			$Sprites.animation_finished.connect(_on_animation_finished.bind($Sprites.animation))
	elif state == STATES.WALK:
		$Sprites.play("walk")
	else:
		$Sprites.play("idle")

func _on_animation_finished(name):
	if name == "jump":
		$Sprites.play("air")

func _on_fall_zone_body_entered(body):
	die()

func _on_teleport_area_body_entered(body):
	position.x = 4600
	position.y = -2500
	$Camera2D.limit_right = 5500

func melee_attack():
	var attack = melee.instantiate()
	var direction = (get_global_mouse_position() - global_position).normalized()
	attack.global_position = global_position + direction * attack_distance
	attack.rotation = direction.angle()
	attack.set_facing(global_position.direction_to(get_global_mouse_position()))
	get_tree().current_scene.add_child(attack)

func boomerang_attack():
	var sword = boomerang.instantiate()
	sword.global_position = global_position

	var dir = global_position.direction_to(get_global_mouse_position())
	sword.setup(dir, self)

	get_tree().current_scene.add_child(sword)

func die():
	state = STATES.DEAD
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
	
