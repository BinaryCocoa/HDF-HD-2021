#///////////////////////////////////////// CREATE LOCAL VARIABLES & SIGNALS /////////////////////////////////////////#
extends "res://Node2d/Actors/Enemy_Base.gd"
#Create signals that will be sent out later
signal damage_player(damage)
signal Updated_points(points)
#Create local global variables for objects
var player_position = Vector2(0,0)
var animator : AnimationPlayer
var is_touching = false
var floor_value = 0.00
var has_touched_down = false
#//////////////////////////////////////////////// CREATION FINISHED ////////////////////////////////////////////////#

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
	if get_tree().get_current_scene().get_node("GlobalNode"):
			var GlobalNode = get_tree().get_current_scene().get_node("GlobalNode")
			GlobalNode.connect("FinalSendPlayerPosition",self,"set_player1_position")
			self.connect("Updated_points",GlobalNode,"updatePoints")
			
	if get_tree().get_current_scene().get_node("Player1"):
		var player1 = get_tree().get_current_scene().get_node("Player1")
		player1.connect("pass_position",self,"set_player1_position")
		connect("damage_player",get_tree().get_current_scene().get_node("Player1"),"_take_damage")

func _initilize_variables():
	"""Initilize the variables that will 
	be used latter in the scripts"""
	
	#1: Find the connected Objects
	animator = $AnimationPlayer
	#2: Initilize global Variables
	Enemy_points = 10
	max_health = 2
	cur_health = max_health
	floor_value = floor_value + (rand_range(-200,400))
	self.z_index = round(floor_value)
#///////////////////////////////////////////////// SETUP FINISHED /////////////////////////////////////////////////#

#///////////////////////////////////////////// UPDATE FUNCTIONS START /////////////////////////////////////////////#
func _physics_process(delta):
	"""In the physics process we will call function that need to be updated
	   every frame. IE: Moveing down because of gravity or moving towards the player"""
	if to_global(self.position).y <= floor_value and has_touched_down == false:
		gravity(delta)
	elif is_touching != true:
		#yield(get_tree().create_timer(.01),"timeout")
		_velocity = direction(delta)
		move_and_slide((_velocity*(10/2))) # Move and slide adds gravity indpendent of the Gravity function need to change it
	else:
		que_damage()
		

func reset_Animation(desiredAnimation):
	"""Whenever reset_Animations is called 1st check if the animation we want is playing,
	If it is leave it alone. If it is not, Stop the animation, and reset it. 
	Remove all animations from the que"""
	if animator.get_current_animation() != desiredAnimation:	#Quick way to ensure the correct animation is playing
		animator.stop(true)										#If not Stop and reset the animation. Clear Queue
		animator.clear_queue()									#add the current animation to the queue
		animator.queue(desiredAnimation)

func gravity(delta):
	"""Applay a basic gravity to the creature"""
	reset_Animation("E01_Falling_anim")
	set_position(Vector2(get_position().x,get_position().y + (300*delta))) 

func que_damage():
	"""Ques the Damage animation and will call a signal to check if at the end of the animation"""
	reset_Animation("E01_Bite_anim")

func direction(delta)-> Vector2:
	"""Set the direction of the creature to make it follow the player and flip its
	sprite in tandam"""
	reset_Animation("E01_Walking_anim")
		
	var new_direction = Vector2(self.position.x - player_position.x,player_position.y) 
									#Later will updated this to target position x to make it so that 
									#Ground Bugs can target Player 2 Or the worker droids 
									
	if is_touching == false:				#Only Change if the is touching variable is true
		if new_direction.x <= 1:
			new_direction.x = +2000*delta		#This is a repersnetation of the speed on the Horizontal Axis
##__Note: shold probably change to an actual speed variable__
			$Sprite.scale.x = -1			#This flips the sprite to the Left
		elif new_direction.x > 1:
			new_direction.x = -2000*delta		#This is a representation of the speed on the Horizontal Axis 
##__Note: shold probably change to an actual speed variable__
			$Sprite.scale.x = 1				#This flips the sprie to the Right
	else:
		new_direction.x = 0
	return new_direction
	
func DestroySelf():
	emit_signal("Updated_points",Enemy_points)
	queue_free()
#///////////////////////////////////////// UPDATE FUNCTIONS END ////////////////////////////////////////////////////#

#//////////////////////////////////////// SIGNAL FUNCTIONS START ///////////////////////////////////////////////////#
func set_player1_position(player1_position):
	player_position = player1_position

func _on_Area2D_area_entered(area):
	"""Deliniates what has ented the creatures Area2d and does things baised on that"""
	if (area.get_parent().is_in_group("Players")):
		is_touching = true		
	if (area.is_in_group("Bullets")):
		_on_Bullet_hit(1)
	

func _on_Area2D_area_exited(area):
	"""Deliniates what has exited the creatures Area2d and does things baised on that"""
	if (area.get_parent().is_in_group("Players")):
		is_touching = false

func _on_Bullet_hit(damage):
	"""Apply Damage to ther players health, if the health is bellow Zero call the destroy
	Function"""
	cur_health -= damage
	
	if cur_health <= 0:
		DestroySelf()

func _on_AnimationPlayer_animation_finished(anim_name):
	"""This will allow functions to be called at the end of an animation"""
	if(anim_name == "E01_Bite_anim"):
		emit_signal("damage_player",1)
		
	
#///////////////////////////////////////// SIGNAL FUNCTIONS END//////////////////////////////////////////////////////#


