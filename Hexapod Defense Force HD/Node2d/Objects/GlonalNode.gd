
extends Node2D

signal FinalSendMaxHealth(Maxhealth)
signal FinalSendCurHealth(CurrentHealth)
signal FinalSendStateMachine(time,power)
signal FinalSendPlayerPosition(position)
signal Updated_points(points)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Player_position = Vector2(100,0)
var BulletPath = "res://Node2d/Objects/Bullet.tscn"
var pointTotal = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	updatePoints(0)
	if get_tree().get_current_scene().get_node("Player1"):
		var player = get_tree().get_current_scene().get_node("Player1")
		player.connect("pass_position",self,"_on_Player1_pass_position")
		player.connect("pass_cur_health",self,"_on_Player1_pass_health")
		player.connect("pass_max_health",self,"_on_Player1_pass_max_health")
			
func _on_Player1_pass_position(player1_position):
	emit_signal("FinalSendPlayerPosition",player1_position)

func _on_Player1_pass_max_health(maxHealth):
	emit_signal("FinalSendMaxHealth",maxHealth)
	
func _on_Player1_pass_health(Curhealth):
	emit_signal("FinalSendCurHealth",Curhealth)

func _on_Dropper_Spawner_SendStateList(State, Time):
	emit_signal("FinalSendStateMachine",State,Time)

func updatePoints(points):
	pointTotal += points
	emit_signal("Updated_points",pointTotal)
