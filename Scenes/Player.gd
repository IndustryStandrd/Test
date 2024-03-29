extends CharacterBody3D


###Player###
@export var player_health = 100

####Player Movement###
var speed
@export var sprint_speed = 4.0
@export var walk_speed = 2.0
@export var jump_velocity = 6.5
@export var gravity = 20.0
@export var sensitivity = 0.004

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var player_interact = $Head/Camera3D/PlayerInteract
@onready var player_groundcamera = $GroundCheck
#Headbobbing 
var bob_freq = 4.5
var bob_amp = 0.04
var t_bob = 0.0



#Keeps the cursor within the game - hides it
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	


#mouse movement
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * sensitivity)
		camera.rotate_x(-event.relative.y * sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))
		


func _physics_process(delta):
	#this adds gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	#Handles jump / requires player be grounded
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jump_velocity
	
	#Handles sprinting
	if Input.is_action_pressed("Sprint"):
		speed = sprint_speed
	else:
		speed = walk_speed
	
	
	#Input direction and handles movement/deacceleration
	var input_dir = Input.get_vector("Left", "Right", "Forward", "Back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
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
	
	
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	move_and_slide()
	
func _process(delta):
	#This portion prints opening to the log if player presses the interact key while also looking at a collision object
	if player_interact.is_colliding() and Input.is_action_just_pressed("Interact"):
		print("Attempting interaction...")
		var interaction_target = player_interact.get_collider()
		if interaction_target:
			if interaction_target.has_method("on_interact"):
				var res = interaction_target.on_interact(self, player_interact)
				print("Interaction success: %s" % [res])
			else:
				print("Target %s is not interactable" % [interaction_target])
		else:
			print("No interaction target")

#Implementing footsteps - player_groundcamera is the raycast for the player that aims at the ground
#will be used to check which group the ground they are on top of is part of and play the correct footsteps
	if player_groundcamera.is_colliding():
		var player_terrain = player_groundcamera.get_collider().get_parent()
		print("I am on the ground")
	else: 
		print("I am not on the ground")

#Function will hold player footsteps and how where they should play
func player_footsteps():
	null


#function actually implements headbob using sine wave
func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * bob_freq) * bob_amp
	pos.x = cos(time * bob_freq / 2) * bob_amp
	return pos
