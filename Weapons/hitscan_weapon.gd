class_name HitScanWeapon
extends Node3D

@export var fire_rate := 14.0
@export var recoil := 0.05
@export var weapon_mesh: Node3D
@export var weapon_damage := 15
@export var muffle_flash: GPUParticles3D
@export var sparks: PackedScene
@export var is_automatic: bool

@onready var cooldown_timer: Timer = $CooldownTimer
@onready var weapon_pos: Vector3 = weapon_mesh.position
@onready var ray_cast: RayCast3D = $RayCast3D

func _process(delta: float) -> void:
	if is_automatic:
		if Input.is_action_pressed("fire"):
			if cooldown_timer.is_stopped():
				shoot()
	else:
		if Input.is_action_just_pressed("fire"):
			if cooldown_timer.is_stopped():
				shoot()
	
	weapon_mesh.position = weapon_mesh.position.lerp(weapon_pos, delta * 10.0)

func shoot() -> void:
	muffle_flash.restart()
	cooldown_timer.start(1.0 / fire_rate)
	var collider = ray_cast.get_collider()
	printt("weapon fired!", collider)
	weapon_mesh.position.z += recoil
	if collider is Enemy:
		collider.hitpoints -= weapon_damage
	var spark: GPUParticles3D = sparks.instantiate()
	add_child(spark)
	spark.global_position = ray_cast.get_collision_point()
	
