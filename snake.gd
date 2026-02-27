extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var speed = 100
@export var direction = -1 #1 is right, -1 is left

func _ready():
	pass
	
func _physics_process(delta):
	
	#fall with gravity
	velocity.y += gravity * delta
	
	#turn around on walls
	if is_on_wall():
		direction = direction * -1
	
	#move left/right
	velocity.x = speed * direction
	
	#actually move the object
	move_and_slide()

func _on_hurt_zone_body_entered(body):
	body.die()
