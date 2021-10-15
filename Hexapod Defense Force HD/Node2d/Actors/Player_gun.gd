extends Node2D

signal fire_bullet

var bulletID : PackedScene = load("res://Node2d/Objects/Bullet.tscn")
var spawn_location : Node2D
var allowed_rotation
var Gunspeed
var fire_timer

func _ready():
	spawn_location = get_node("Spawn_Location")
	fire_timer = get_node("Fire_timer")
	fire_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#_rotate_at()
	_fire_at()
	
	
func _fire_at():
	if Input.is_action_pressed("Fire_Button") and fire_timer.time_left == 0.0:
		var bullet = bulletID.instance()
		get_tree().get_current_scene().add_child(bullet)
		bullet.transform.origin = to_global(Vector2(spawn_location.position.x, spawn_location.position.y))
		bullet.rotation = rotation
		fire_timer.start(.33)



func _on_KinematicBody2D_pass_speed(Movement_speed):
	var currentRoatation = get_rotation_degrees()
	
	if Input.is_action_pressed("Left_Press"):
		currentRoatation = get_rotation_degrees() - (Movement_speed/450)
	elif Input.is_action_pressed("Right_press"):
		currentRoatation = get_rotation_degrees() + (Movement_speed/450)
	else:
		if currentRoatation < -93:
			currentRoatation = get_rotation_degrees() + (Movement_speed/225)
		elif currentRoatation > -87:
			currentRoatation = get_rotation_degrees() - (Movement_speed/225)
		else:
			currentRoatation = -90
			
	set_rotation_degrees(max(min(0,currentRoatation),-180))
