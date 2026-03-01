extends Area2D

@export var speed: float = 600
@export var curve_strength: float = 300
@export var max_distance: float = 600
@export var damage: int = 25

var direction: Vector2
var start_position: Vector2
var returning := false
var player: Node2D
var targetGroup = "" # set this bro

func _ready():
	start_position = global_position
	connect("body_entered", Callable(self, "_on_body_entered"))

func setup(p_direction: Vector2, p_player: Node2D):
	direction = p_direction.normalized()
	player = p_player

func _physics_process(delta):
	if not returning:
		# Forward movement
		var curve = Vector2(-direction.y, direction.x) * curve_strength
		global_position += (direction * speed + curve) * delta
		
		# Check distance
		if global_position.distance_to(start_position) > max_distance:
			returning = true
	else:
		# Return to player
		speed += 100 * delta
		var return_dir = (player.global_position - global_position).normalized()
		global_position += return_dir * speed * delta
		
		# If close enough, delete
		if global_position.distance_to(player.global_position) < 20:
			player.can_melee = true
			queue_free()

	rotation += 15 * delta  # spin effect

func _on_body_entered(body):
	if body.has_method("take_damage") and body.is_in_group(targetGroup):
		body.take_damage(damage)
