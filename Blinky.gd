extends CharacterBody2D

var speed = 200

func _physics_process(delta):
	if Input.is_action_pressed("ui_up"):
		velocity.y = -speed
	elif Input.is_action_pressed("ui_down"):
		velocity.y = speed
	elif not Input.is_action_pressed("ui_up") and not Input.is_action_pressed("ui_down"):
		velocity.y = 0
			
	move_and_slide()
