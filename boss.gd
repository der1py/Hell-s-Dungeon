extends "res://enemy.gd"

func _ready():
	super._ready()
	hp = 400
	

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

