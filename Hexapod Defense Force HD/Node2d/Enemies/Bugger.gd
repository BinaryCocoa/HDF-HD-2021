extends Actor_base

signal damage_player(damage)

var player_position
var animator : AnimationPlayer
var is_touching = false

# Called when the node enters the scene tree for the first time.
func _ready():
	"""The buggers on ready command is going to grab the animator to allow for animation
	and is going to set the health of the characters"""
	animator = $AnimationPlayer
	max_health = 2
	cur_health = max_health
	if get_tree().get_current_scene().get_node("GlobalNode"):
			var GlobalNode = get_tree().get_current_scene().get_node("GlobalNode")
			GlobalNode.connect("FinalSendPlayerPosition",self,"set_player1_position")
			
	if get_tree().get_current_scene().get_node("Player1"):
		connect("damage_player",get_tree().get_current_scene().get_node("Player1"),"_take_damage")
		
	
func _physics_process(delta):
	"""If Buggers Collider is not on the floor add a 'gravity' if it is give it the player
	possition and let it follow them, change the animator as it happenes"""
	
	if is_on_floor():
		animator.play("E01_Walking_anim")
		yield(get_tree().create_timer(.001),"timeout")
		_velocity = direction()
	else:
		animator.play("E01_Falling_anim")
		gravity()
	move_and_slide((_velocity*(10/2)),FLOOR_NORMAL)
	
func set_player1_position(player1_position):
	player_position = player1_position

func direction()-> Vector2:
	"""Set the direction of the creature to make it follow the player and flip its
	sprite in tandam"""
	var new_direction
	if is_touching == false:
		new_direction = Vector2 (player_position.x -self.position.x,self.position.y)
	
		if new_direction.x <= 1:
			new_direction.x = -20
			$Sprite.scale.x = -1
		elif new_direction.x > 1:
			new_direction.x = 20
			$Sprite.scale.x = 1
	else:
		new_direction = Vector2(0, self.position.y)
	 
	return new_direction

func gravity():
	"""Applay a basic gravity to the creature"""
	set_position(Vector2(get_position().x,get_position().y + 5))

func _on_Area2D_area_entered(area):
	"""Deliniates what has ented the creatures Area2d and does things baised on that"""
	if (area.is_in_group("Players")):

		
		"""^ This one works ^"""
		"""v This is a test v"""
		#connect("damage_player",get_node(NodePath("res://Node2d/Actors/Player.tscn")),"_take_damage")
		is_touching = true
		animator.play("E01_Bite_anim")
		emit_signal("damage_player",1)
		
	if (area.is_in_group("Bullets")):
		_on_Bullet_hit(1)
	

func _on_Area2D_area_exited(area):
	"""Deliniates what has exited the creatures Area2d and does things baised on that"""
	if (area.is_in_group("Players")):
		is_touching = false
	

func _on_Bullet_hit(damage):
	"""Apply Damage to ther players health, if the health is bellow Zero call the destroy
	Function"""
	cur_health -= damage
	if cur_health <= 0:
		DestroySelf()

func DestroySelf():
	queue_free()
	
func _on_animation_finished():
	print('x')
	print(animator.get_current_animation())
	if animator.get_current_animation() == "E01_Bite_anim":
		pass
	animator.stop()
