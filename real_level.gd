extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.coins = 0
	#$Knook/Camera2D.limit_bottom = 1650
	$Knook/Camera2D.limit_right = 15000
	$Knook/Camera2D.limit_top = -500   # example value
	$Bumper.visible = false
	$Knook/Camera2D.offset.y = -150


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_reset_camera_limit_factory_body_entered(body):
	$Knook/Camera2D.limit_bottom = 400

func _on_reset_camera_limit_cave_body_entered(body):
	$Knook/Camera2D.limit_bottom = 1650
	$Knook/Camera2D.limit_right = 15000
