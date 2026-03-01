extends Node2D
# 或 extends Area2D / CharacterBody2D

var speed := 900
var direction: Vector2

func _physics_process(delta):
	direction = Vector2.RIGHT.rotated(rotation)
	position += direction * speed * delta
