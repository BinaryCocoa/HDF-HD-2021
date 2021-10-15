extends Node2D

var gunRotation
var bulletspeed
var fallspeed
# Called when the node enters the scene tree for the first time.
func _ready():
	bulletspeed = 1000
	fallspeed = 0
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_local_x(1*bulletspeed*delta)
	if bulletspeed > 50:
		bulletspeed -= 5
		fallspeed += .05
	set_position(Vector2(get_position().x,get_position().y + fallspeed))

	



func _on_Area2D_area_entered(area):
	queue_free()
