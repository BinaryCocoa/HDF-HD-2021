extends Node2D

signal hit(damage)

var gunRotation
var bulletspeed
var fallspeed

var bulletTimer = 12.00
# Called when the node enters the scene tree for the first time.
func _ready():
	"""Set bullet speed and time"""
	bulletspeed = 1500
	fallspeed = 0
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	"""move bullet relativly forward, and slowly decreese direct speed"""
	bulletTimer = bulletTimer - delta
	if bulletTimer < 0:
		destroy_self()
	
	move_local_x(1*bulletspeed*delta)
	if bulletspeed > 50:
		bulletspeed -= 1
		fallspeed += .1
	set_position(Vector2(get_position().x,get_position().y + fallspeed))


func _on_Area2D_area_entered(area):
	"""If the bullet hits something Destroy it"""
	destroy_self()

func destroy_self():
	queue_free()
