extends "res://Node2d/Actors/StateMachine.gd"

signal Updated_points(points)

var GroundBug:PackedScene = preload("res://Node2d/Enemies/Ground_Bug.tscn")
export var Timervariation = 0
var bugchild
export var bugTimerStart = 3
var bugTimer

var movement_timer = 1
var movement_array_position = 0
export var stateList = []
var swipe_power = 3
var ActorClass 

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_tree().get_current_scene().get_node("GlobalNode"):
			var GlobalNode = get_tree().get_current_scene().get_node("GlobalNode")
			self.connect("Updated_points",GlobalNode,"updatePoints")
			
	ActorClass = get_child(0)
	ActorClass.max_health = 4
	ActorClass.cur_health = ActorClass.max_health
	
	bugTimer = bugTimerStart + randi() % 4
	
	add_state("Down", 1)
	add_state("Up",2)
	add_state("Swipe_L",3)
	add_state("Swipe_R",4)
	add_state("Idle",5)

	set_state(stateList[movement_array_position][0])
	movement_timer = stateList[movement_array_position][1]

func dropBug():
	bugchild = GroundBug.instance()
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
					stateList[0][movement_array_position])
	return
	
func moveUp(time):
	set_position(Vector2(get_position().x,get_position().y - 5))
	if time < 0:
		_exit_state(states.Up,
					stateList[0][movement_array_position])
	return

func idle(time):
	if time < 0:
		_exit_state(states.Idle,
					stateList[0][movement_array_position])
	return

func swipe_Left(time, delta):
	set_position(Vector2(get_position().x + 8,get_position().y + swipe_power))
	swipe_power = swipe_power - ((time)*delta)
	if time < 0:
		swipe_power = 3
		_exit_state(states.Swipe_L,
					stateList[0][movement_array_position])

func swipe_Right(time, delta):
	set_position(Vector2(get_position().x - 8,get_position().y + swipe_power))
	swipe_power = swipe_power - ((time)*delta)
	if time < 0:
		swipe_power = 3
		_exit_state(states.Swipe_R,
					stateList[0][movement_array_position])
					
func _exit_state(old_state, new_state):
	
	if movement_array_position+1 == len(stateList[0]):
		movement_array_position = 0
	else:
		movement_array_position += 1

	new_state = stateList[0][movement_array_position]
	movement_timer = stateList[1][movement_array_position]
	
	set_state(new_state)



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




