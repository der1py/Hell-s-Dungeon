extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	$Counter.text = str(Global.coins)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	setCounter()
	
func setCounter():
	$Counter.text = str(Global.coins)
