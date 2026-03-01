extends Node2D

var speed := 900
var direction: Vector2 = Vector2.RIGHT

func _physics_process(delta):
	position += direction * speed * delta
