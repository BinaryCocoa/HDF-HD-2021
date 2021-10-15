extends Node2D


var buggers:PackedScene = preload("res://Node2d/Enemies/Bugger.tscn")
export var Timervariation = 0
var bugchild
export var bugTimerStart = 3
var bugTimer


# Called when the node enters the scene tree for the first time.
func _ready():
	bugTimer = bugTimerStart + randi() % 4

func dropBug():
	bugchild = buggers.instance()
	get_tree().current_scene.add_child(bugchild)
	bugchild.transform.origin = to_global(Vector2($BugSpawner.position.x, $BugSpawner.position.y))
	bugTimer = bugTimerStart + randi() % 4
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	bugTimer = bugTimer - delta
	if bugTimer < 0:
		dropBug()

