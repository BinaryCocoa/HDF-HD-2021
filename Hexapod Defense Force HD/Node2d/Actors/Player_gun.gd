#///////////////////////////////////////// CREATE LOCAL VARIABLES & SIGNALS /////////////////////////////////////////#
extends Node2D

var bulletID : PackedScene = load("res://Node2d/Objects/Bullet.tscn")
var spawn_location : Node2D
var Self_rotation
var Gunspeed
var fire_timer
#//////////////////////////////////////////////// CREATION FINISHED ////////////////////////////////////////////////#

#/////////////////////////////////////////////////// SETUP START ///////////////////////////////////////////////////#
func _ready():
	"""The Ready function is to call helper functions to set up the
	   rest of the script with the varibles and signals they will call
	   later"""
	_initilize_variables()
	_initilize_signals()

	
func _initilize_signals():
	"""Check if an object is in the scene if 
	they are connect the object to that node"""
	pass
	
func _initilize_variables():
	"""Initilize the variables that will 
	be used latter in the scripts"""
	spawn_location = get_node("Spawn_Location")
	fire_timer = .05
	
#////////////////////////////////////////////////// SETUP FINISHED //////////////////////////////////////////////////#
	
#////////////////////////////////////////////// UPDATE FUNCTIONS START //////////////////////////////////////////////#
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	"""In the physics process we will call function that need to be updated every frame. 
	IE Reducing the timer if its larger than 0, or firing the button if pressed"""
	decreese_timer(delta)
	_fire_at()

func decreese_timer(delta):
	"""Reduce the Timer if it is larger than 0. The timer is updated only if a bullet is 
	fired and only to that of 1/5 of a second. 
__NOTE: This could change based off of what powerups the player is using, to add some tacticts to play"""
	if fire_timer > 0.0:
		fire_timer -= delta	

func _fire_at():
	"""If the Fire_Button is pressed and the timer is 0.0, reset timer and instanciate a bullet object at the
	top level of the scene to keep it from being influenced by the player moving the gun. Add a small amount of
	randomness to the bullets angels to feel less monotonunes"""
	if Input.is_action_pressed("Fire_Button") and fire_timer <= 0.0:
		fire_timer =.05  #Reset Timer
		var bullet = bulletID.instance() #Instansiate Bullet
		bullet.transform.origin = to_global(Vector2(spawn_location.position.x, spawn_location.position.y)) 
		#Spawn at the position of th gun Nozzel, and convert it to global position to avoid odditites
		bullet.set_rotation(get_rotation()+((randf()-.5)/12)) #add a little randomnous to the angle between 0 -.04167
		get_tree().get_current_scene().add_child(bullet) #Set the bullet to the top layer of the scene 

#//////////////////////////////////////////////// UPDATE FUNCTIONS END ////////////////////////////////////////////////#

#///////////////////////////////////////// SIGNAL FUNCTIONS START ////////////////////////////////////////////////////#
func _on_Player1_emit_velocity_x(XVelocity_Percentage):
	"""XVelocity_Percentage is the percentage of the players current velocity divided by their max velocity giving us 
	   a percentage between -100% and 100%. Multiplying XVelocity_Percentage by (PI/2) Gives us Radians that are locked
	   to a half circile. Subtracting by half PI Offests the Gun by 90 degrees having the resting position be vertical
	"""	
	Self_rotation = XVelocity_Percentage * (PI/2) - (PI/2)
	set_rotation(Self_rotation)
	
#//////////////////////////////////////////////// SIGNAL FUNCTIONS END ////////////////////////////////////////////////#
