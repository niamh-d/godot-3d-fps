extends Node3D

@export var fire_rate := 14.0
@export var recoil := 0.05
@export var weapon_mesh: Node3D
@export var weapon_damage := 15

@onready var cooldown_timer: Timer = $CooldownTimer
@onready var weapon_pos: Vector3 = weapon_mesh.position
@onready var ray_cast: RayCast3D = $RayCast3D

func _process(delta: float) -> void:
	if Input.is_action_pressed("fire"):
		if cooldown_timer.is_stopped():
			shoot()
	
	weapon_mesh.position = weapon_mesh.position.lerp(weapon_pos, delta * 10.0)

func shoot() -> void:
			cooldown_timer.start(1.0 / fire_rate)
			var collider = ray_cast.get_collider()
			printt("weapon fired!", collider)
			weapon_mesh.position.z += recoil
			if collider is Enemy:
				collider.hitpoints -= weapon_damage
	
