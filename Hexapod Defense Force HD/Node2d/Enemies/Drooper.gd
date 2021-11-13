extends "res://Node2d/Actors/StateMachine.gd"

signal OnAlive()

var buggers:PackedScene = preload("res://Node2d/Enemies/Bugger.tscn")
export var Timervariation = 0
var bugchild
export var bugTimerStart = 3
var bugTimer
var movement_timer = 1
var movement_array_position = 0
export var stateList = [[5,.1]]
var swipe_power = 3
var ActorClass 

# Called when the node enters the scene tree for the first time.
func _ready():
	ActorClass = get_child(0)
	ActorClass.max_health = 4
	ActorClass.cur_health = ActorClass.max_health
	
	bugTimer = bugTimerStart + randi() % 4
	
	add_state("Down", 1)
	add_state("Up",2)
	add_state("Swipe_L",3)
	add_state("Swipe_R",4)
	add_state("Idle",5)
	
	if get_tree().get_current_scene().get_node("Dropper Spawner"):
		var DropperSpawner = get_tree().get_current_scene().get_node("Dropper Spawner")
		DropperSpawner.connect("SendStateList",self,"_on_Dropper_Spawner_SendStateList")
	else:
		stateList.append([5,10])
		
	set_state(stateList[movement_array_position][0])
	movement_timer = stateList[movement_array_position][1]

func _on_Dropper_Spawner_SendStateList(State, Time):
	var i = 0
	if State.size() == stateList.size():
		pass
	else:
		for item in State:
			if i == 0:
				stateList[0] = [State[i],Time[i]]
				i += 1
			else:
				stateList.append([State[i],Time[i]])

func dropBug():
	bugchild = buggers.instance()
	get_tree().current_scene.add_child(bugchild)
	bugchild.transform.origin = to_global(Vector2($BugSpawner.position.x, $BugSpawner.position.y))
	bugTimer = bugTimerStart + randi() % 4
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	bugTimer = bugTimer - delta
	if bugTimer < 0:
		dropBug()

func _physics_process(delta):

	movement_timer = movement_timer - delta
	if Current_state == states.Down:
		moveDown(movement_timer)
	elif Current_state == states.Up:
		moveUp(movement_timer)
	elif Current_state == states.Idle:
		idle(movement_timer)
	elif Current_state == states.Swipe_L:
		swipe_Left(movement_timer,delta)
	elif Current_state == states.Swipe_R:
		swipe_Right(movement_timer,delta)	
	
func moveDown(time):
	set_position(Vector2(get_position().x,get_position().y + 5))
	if time < 0:
		_exit_state(states.Down,
					stateList[movement_array_position][0])
	return
	
func moveUp(time):
	set_position(Vector2(get_position().x,get_position().y - 5))
	if time < 0:
		_exit_state(states.Up,
					stateList[movement_array_position][0])
	return

func idle(time):
	if time < 0:
		_exit_state(states.Idle,
					stateList[movement_array_position][0])
	return

func swipe_Left(time, delta):
	set_position(Vector2(get_position().x + 8,get_position().y + swipe_power))
	swipe_power = swipe_power - ((time)*delta)
	if time < 0:
		swipe_power = 3
		_exit_state(states.Swipe_L,
					stateList[movement_array_position][0])

func swipe_Right(time, delta):
	set_position(Vector2(get_position().x - 8,get_position().y + swipe_power))
	swipe_power = swipe_power - ((time)*delta)
	if time < 0:
		swipe_power = 3
		_exit_state(states.Swipe_R,
					stateList[movement_array_position][0])
					
func _exit_state(old_state, new_state):
	print(movement_array_position)
	if movement_array_position+1 == stateList.size():
		movement_array_position = 0
	else:
		movement_array_position += 1
	
	Current_state = stateList[movement_array_position][0]
	print(Current_state)
	movement_timer = stateList[movement_array_position][1]
	#set_state(stateList[movement_array_position][0])
	#movement_timer = stateList[movement_array_position][1]



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
	queue_free()




