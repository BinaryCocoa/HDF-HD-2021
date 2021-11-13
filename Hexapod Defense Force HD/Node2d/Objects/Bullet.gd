extends Area2D


onready var bulletSprite = get_node("Sprite")
var bulletSpeed = 50
var bulletTimer = 1.00
var gunRotation = 0
var speed = Vector2()
var direction = 0

var it = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(.01),"timeout")
	if get_tree().get_current_scene().get_node("Player1").get_node("Player_gun"):
		var player_gun = get_tree().get_current_scene().get_node("Player1").get_node("Player_gun")
		player_gun.connect("giveRotation",self,"Setup")

	yield(get_tree().create_timer(.01),"timeout")
	speed = Vector2(abs(cos(gunRotation))*direction*bulletSpeed, abs(sin(gunRotation))*-bulletSpeed)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	"""move bullet relativly forward, and slowly decreese direct speed"""
	speed.y += (gravity)*delta
	position += speed

	if it != 10:
		it +=1
		print("\nSpeed X Value " + str(speed.x) 
		+ "\nSpeed Y Value " + str(speed.y)+ "\n" 
		+ "Gun Rotation " + str(gunRotation) + "\n" 
		+ "Direction " + str(direction) + "\n"
		+ "Mod sign of gunRotation " + str(abs(gunRotation)*direction) + '\n')
	
	if bulletTimer >0:
		bulletTimer -= 1*delta
	else:
		it = 0
		destroy_self()	
	

func _on_Bullet_Node_area_entered(area):
	destroy_self()

func destroy_self():
	queue_free()

func Setup(GunRotation):
	if GunRotation < -90:
		direction = -1
	elif GunRotation >= -90:
		direction = 1
	gunRotation = GunRotation

