extends Area2D
# or extends Area2D / CharacterBody2D

var speed := 900
var direction: Vector2
var damage = 10
var start_position: Vector2
var range = 5000

func _ready():
	body_entered.connect(_on_hurt_zone_body_entered)
	start_position = global_position

func _physics_process(delta):
	direction = Vector2.RIGHT.rotated(rotation)
	global_position += direction * speed * delta
	# if not get_viewport_rect().has_point(global_position):
	# 	queue_free() # ?

	if global_position.distance_to(start_position) >= range:
		queue_free()

func _on_hurt_zone_body_entered(body):
	if body.is_in_group("player") and body.has_method("take_damage"):
		body.take_damage(damage)
