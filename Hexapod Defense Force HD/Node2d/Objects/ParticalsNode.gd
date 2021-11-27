extends Particles2D

export var max_partical_count := 30
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	
	if get_tree().get_current_scene().get_node("Player1"):
		var player = get_tree().get_current_scene().get_node("Player1")
		player.connect("emit_velocity_x",self,"control_partical")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func control_partical(player_velocity):
	if player_velocity < 0 or player_velocity > 0:
		set_emitting(1)
	else:
		set_emitting(0)
