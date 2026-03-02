extends Enemy

@export var sniper_speed = 30
@export var sniper_hp = 50
@export var sniper_damage = 20
@export var sniper_shoot_cooldown = 3

func _ready():
	super._ready()   # VERY IMPORTANT
	
	speed = sniper_speed
	hp = sniper_hp
	damage = sniper_damage
	shoot_cooldown = sniper_shoot_cooldown
	
	can_shoot = true
	can_melee = false
