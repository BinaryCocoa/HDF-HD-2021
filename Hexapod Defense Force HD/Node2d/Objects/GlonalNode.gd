extends Node2D

signal FinalSendMaxHealth(Maxhealth)
signal FinalSendCurHealth(CurrentHealth)
signal FinalSendStateMachine(time,power)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Player_position = Vector2(100,0)
var BulletPath = "res://Node2d/Objects/Bullet.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_tree().get_current_scene().get_node("Player1"):
		var player = get_tree().get_current_scene().get_node("Player1")
		player.connect("pass_cur_health",self,"_on_Player1_pass_health")
		player.connect("pass_max_health",self,"_on_Player1_pass_max_health")
	if get_tree().get_current_scene().get_node("Dropper Spawner"):
		var DropperSpawner = get_tree().get_current_scene().get_node("Dropper Spawner")
		DropperSpawner.connect("SendStateList",self,"_on_Dropper_Spawner_SendStateList")

func _on_Player1_pass_position(Self_position):
	Player_position = Self_position

func _on_Player1_pass_max_health(maxHealth):
	emit_signal("FinalSendMaxHealth",maxHealth)
	pass
	
func _on_Player1_pass_health(Curhealth):
	emit_signal("FinalSendCurHealth",Curhealth)
	pass # Replace with function body.


func _on_Dropper_Spawner_SendStateList(State, Time):
	emit_signal("FinalSendStateMachine",State,Time)

func isAlive():
	print("drooper spawned")
