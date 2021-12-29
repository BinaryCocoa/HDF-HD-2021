extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Spawner_Bug:PackedScene = preload("res://Node2d/Enemies/Spawner_Bug.tscn")
var incrementor = 0
var i = 0
var WavesDict = {
	"DropperTransform": Vector2(),
	"Amount": -1,
	"Spawner_Bug_stateList": ['x'][-1],
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
		"Spawner_Bug_stateList": [5,1,2,3,4],
		"dropperTimeList": [1,2,2,2,2],
		"Timer": 5,
		"maxTimer": 5,
		"Wavename": "Wave 1"
		}
		
	ListofWaves.append(WavesDict)
	WavesDict = {
		"DropperTransform": Vector2(1000,100),
		"Amount": 5,
		"Spawner_Bug_stateList": [2,5,1,4,4],
		"dropperTimeList": [0,1,1,.5,3],
		"Timer": 2,
		"maxTimer": 6,
		"Wavename": "Wave 2"
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
		var DropperChild = Spawner_Bug.instance()
		DropperChild.transform.origin = to_global(Vector2(ListofWaves[incrementor]["DropperTransform"].x, ListofWaves[incrementor]["DropperTransform"].y ))
		var sendlist = [ListofWaves[incrementor]["Spawner_Bug_stateList"],ListofWaves[incrementor]["dropperTimeList"]]
		DropperChild.stateList = sendlist
		get_tree().current_scene.add_child(DropperChild)

		ListofWaves[incrementor]["Amount"] -= 1
		
	if ListofWaves.size() + 1 == incrementor:
		incrementor+=1
