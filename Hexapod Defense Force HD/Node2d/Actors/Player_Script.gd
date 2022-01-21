#///////////////////////////////////////// CREATE LOCAL VARIABLES & SIGNALS /////////////////////////////////////////#
extends Actor_base

signal pass_position(Self_position)
signal pass_cur_health(Self_cur_health)
signal pass_max_health(Self_Max_health)
signal emit_velocity_x(Velocity)

# Declare member variables here. Examples:

var animator : AnimationPlayer
var cooldownTimer : Timer
var maxSpeed = 1000
var acceleration = 20
var drag = 40
var velocity = Vector2(0,0)
export var groundLevel = 0
#//////////////////////////////////////////////// CREATION FINISHED ////////////////////////////////////////////////#

#/////////////////////////////////////////////////// SETUP START ///////////////////////////////////////////////////#
# Called when the node enters the scene tree for the first time.
func _ready():
	"""Sets up the on declare varables, start timers"""
	_initilize_variables()
	_initilize_signals()
	_start_Timers()
	
func _initilize_signals():
	emit_signal("pass_max_health",max_health)
	
func _initilize_variables():
	groundLevel = groundLevel - 300
	gravity = 500
	max_health = 50
	cur_health = max_health
	animator = get_node("AnimationPlayer")
	
func _start_Timers():
	cooldownTimer = get_node("Dash_timer")
	cooldownTimer.start()
#///////////////////////////////////////////////// SETUP FINISHED /////////////////////////////////////////////////#

#///////////////////////////////////////////// UPDATE FUNCTIONS START /////////////////////////////////////////////#
func _physics_process(delta):
	"""Calls Calcluate Direction, resets speed if direction not heald
	slide and dash are also handeled here"""
	if cur_health > 0:
		Apply_gravity(delta)
		Movement(delta)
		Play_animation()

	emit_signal("emit_velocity_x",(velocity.x/maxSpeed))
	emit_signal("pass_position", self.position)
	
func Apply_gravity(delta):
	"""If the Player character os higher than the grounds 
	mid point, bring the player down by gravity every frame"""
	if self.position.y < groundLevel:
		self.position.y += delta*gravity

func Movement(delta):
	"""1st check if the right key or the left key are down if they are add acceleration to the apropriate side
	if they aren't decrease the speed of the the player if their velocity is more than 0. If the dash is 
	activated call the Dash script"""

	if Input.is_action_pressed("Right_press"):
		velocity.x += acceleration
	elif Input.is_action_pressed("Left_press"):
		velocity.x -= acceleration	
	else:											 #Slow the velocity  of the player if no button is pressed
		if velocity.x < 0:
			velocity.x = min(0, velocity.x+drag)
		elif velocity.x > 0:
			velocity.x = max(0, velocity.x-drag)
	#Simple check to cap the player at thier max spedd or the negative of their max speed
	if velocity.x > maxSpeed:
		velocity.x = maxSpeed
	elif velocity.x < -maxSpeed:
		velocity.x = -maxSpeed

	if Input.is_action_just_pressed("Dash") and cooldownTimer.time_left == 0.0 and velocity.x != 0: 
		Activate_dash()

	velocity.x += velocity.x * delta
	move_and_slide(velocity,Vector2.UP)
func Activate_dash():
	"""If the dash is activated set the players speed to max either positivly 
	or negativly. NOTE: This will likely need to change somehow as this doesn't
	have any functional gameplay purposes'"""
	print('x')
	cooldownTimer.start(1)
	if velocity.x > 0:
		velocity.x = maxSpeed
	elif velocity.x < 0:
		velocity.x = -maxSpeed

func Play_animation():
	"""Play diffrent animations for the player baised of the 
	velocity of the player"""
	if velocity.x > 0:
		get_child(0).scale.x = 1
		if Input.is_action_pressed("Right_press"):
			reset_Animation("Walking_ani")
		else:
			reset_Animation("Skidding_ani")
	elif velocity.x < 0:
		get_child(0).scale.x = -1
		if Input.is_action_pressed("Left_press"):
			reset_Animation("Walking_ani")
		else:
			reset_Animation("Skidding_ani")
	else:
		reset_Animation("idle_ani")

func reset_Animation(desiredAnimation):
	"""Whenever reset_Animations is called it 1st check if the animation we want is playing,
	If it is leave it alone. If it is not, Stop the animation, and reset it. 
	Remove all animations from the que"""
	if animator.get_current_animation() != desiredAnimation:	#Quick way to ensure the correct animation is playing.
		animator.stop(true)										#If not Stop and reset the animation. Clear Queue
		animator.clear_queue()									#add the current animation to the queue
		animator.queue(desiredAnimation)

#//////////////////////////////////////////////// UPDATE FUNCTIONS END ////////////////////////////////////////////////#

#///////////////////////////////////////// SIGNAL FUNCTIONS START ////////////////////////////////////////////////////#
func _on_BorderArea_area_entered(area):
	"""Detects if something has entersd the players hitbox and what it is"""
	if (area.is_in_group("Bullets")):
		_take_damage(5)

func _take_damage(damage):
	"""Apply Damage and pass the damage to the
	global node"""
	if cur_health > 0:
		cur_health -= damage
		emit_signal("pass_cur_health",cur_health)
	else:
		reset_Animation("Dying_ani")
		get_node("Player_gun").visible = false

func _on_AnimationPlayer_animation_started(anim_name):
	pass

func _on_AnimationPlayer_animation_finished(anim_name):
	if  anim_name == "Dying_ani":
		#yield(get_tree().create_timer(3),"timeout")
		queue_free()

#//////////////////////////////////////////////// SIGNAL FUNCTIONS END ////////////////////////////////////////////////#





