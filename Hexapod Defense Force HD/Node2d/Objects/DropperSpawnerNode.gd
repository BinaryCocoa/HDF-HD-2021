#///////////////////////////////////////// CREATE LOCAL VARIABLES & SIGNALS /////////////////////////////////////////#
extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Spawner_Bug:PackedScene = preload("res://Node2d/Enemies/Spawner_Bug.tscn")
var Waveincrementor = 0
var IndividualIncrementor = 0
var waveCounter= 0

var WavesDict = {
	"WaveName": "",
	"DropperTransform": Vector2(),
	"Amount": -1,
	"StateList": ['x'][-1],
	"TimerList": [-1,-1],
	"Timer": -1,
}
var ListofWaves = []
#//////////////////////////////////////////////// CREATION FINISHED ////////////////////////////////////////////////#

#/////////////////////////////////////////////////// SETUP START ///////////////////////////////////////////////////#
# Called when the node enters the scene tree for the first time.
func _ready():
	WavesDict = {
		"WaveName": "Wave 1",
		"DropperTransform": Vector2(0,-3000),
		"Amount": 3,
		"StateList": ["MoveRight","MoveLeft","MoveDown"],
		"TimerList": [5,5,2],
		"Timer": 5,
		"maxTimer": 5,

		}
		
	ListofWaves.append(WavesDict)
	WavesDict = {
		"WaveName": "Wave 2",
		"DropperTransform": Vector2(200,-3000),
		"Amount": 5,
		"StateList": ["MoveDown","MoveRight"],
		"TimerList": [10,3],
		"Timer": 2,
		"maxTimer": 6,
		}
	ListofWaves.append(WavesDict)
#///////////////////////////////////////////////// SETUP FINISHED /////////////////////////////////////////////////#

#///////////////////////////////////////////// UPDATE FUNCTIONS START /////////////////////////////////////////////#
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	"""This is a caller for all of the Bug_Spawner units this will be the the most intense
	call of the script so far if. If the Waves amount """
	
	if waveCounter < len(ListofWaves):
		countdown(ListofWaves[waveCounter],delta)
	
func countdown(wave,delta):
	"""When called this reduces the timer for each individual spawn of a wave, 
	in addition if the timer is 0 spawn A bug Dropper"""
	wave.Timer -= delta
	if wave.Timer < 0:
		spawn_Dropper(wave)
		wave.Timer = wave.maxTimer


func spawn_Dropper(wave):
	var Spawner_Bug_Child = Spawner_Bug.instance()
	Spawner_Bug_Child.StateList = wave.StateList
	Spawner_Bug_Child.TimeList = wave.TimerList
	Spawner_Bug_Child.transform.origin = Vector2(wave.DropperTransform.x,wave.DropperTransform.y)#to_global(Vector2(wave.DropperTransform.x,wave.DropperTransform.y))
	get_tree().current_scene.add_child(Spawner_Bug_Child)
	
	wave.Amount -= 1
	if wave.Amount == 0:
		waveCounter += 1
