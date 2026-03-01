extends Area2D

@export var damage: int = 20
@export var lifetime: float = 0.15
var targetGroup = "" # set this bro


var hit_targets = []

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _on_body_entered(body):
	if body in hit_targets:
		return

	if body.has_method("take_damage") and body.is_in_group(targetGroup):
		body.take_damage(damage)
		hit_targets.append(body)

func set_facing(direction: Vector2):
	if direction.x > 0:
		$Sprites.flip_h = false
	else:
		$Sprites.flip_h = true
