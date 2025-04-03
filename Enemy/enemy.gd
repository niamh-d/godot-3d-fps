extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var attack_range := 1.5

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

var player: CharacterBody3D
var provoked := false
var aggro_range := 12.0 
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _process(_delta: float) -> void:
	if provoked:
		navigation_agent.target_position = player.global_position
	
func _physics_process(delta: float) -> void:
	var next_pos = navigation_agent.get_next_path_position()
	
	if not is_on_floor():
		velocity.y -= gravity * delta

	var direction = global_position.direction_to(next_pos)
	var distance = global_position.distance_to(player.global_position)
	
	provoked = distance <= aggro_range
	
	if provoked && distance <= attack_range:
		anim_player.play("attack")
	
	if direction:
		look_at_target(direction)
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
func look_at_target(dir: Vector3) -> void:
	var adjusted_dir = dir
	adjusted_dir.y = 0
	look_at(global_position + adjusted_dir, Vector3.UP, true)
	
func attack() -> void:
	print("enemy attack!")
