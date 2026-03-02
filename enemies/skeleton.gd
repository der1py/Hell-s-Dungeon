extends Enemy

@export var skeleton_speed = 300
@export var skeleton_hp = 50
@export var skeleton_damage = 15

func _ready():
	super._ready()   # VERY IMPORTANT
	
	speed = skeleton_speed
	hp = skeleton_hp
	damage = skeleton_damage
	
	can_shoot = false
	can_melee = true
