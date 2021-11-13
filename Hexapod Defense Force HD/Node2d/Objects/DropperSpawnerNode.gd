extends Node2D

signal SendStateList(State,Time)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var droppers:PackedScene = preload("res://Node2d/Enemies/Drooper.tscn")
var incrementor = 0
var WavesDict = {
	"DropperTransform": Vector2(),
	"Amount": -1,
	"dropperStateList": ['x'][-1],
	"dropperTimeList": [-1,-1],
	"Timer": -1,
	"Wavename": ""
}

var ListofWaves = []
  
# Called when the node enters the scene tree for the first time.
func _ready():
	WavesDict = {
		"DropperTransform": Vector2(800,100),
		"Amount": 1,
		"dropperStateList": [5,1,5,2,5],
		"dropperTimeList": [1,1,1,1,1],
		"Timer": 10,
		"maxTimer": 10,
		"Wavename": "Wave 1"
		}
		
	ListofWaves.append(WavesDict)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	countdown(delta)
	
	
func countdown(delta):
	ListofWaves[incrementor]["Timer"] = ListofWaves[incrementor]["Timer"] - delta

	if ListofWaves[incrementor]["Timer"] < 0:
		spawn_Dropper()
		ListofWaves[incrementor]["Timer"] = ListofWaves[incrementor]["maxTimer"]
		

func spawn_Dropper():
	var DropperChild = droppers.instance()
	emit_signal("SendStateList",ListofWaves[incrementor]["dropperStateList"], ListofWaves[incrementor]["dropperTimeList"])
	get_tree().current_scene.add_child(DropperChild)
	emit_signal("SendStateList",ListofWaves[incrementor]["dropperStateList"], ListofWaves[incrementor]["dropperTimeList"])
	DropperChild.transform.origin = to_global(Vector2(ListofWaves[incrementor]["DropperTransform"].x, ListofWaves[incrementor]["DropperTransform"].y ))
	ListofWaves[incrementor]["Amount"] = ListofWaves[incrementor]["Amount"] -1
	emit_signal("SendStateList",ListofWaves[incrementor]["dropperStateList"], ListofWaves[incrementor]["dropperTimeList"])
	
	if ListofWaves.size() + 1 == incrementor:
		incrementor+=1
