extends Actor_base


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var animator : AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	animator = get_node("AnimationPlayer")

func _physics_process(delta):
	var direction := Calculate_direction() #get a vector 2 to represent left and right input
	_velocity = calculate_Velocity(_velocity, direction,speed)
	#var flip_sprite = 
	_velocity =  move_and_slide(_velocity,FLOOR_NORMAL)
	
	

func Calculate_direction() ->Vector2:
	#direction tells the player which direction to move Right adds 1 to the direction left
	# subtracts it
	var new_direction := Vector2 (Input.get_action_strength("Right_press") 
								- Input.get_action_strength("Left_Press"), 0)
	return new_direction


func calculate_Velocity (linear_velocity : Vector2,
						direction: Vector2,
						speed : Vector2
						) -> Vector2:
	
	var new_velocity := linear_velocity # set velocity to itself 
	new_velocity.x = speed.x * direction.x # update th x position to a speed times direction
	#play animation as the thing moves
	if new_velocity.x > 0:
		self.scale.x = -1
		animator.play("Walking_ani")
	elif new_velocity.x < 0:
		self.scale.x = 1
		animator.play("Walking_ani")
	else:
		animator.stop()
		animator.play("idel_ani")
	# TODO: add a timer and a key to see if q or E is pressed if 
	# so increase speed for 1 second
	
	return new_velocity
