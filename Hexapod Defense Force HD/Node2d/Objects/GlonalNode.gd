extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Player_position

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Player1_body_pass_position(Self_position):
	Player_position = Self_position
	#print(Player_position)
