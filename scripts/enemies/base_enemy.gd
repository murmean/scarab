extends CharacterBody3D

class_name BaseEnemy

#player follow
var player = null
@export var player_path :NodePath
@onready var nav_agent = $NavigationAgent3D
@onready var raycasts = $Raycasts
var dirs: Array[Vector3]



const SPEED = 2.
const JUMP_VELOCITY = 4.5


var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready():
	for cast in raycasts.get_children():
		if cast is RayCast3D:
			dirs.append(Vector3(cast.target_position))
	
	player = get_node(player_path)

func _physics_process(delta):
	
	
	#Navigation
	velocity = Vector3.ZERO
	nav_agent.set_target_position(player.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	var next_nav_point_normal = to_local(next_nav_point).normalized()
	var interest_vector = _get_dot_product(next_nav_point_normal, dirs)
	var danger_vector = _get_danger_vector(raycasts.get_children())
	var context_map = _get_context_map(interest_vector, danger_vector)
	var direction = _get_fav_dir(context_map)
	velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	var steering_force = (velocity - dirs[direction]) * 2
	velocity = velocity - steering_force
	velocity.y -= 10
	#velocity = lerp(position, steering_force, Vector3(1, 1, 1))
	

	look_at(Vector3(player.global_position.x, global_position.y,player.global_position.z),Vector3.UP)
	
	move_and_slide()

func _get_dot_product(vec: Vector3, dirs: Array[Vector3]) -> Array[float]:
	var dots: Array[float]
	for dir in dirs:
		dots.append(vec.dot(dir))
	return dots

func _get_danger_vector(dirs: Array[Node]) -> Array[float]:
	var danger: Array[float]
	for i in dirs.size():
		danger.append(0.0)
	for i in dirs.size():
		if dirs[i].is_colliding():
			danger[i] = 5.0
			#if danger[i+1] == 0:
			#	danger[i + 1] = 2.0
			#if danger[i-1] == 0:
			#	danger[i - 1] = 2.0
	return danger

func _get_context_map(interest, danger) -> Array[float]:
	var context: Array[float]
	for i in range(interest.size()):
		context.append(interest[i] - danger[i])
	return context

func _get_fav_dir(context) -> int:
	var fav: int = context[0]
	var val: float
	for i in range(context.size()):
		if context[i] > val:
			fav = i
			val = context[i]
	return fav
