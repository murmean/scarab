class_name BasePlayer
extends CharacterBody3D

var speed 
const CROUCH_SPEED: float  = 1.5 
const WALK_SPEED = 3.0
const SPRINT_SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.015




# Get the gravity from the pro

#Hand control
#@onready var hand = $hand
#@onready var flashlight = $hand/flashlight

#inventoryject settings to be synced with RigidBody nodes.
var gravity = 9.8
@export var inv:Inventory
@onready var inv_ui = $Inv_UI

#under objects detection
@export_range(5, 10, 0.1) var CROUCH_ANIMATION_SPEED: float = 7.0
@onready var under_object_cast = $Head/ShapeCast3D
var is_crouching = false

#changing level logic
@onready var fade_rect = $fade
@onready var animation_player = $AnimationPlayer




#camera-bob variables
const BOB_FREQ = 2.0
const BOB_AMP = 0.08
var t_bob = 0.0

#fov variables
const BASE_FOV = 75.0
const FOV_CHANGE = 1.5

@onready var head = $Head
@onready var camera = $Head/Camera3D




func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	under_object_cast.add_exception($".")




func _unhandled_input(event):
	if event is InputEventMouseMotion and inv_ui.visible == false:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x,deg_to_rad(-70),deg_to_rad(60))


func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and !under_object_cast.is_colliding() and is_crouching == false:
		velocity.y = JUMP_VELOCITY
		
	# Handle speed.  

			
	if Input.is_action_just_pressed("crouch") and is_on_floor():
		toggle_crouching()
		
	if Input.is_action_pressed("sprint") and is_on_floor() and is_crouching == false:
		speed = SPRINT_SPEED
	elif is_crouching == true:
		speed = CROUCH_SPEED
	else:
		speed= WALK_SPEED

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "frwd", "backwrd")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#decceleration
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)

	#head-bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	#FOV 
	var velocity_clamped = clamp(velocity.length(),0.5,SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov,target_fov, delta * 8.0)
	
	move_and_slide()

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ)* BOB_AMP
	pos.x = cos(time * BOB_FREQ/2) * BOB_AMP
	return pos

func collect(item):
	inv.insert(item)
	
	
#TODO TEST NEW CROUCHING SYSTEM
func toggle_crouching():
	if is_crouching == true and under_object_cast.is_colliding() == false:
		print("UNCROUCHING")
		animation_player.play("crouch", -1, -CROUCH_ANIMATION_SPEED, true)
	elif is_crouching == false:
		print("CROUCHING")
		animation_player.play("crouch", -1, CROUCH_ANIMATION_SPEED)

# fade when changing level
func fade():
	fade_rect.visible = true
	animation_player.play("fade_in")
	

func _on_animation_player_animation_started(anim_name):
	if anim_name == "crouch":
		is_crouching = !is_crouching
