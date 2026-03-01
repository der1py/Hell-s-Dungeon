extends Area2D

@export var damage: int = 20
@export var lifetime: float = 0.15

var hit_targets = []

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	var parent = get_parent()
	var mouse_pos = get_global_mouse_position()
	if mouse_pos.x > parent.global_position.x:
		$Sprites.flip_h = false
	else:
		$Sprites.flip_h = true

	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _on_body_entered(body):
	if body in hit_targets:
		return

	if body.has_method("take_damage"):
		body.take_damage(damage)
		hit_targets.append(body)
