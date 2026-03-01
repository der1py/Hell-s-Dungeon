extends "res://enemy.gd"

var dash_timer
var can_dash = true
var rng

@export var dash_cooldown = 8

func _ready():
	super._ready()

	rng = RandomNumberGenerator.new()
	
	speed = 150
	hp = 400

	dash_timer = Timer.new()
	dash_timer.name = "DashTimer"
	dash_timer.wait_time = dash_cooldown
	dash_timer.one_shot = false
	dash_timer.autostart = false
	add_child(dash_timer)
	dash_timer.timeout.connect(_on_DashTimer_timeout)	

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
			
			if can_dash and rng.randf_range(0, 50) < 2:
				_dash()
				can_dash = false
				$DashTimer.start()
			
		# elif is_on_wall():
		# 	direction = direction * -1
		# 	$AnimatedSprite2D.flip_h = not $AnimatedSprite2D.flip_h
			
		# 	if can_shoot and not $ShootTimer.is_stopped():
		# 		$ShootTimer.stop()

	
	
	#move left/right
	velocity.x = speed * direction
	
	#actually move the object
	move_and_slide()

func _on_DashTimer_timeout():
	can_dash = true

func _dash():
	print("DASH")