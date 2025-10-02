extends CharacterBody3D

@onready var status = get_parent()												#used for keeping track of statuses z.B. isGhost?

@export var speed = 14

#Vars for Camera movement
@export var mouseSensitivity = 0.01
@onready var neck := $Pivot/neck
@onready var camera := $Pivot/neck/Camera3D
@onready var character := $"Pivot/character-r2"

func _unhandled_input(event: InputEvent) -> void:								#For camera movement
	if status.isGhost:
		camera.current = true
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
	else:
		camera.current = false
	
var target_velocity = Vector3.ZERO

func _physics_process(delta):
	if status.isGhost:
		var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
		var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
		if direction != Vector3.ZERO:
			direction = direction.normalized()
			# Setting the basis property will affect the rotation of the node.
			#$Pivot.basis = Basis.looking_at(direction)
		
		# Ground Velocity
		target_velocity = direction * speed
		target_velocity.z = direction.z * speed
		
		# Vertical velocity (jumping and gravity)
		
		# Moving the Character
		velocity = target_velocity
		move_and_slide()
