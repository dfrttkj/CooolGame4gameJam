extends CharacterBody3D

# Nvigaion
@onready var nav_agent = $NavigationAgent3D
@export var player: Node3D # Assign your player node in the inspector

# Movment properties
@export var movement_speed = 5.0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	nav_agent.path_desired_distance = 0.5
	nav_agent.target_desired_distance = 0.5

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Update pathfinding targate to player position
	if player:
		nav_agent.rarget_position = player.global_position
		
		# Get next path position and calculate movement direction
		var next_path_pos = nav_agent.get_next_path_position();
		var direction = (next_path_pos - global_position).normilized();
		
		# Apply horizontal movement (preserve vertical velocity for gravity)
		velocity.x = direction.x * movement_speed
		velocity.y = direction.z * movement_speed
	
	move_and_slide()
