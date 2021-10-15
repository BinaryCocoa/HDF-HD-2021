extends Actor_base

var player_position
var Animator : AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	Animator = $AnimationPlayer
	
func _physics_process(delta):

	
	if is_on_floor():
		Animator.play("E01_Walking_anim")
		player_position = get_parent().get_node("GlonalNode").Player_position
		_velocity = direction()
	else:
		Animator.play("E01_Falling_anim")
		_velocity = gravity()
	
	move_and_slide((_velocity*(min_speed/2)*delta),FLOOR_NORMAL)
	
	

func direction()-> Vector2:
	var new_direction := Vector2 (player_position.x -self.position.x,self.position.y- 0)
	
	if new_direction.x <= 1:
		$Sprite.scale.x = -1
	elif new_direction.x > 1:
		$Sprite.scale.x = 1
		
	return new_direction

func gravity()-> Vector2:
	var gravity:= Vector2(0,self.position.y - .10)
	return gravity


func _on_Area2D_area_entered(area):
	print('x')
	_velocity = Vector2.ZERO
