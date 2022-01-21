extends Area2D

onready var bulletSprite = get_node("Sprite")
var bulletImpulse = 2000
var bulletTimer = 10.0
var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity = Vector2(cos(rotation)*bulletImpulse, sin(rotation)*bulletImpulse)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	"""move bullet relativly forward, and slowly decreese direct speed"""
	var oldPosition = Vector2(position.x,position.y)
	velocity.y += (gravity*10)*delta
	position += velocity*delta
	
	rotation = (position-oldPosition).angle()	

	if bulletTimer > 0:
		bulletTimer -= delta
	else:
		destroy_self()	

func _on_Bullet_Node_area_entered(area):
	destroy_self()

func destroy_self():
	queue_free()
