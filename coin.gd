extends Area2D

func _ready():
	pass

func _on_body_entered(body):
	Global.coins += 2
	print(Global.coins)
	
	if Global.coins >= 30:
		get_tree().change_scene_to_file("res://win_screen.tscn")
	
	queue_free()
