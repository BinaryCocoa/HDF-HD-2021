extends Actor_base

signal pass_speed(Movement_speed)
signal pass_position(Self_position)
signal pass_cur_health(Self_cur_health)
signal pass_max_health(Self_Max_health)
# Declare member variables here. Examples:

var animator : AnimationPlayer
var cooldownTimer : Timer
var speed := min_speed

# Called when the node enters the scene tree for the first time.
func _ready():
	"""Sets up the on declare varables, start timers"""
	max_health = 50
	cur_health = max_health
	animator = get_node("AnimationPlayer")
	cooldownTimer = get_node("Dash_timer")
	cooldownTimer.start()
	emit_signal("pass_max_health",max_health)

func _physics_process(delta):
	"""Calls Calcluate Direction, resets speed if direction not heald
	slide and dash are also handeled here"""
	var direction := Calculate_direction() #get a vector 2 to represent left and right input
	if direction.x == 0.0:
		speed = min_speed
	else:
		speed = speed + 10
	_velocity = calculate_Velocity(_velocity, direction,speed) #Determine which direction The user Input
	if Input.is_action_just_pressed("Dash") and cooldownTimer.time_left == 0.0: 	#Quickly check if the dash button was pressed
		Set_dash_speed()															#If yes make sure cooldown timer is 0, then increase
																					#speed
	_velocity =  move_and_slide(_velocity,FLOOR_NORMAL) # begin Movement

func _on_BorderArea_area_entered(area):
	if (area.is_in_group("Bullets")):
		_take_damage(5)


func Calculate_direction() ->Vector2:
	"""direction tells the player which direction 
	to move Right adds 1 to the direction left
	subtracts it"""
	var new_direction := Vector2 (Input.get_action_strength("Right_press") 								- Input.get_action_strength("Left_Press"), 0)
	return new_direction


func calculate_Velocity (linear_velocity : Vector2,
						direction: Vector2,
						Mspeed : float
						) -> Vector2:
	"""Move the animation and calcluate velocity"""						
	if !Input.is_action_pressed("Dash") :
		Mspeed = min(Mspeed,max_speed)
	emit_signal("pass_speed",Mspeed)
	var new_velocity := linear_velocity # set velocity to itself 
	new_velocity.y += gravity * get_physics_process_delta_time()
	new_velocity.x = Mspeed * direction.x # update th x position to a speed times direction
	#play animation as the thing moves
	if new_velocity.x > 0: # Walk Right
		get_child(0).scale.x = 1
		animator.play("Walking_ani")
	elif new_velocity.x < 0: # walk Left
		get_child(0).scale.x = -1
		animator.play("Walking_ani")
	else:
		animator.stop()
		animator.play("idle_ani")
	return new_velocity

func Set_dash_speed():
	"""Starts the dash and resets the timer"""
	cooldownTimer.start(1)
	speed = speed*4
	yield(get_tree().create_timer(.25),"timeout")
	speed = 300.0
	
func _process(delta):
	"""Pass the position of Self 
	to the global node to be picked up"""
	emit_signal("pass_position", self.position)

func _take_damage(damage):
	"""Apply Damage and pass the damage to the
	global node"""
	cur_health -= damage
	emit_signal("pass_cur_health",cur_health)
	
	if cur_health <= 0:
		queue_free()
		
