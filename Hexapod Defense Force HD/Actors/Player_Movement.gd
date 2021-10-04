extends Actor_base

signal pass_speed(Movement_speed)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var animator : AnimationPlayer
var cooldownTimer : Timer
var speed := min_speed

# Called when the node enters the scene tree for the first time.
func _ready():
	animator = get_node("AnimationPlayer")
	cooldownTimer = get_node("Dash_timer")
	cooldownTimer.start()

func _physics_process(delta):
	
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
	

	

func Calculate_direction() ->Vector2:
	#direction tells the player which direction to move Right adds 1 to the direction left
	# subtracts it
	var new_direction := Vector2 (Input.get_action_strength("Right_press") 
								- Input.get_action_strength("Left_Press"), 0)
	return new_direction


func calculate_Velocity (linear_velocity : Vector2,
						direction: Vector2,
						speed : float
						) -> Vector2:
							
						
	if !Input.is_action_pressed("Dash") :
		speed = min(speed,max_speed)
	emit_signal("pass_speed",speed)
		

	var new_velocity := linear_velocity # set velocity to itself 

	new_velocity.x = speed * direction.x # update th x position to a speed times direction
	
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
	cooldownTimer.start(1)
	speed = speed*4
	yield(get_tree().create_timer(.25),"timeout")
	speed = 300.0
