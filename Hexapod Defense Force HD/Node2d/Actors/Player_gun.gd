extends Node2D

signal giveRotation(rotationdegrees)

var bulletID : PackedScene = load("res://Node2d/Objects/Bullet.tscn")
var spawn_location : Node2D
var allowed_rotation
var Gunspeed
var fire_timer

func _ready():
	"""Sets teh spawn location"""
	spawn_location = get_node("Spawn_Location")
	fire_timer = .1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_fire_at()
	emit_signal("giveRotation",get_rotation_degrees())
	if fire_timer > 0.0:
		fire_timer -= .1*delta
	
	
func _fire_at():
	"""If fired fire at teh positiona dn angle 
	predertermeined by the gun nozzel"""	
	if Input.is_action_pressed("Fire_Button") and fire_timer <= 0.0:
		
		fire_timer =.1
		var bullet = bulletID.instance()
		get_tree().get_current_scene().add_child(bullet)

		bullet.transform.origin = to_global(Vector2(spawn_location.position.x, spawn_location.position.y))
		
func _on_Player1_pass_speed(Movement_speed):
	"""Move relative to the speed that the player is going"""
	var currentRoatation = get_rotation_degrees()
	
	if Input.is_action_pressed("Left_Press"):
		currentRoatation = get_rotation_degrees() - (Movement_speed/150)
	elif Input.is_action_pressed("Right_press"):
		currentRoatation = get_rotation_degrees() + (Movement_speed/150)
	else:
		if currentRoatation < -93:
			currentRoatation = get_rotation_degrees() + (Movement_speed/225)
		elif currentRoatation > -87:
			currentRoatation = get_rotation_degrees() - (Movement_speed/225)
		else:
			currentRoatation = -90
			
	set_rotation_degrees(max(min(0,currentRoatation),-180))
