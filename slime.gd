extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var speed = 75
@export var direction = -1 #1 is right, -1 is left

func _ready():
	$AnimatedSprite2D.flip_h = false if direction == -1 else true
	
func _physics_process(delta):
	
	#fall with gravity
	velocity.y += gravity * delta
	
	#turn around on walls
	if is_on_wall():
		direction = direction * -1
		$AnimatedSprite2D.flip_h = not $AnimatedSprite2D.flip_h
	
	
	#move left/right
	velocity.x = speed * direction
	
	#actually move the object
	move_and_slide()
	



func _on_hurt_zone_body_entered(body):
	body.die()


func _on_top_zone_body_entered(body):
	set_physics_process(false)
	$HurtZone.queue_free()
	$TopZone.queue_free()
	position.y += 10
	$AnimatedSprite2D.play("squashed")
	body.velocity.y = -500
	await get_tree().create_timer(1.5).timeout
	queue_free()
	
