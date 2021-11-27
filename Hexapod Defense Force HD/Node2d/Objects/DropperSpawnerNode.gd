extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var droppers:PackedScene = preload("res://Node2d/Enemies/Drooper.tscn")
var incrementor = 0
var i = 0
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
		"Amount": 3,
		"dropperStateList": [5,1,2,3,4],
		"dropperTimeList": [1,2,2,2,2],
		"Timer": 5,
		"maxTimer": 5,
		"Wavename": "Wave 1"
		}
		
	ListofWaves.append(WavesDict)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if i < len(ListofWaves):
		countdown(delta)
	
	
func countdown(delta):
	"""Countdown timer of each creature to spawn"""
	ListofWaves[incrementor]["Timer"] = ListofWaves[incrementor]["Timer"] - delta

	if ListofWaves[incrementor]["Timer"] < 0:
	
		spawn_Dropper()
		ListofWaves[incrementor]["Timer"] = ListofWaves[incrementor]["maxTimer"]
	

func spawn_Dropper():
	if ListofWaves[incrementor]["Amount"] > 0:
		var DropperChild = droppers.instance()
		DropperChild.transform.origin = to_global(Vector2(ListofWaves[incrementor]["DropperTransform"].x, ListofWaves[incrementor]["DropperTransform"].y ))
		var sendlist = [ListofWaves[incrementor]["dropperStateList"],ListofWaves[incrementor]["dropperTimeList"]]
		DropperChild.stateList = sendlist
		get_tree().current_scene.add_child(DropperChild)

		ListofWaves[incrementor]["Amount"] -= 1
		
	if ListofWaves.size() + 1 == incrementor:
		incrementor+=1
