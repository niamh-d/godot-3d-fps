class_name Player
extends CharacterBody3D

@export var speed := 5.0
@export var jump_height := 1.0
@export var fall_multiplier: float = 2.5
@export var max_hitpoints := 100
@export var aim_multipler := 0.7

@onready var camera_pivot: Node3D = $CameraPivot
@onready var damage_animation_player: AnimationPlayer = $DamageTexture/DamageAnimationPlayer
@onready var game_over_menu: GameOverMenu = $GameOverMenu
@onready var smooth_camera: Camera3D = %SmoothCamera
@onready var smooth_camera_default_fov := smooth_camera.fov
@onready var weapon_camera: Camera3D = %WeaponCamera
@onready var weapon_camera_default_fov = weapon_camera.fov

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var mouse_motion := Vector2.ZERO
var mouse_sensitivity = 0.001

var hitpoints: int = max_hitpoints:
	set(val):
		if val < hitpoints:
			damage_animation_player.stop(false)
			damage_animation_player.play("take_damage")
		hitpoints = val
		if hitpoints <= 0:
			game_over_menu.game_over()

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta: float) -> void:
	if player_is_aiming():
		zoom_cameras(delta)
	else:
		reset_cameras(delta)

func _physics_process(delta: float) -> void:
	handle_camera_rotation()
	# Add the gravity.
	if not is_on_floor():
		if velocity.y >= 0:
			velocity.y -= gravity * delta
		else:
			velocity.y -= gravity * delta * fall_multiplier

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = sqrt(jump_height * 2.0 * gravity)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		if player_is_aiming():
			velocity.x *= aim_multipler
			velocity.z += aim_multipler
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	move_and_slide()
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion && Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		mouse_motion = -event.relative * mouse_sensitivity
		if player_is_aiming():
			mouse_motion *= aim_multipler
		
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func handle_camera_rotation() -> void:
	rotate_y(mouse_motion.x)
	camera_pivot.rotate_x(mouse_motion.y)
	camera_pivot.rotation_degrees.x = clampf(
		camera_pivot.rotation_degrees.x,
		-90.0,
		90.0
	)
	mouse_motion = Vector2.ZERO
	
func zoom_cameras(delta: float) -> void:
	zoom_camera(smooth_camera, smooth_camera_default_fov, delta)
	zoom_camera(weapon_camera, weapon_camera_default_fov, delta)

func reset_cameras(delta: float) -> void:
	reset_camera_fov(smooth_camera, smooth_camera_default_fov, delta)
	reset_camera_fov(weapon_camera, weapon_camera_default_fov, delta)

func zoom_camera(camera: Camera3D, default_fov: float, delta: float) -> void:
	camera.fov = lerp(
	default_fov, 
	default_fov * aim_multipler, 
	delta * 20.0
	)

func reset_camera_fov(camera: Camera3D, default_fov: float, delta: float) -> void:
	camera.fov = lerp(
	camera.fov, 
	default_fov, 
	delta * 30.0
	)

func player_is_aiming() -> bool:
	return Input.is_action_pressed("aim")
