extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 14
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 75
# How high the player can jump
@export var jump_power = 80

#Vars for Camera movement
@export var mouseSensitivity = 0.01
@onready var neck := $Pivot/neck
@onready var camera := $Pivot/neck/Camera3D
@onready var character := $"Pivot/character-d2"

func _unhandled_input(event: InputEvent) -> void:								#For camera movement
	if event is InputEventMouseButton:											#if mouse click, mouse cursor gone
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif event.is_action("ui_cancel"):											#clicking escape will make your cursor come back with milk
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:							#everything important for camera movement
		if event is InputEventMouseMotion:
			var relative = event.relative * mouseSensitivity
			character.rotate_y(-relative.x)										#rotate character skin with the camera, just on the y axis
			neck.rotate_y(-relative.x)
			camera.rotate_x(-relative.y)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(90))				#clamps the x rotation of your head so you cant break ya neck
	
var target_velocity = Vector3.ZERO

func _physics_process(delta):
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		# Setting the basis property will affect the rotation of the node.
		#$Pivot.basis = Basis.looking_at(direction)
	
	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	# Vertical velocity (jumping and gravity)
	if is_on_floor():
		# Reset vertical velocity when on floor to prevent accumulation
		target_velocity.y = 0
		# Jump only when on floor
		if Input.is_action_just_pressed("jump"):
			target_velocity.y += jump_power
	else:
		# Apply gravity when in air
		target_velocity.y = velocity.y - (fall_acceleration * delta)
	
	# Moving the Character
	velocity = target_velocity
	move_and_slide()
