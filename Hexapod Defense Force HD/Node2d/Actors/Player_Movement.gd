extends Actor_base

signal pass_speed(Movement_speed)
signal pass_position(Self_position)
signal pass_cur_health(Self_cur_health)
signal pass_max_health(Self_Max_health)
# Declare member variables here. Examples:

var animator : AnimationPlayer
var cooldownTimer : Timer
var maxSpeed = 1000
var acceleration = 20
var drag = 40
var velocity = Vector2(0,0)

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
	#
	velocity.y += delta*gravity

	if Input.is_action_pressed("Right_press"):
		velocity.x += acceleration
		animator.play("Walking_ani")
		get_child(0).scale.x = 1
	elif Input.is_action_pressed("Left_press"):
		velocity.x -= acceleration
		get_child(0).scale.x = -1
		animator.play("Walking_ani")	
	else:	
		animator.stop()
		animator.play("idle_ani")
		if velocity.x < 0:
			velocity.x = min(0, velocity.x+drag)
		elif velocity.x > 0:
			velocity.x = max(0, velocity.x-drag)

	if velocity.x > maxSpeed:
		velocity.x = maxSpeed
	elif velocity.x < -maxSpeed:
		velocity.x = -maxSpeed
	else:
		print(velocity.x)

	velocity.x += velocity.x * delta


	move_and_slide(velocity,Vector2.UP)

	
	if Input.is_action_just_pressed("Dash") and cooldownTimer.time_left == 0.0: 	#Quickly check if the dash button was pressed
		cooldownTimer.start(1)
		if velocity.x > 0:
			velocity.x = maxSpeed
		elif velocity.x < 0:
			velocity.x = -maxSpeed
			
			
func _on_BorderArea_area_entered(area):
	if (area.is_in_group("Bullets")):
		_take_damage(5)


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
		
