################ THIS NEEDS A FULL OVERHAUL SO THAT I UNDERSTAND IT BETTER ###################################

extends Camera2D
var player_position

#/////////////////////////////////////////////////// SETUP START ///////////////////////////////////////////////////#
# Called when the node enters the scene tree for the first time.
func _ready():
	"""The Ready function is to call helper functions to set up the
	   rest of the script with the varibles and signals they will call
	   later"""
	_initilize_variables()
	_initilize_signals()

func _initilize_signals():
	"""Check if an object is in the scene if 
	they are connect the object to that node"""
	if get_tree().get_current_scene().get_node("Player1"):
		var player1 = get_tree().get_current_scene().get_node("Player1")
		player1.connect("pass_position",self,"set_player1_position")

func _initilize_variables():
	"""Initilize the variables that will 
	be used latter in the scripts"""
	pass
#///////////////////////////////////////////////// SETUP FINISHED /////////////////////////////////////////////////#

func _physics_process(delta):
	"""In the physics process we will call function that need to be updated
	   every frame. IE: Moveing down because of gravity or moving towards the player"""
	var _velocity = direction(delta)
	set_position(Vector2(get_position().x+_velocity.x,get_position().y)) 

func direction(delta)-> Vector2:
	"""Set the direction of the creature to make it follow the player and flip its
	sprite in tandam"""
	#var new_direction = Vector2(self.position.x,self.position.y)
	var new_direction = Vector2(self.position.x - player_position.x,player_position.y) 
									#Later will updated this to target position x to make it so that 
									#Ground Bugs can target Player 2 Or the worker droids 

	if self.position.x != player_position.x:				#Only Change if the is touching variable is true
		if new_direction.x <= 1:
			new_direction.x = +800*delta
		elif new_direction.x > 1:
			new_direction.x = -800*delta
	else:
		new_direction.x = 0
	return new_direction


func set_player1_position(player1_position):
	player_position = player1_position
