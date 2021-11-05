extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Player_position = Vector2(100,0)
var BulletPath = "res://Node2d/Objects/Bullet.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_tree().get_current_scene().get_node("Player1"):
		var player = get_tree().get_current_scene().get_node("Player1")
		player.connect("pass_health",self,"_on_Player1_pass_health")
		player.connect()
	pass # Replace with function body.


func _on_Player1_pass_position(Self_position):
	Player_position = Self_position
	



func _on_Player1_pass_health(health):
	print(health)
	pass # Replace with function body.
