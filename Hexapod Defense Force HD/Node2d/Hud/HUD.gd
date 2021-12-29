extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var healthbar_node = get_node("Display/Control/HealthBar")
onready var score_node = get_node("Display/Control/Score")
# Called when the node enters the scene tree for the first time.
func _ready():
	var globalNode = get_tree().get_current_scene().get_node("GlobalNode")
	if get_tree().get_current_scene().get_node("Player1"):
		globalNode.connect("FinalSendMaxHealth",self,"_set_max_health")
		globalNode.connect("FinalSendCurHealth",self,"_set_cur_health")
		globalNode.connect("Updated_points", self, "_set_point_label")
	
func _set_max_health(MaxHealth):
	healthbar_node.max_value = MaxHealth
	
func _set_cur_health(CurHealth):
	healthbar_node.value = CurHealth

func _set_point_label(points):
	score_node.text = "Score: " + str(points)
