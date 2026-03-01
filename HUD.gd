extends CanvasLayer
var knook
# Called when the node enters the scene tree for the first time.
func _ready():
	knook = get_node("../Knook")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$ProgressBar.value = knook.hp
