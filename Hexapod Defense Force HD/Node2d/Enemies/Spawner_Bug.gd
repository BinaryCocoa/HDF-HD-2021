#///////////////////////////////////////// CREATE LOCAL VARIABLES & SIGNALS /////////////////////////////////////////#
extends "res://Node2d/Actors/StateMachine.gd"

signal Updated_points(points)

var GroundBug:PackedScene = preload("res://Node2d/Enemies/Ground_Bug.tscn")
export var Timervariation = 0
var bugchild
export var bugTimerStart = 3
var bugTimer
var bugSpawner: Node2D
var movement_timer = 0
var arrayPosition = 0
export var StateList = ["Idle"]
export var TimeList = [10]
var ActorClass 
#//////////////////////////////////////////////// CREATION FINISHED ////////////////////////////////////////////////#

#/////////////////////////////////////////////////// SETUP START ///////////////////////////////////////////////////#
# Called when the node enters the scene tree for the first time.
func _ready():
	"""The Ready function is to call helper functions to set up the
	   rest of the script with the varibles, signals and states that will be
	   called later"""
	_initilize_variables()
	_initilize_signals()
	_start_states()

func _initilize_variables():
	"""Initilize the variables that will 
	be used latter in the scripts"""
	ActorClass = find_node("Actor_base")
	ActorClass.max_health = 4
	ActorClass.cur_health = ActorClass.max_health
	bugSpawner = get_node("BugSpawner")
	bugTimer = bugTimerStart + randi() % 4
	

func _initilize_signals():
	"""Check if an object is in the scene if 
	they are connect the object to that node"""
	if get_tree().get_current_scene().get_node("GlobalNode"):
			var GlobalNode = get_tree().get_current_scene().get_node("GlobalNode")
			self.connect("Updated_points",GlobalNode,"updatePoints")

func _start_states():
	"""Add the states to help the state machine actually function. 
	_NOTE_ Possibly need to be re-examine how state
	machines work to have a better understanding of this"""
	set_state(StateList[arrayPosition])
	movement_timer = TimeList[arrayPosition]
	
#///////////////////////////////////////////////// SETUP FINISHED /////////////////////////////////////////////////#

#///////////////////////////////////////////// UPDATE FUNCTIONS START /////////////////////////////////////////////#
func _physics_process(delta):
	"""In the physics process we will call function that need to be updated
	   every frame. IE: Moveing down because of gravity or moving towards the player"""
	decrease_timer(delta)
	Update_state(delta)
	if bugTimer < 0:
		dropBug()

func decrease_timer(delta):
	"""This decreaser timers by 1/60 second every frame"""
	bugTimer = bugTimer - delta
	movement_timer = movement_timer - delta
	
func Update_state(delta):
	"""Checks every frame what the current state is and calls the move function accordingly"""
	if movement_timer <= 0:
		_exit_state(StateList[arrayPosition])
	elif Current_state == "MoveDown":
		moveDown(movement_timer,delta)
	elif Current_state == "MoveUp":
		moveUp(movement_timer,delta)
	elif Current_state == "Idle":
		idle(movement_timer,delta)
	elif Current_state == "MoveLeft":
		swipe_Left(movement_timer,delta)
	elif Current_state == "MoveRight":
		swipe_Right(movement_timer,delta)

func dropBug():
	"""If the bug timer has reached 0 instanitate a ground bug and set groud bug to the position of the
	bug spawner node and reset bug timer"""
	bugchild = GroundBug.instance()
	bugchild.transform.origin = to_global(Vector2($BugSpawner.position.x, $BugSpawner.position.y))
	get_tree().current_scene.add_child(bugchild)
	bugTimer = bugTimerStart + randi() % 4

func moveDown(time_left,delta):
	"""Simple move down pattern. If time reaches zeron go through _exit_state"""
	set_position(Vector2(get_position().x,get_position().y + 100*delta))
	if (time_left <= 0):
		_exit_state(StateList[arrayPosition])

func moveUp(time_left,delta):
	set_position(Vector2(get_position().x,get_position().y - 50*delta))
		
func idle(time_left,delta):
	pass

func swipe_Left(time_left, delta):
	var velocity = Vector2(get_position().x +(60*delta), get_position().y+(-cos(time_left))*2)
	self.position = velocity
	self.position.y += .1
	
func swipe_Right(time_left, delta):
	var velocity = Vector2(get_position().x -(60*delta), get_position().y+(-cos(time_left))*2)
	self.position = velocity
	self.position.y += .1
	

func _exit_state(state_List):
	"""If the next peice of the state is non existant reset to position 0"""
	if arrayPosition+1 <= len(StateList)-1:
		arrayPosition += 1
	else:
		arrayPosition = 0
	set_state(StateList[arrayPosition])
	movement_timer = TimeList[arrayPosition]
	
#///////////////////////////////////////// UPDATE FUNCTIONS END ////////////////////////////////////////////////////#

#//////////////////////////////////////// SIGNAL FUNCTIONS START ///////////////////////////////////////////////////#
func _on_Area2D_area_entered(area):
	"""Deliniates what has ented the creatures Area2d and 
	does things baised on that"""
	if (area.is_in_group("Bullets")):
		_on_Bullet_hit(1)

func _on_Bullet_hit(damage):
	"""Apply Damage to ther players health, if the health is bellow Zero call the destroy
	Function"""
	ActorClass.cur_health -= damage
	if ActorClass.cur_health <= 0:
		DestroySelf()

func DestroySelf():
	emit_signal("Updated_points",50)
	queue_free()
#///////////////////////////////////////// SIGNAL FUNCTIONS END//////////////////////////////////////////////////////#
