extends "res://enemy.gd"

var dash_timer
var can_dash = false
var dash_power = 600
var dash_time = 0.8
var is_dashing = false

var default_speed = 150

var rng

@export var dash_cooldown = 8

func _ready():
	super._ready()
	$HurtZone.connect("body_entered", _deal_damage)

	rng = RandomNumberGenerator.new()
	
	speed = default_speed
	hp = 400

	can_shoot = true

	dash_timer = Timer.new()
	dash_timer.name = "DashTimer"
	dash_timer.wait_time = dash_cooldown
	dash_timer.one_shot = false
	dash_timer.autostart = false
	add_child(dash_timer)
	dash_timer.timeout.connect(_on_DashTimer_timeout)	
	$DashTimer.start()

	

func _physics_process(delta):
	
	#fall with gravity
	velocity.y += gravity * delta
	
	# Follow player if close enough
	if player:
		var distance = global_position.distance_to(player.global_position)
		
		if distance < follow_distance:
			
			if not is_dashing:
				direction = sign(player.global_position.x - global_position.x)
				$AnimatedSprite2D.flip_h = direction < 0

			if can_shoot and $ShootTimer.is_stopped():
				$ShootTimer.start()
			
			if can_dash:
				is_dashing = true
				can_dash = false
				speed = dash_power
				await get_tree().create_timer(dash_time).timeout

				speed = default_speed
				is_dashing = false
				$DashTimer.start()
			
		if has_melee:
			# try to melee attack if in range 
			melee_attack()
	
	#move left/right
	velocity.x = speed * direction
	
	#actually move the object
	move_and_slide()

func _on_DashTimer_timeout():
	can_dash = true

func _deal_damage(body):	
	if body.is_in_group("player"):
		body.take_damage(damage)

func die():
	get_tree().change_scene_to_file("res://win_screen.tscn")
