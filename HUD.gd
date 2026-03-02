extends CanvasLayer
var knook
# Called when the node enters the scene tree for the first time.
func _ready():
	knook = get_node("../Knook")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$ProgressBar.value = knook.hp
	$dashbar.value = (knook.dash_cooldown_timer)
	$skillbar.value = (knook.rmb_cooldown_timer)
	$atkbar.value = (knook.melee_cooldown_timer)
