class_name AmmoHandler
extends Node

@onready var ammo_label: Label = %AmmoLabel
@onready var weapon_handler: Node3D = %WeaponHandler

enum ammo_type {
	BULLET,
	SMALL_BULLET
}

var ammo_storage := {
	ammo_type.BULLET: 10,
	ammo_type.SMALL_BULLET: 60
}

func _ready() -> void:
	SignalManager.weapon_updated.connect(on_weapon_updated)
	SignalManager.ammo_collected.connect(on_ammo_collected)
	update_ammo_label()

func has_ammo(type: ammo_type) -> bool:
	return get_num_bullets(type) > 0
	
func use_ammo(type: ammo_type) -> void:
	if has_ammo(type):
		update_ammo(type, -1)
		set_ammo_label(get_num_bullets(type))

func update_ammo_label() -> void:
	set_ammo_label(
		get_num_bullets(weapon_handler.get_current_bullet_type())
		)
	
func get_num_bullets(type: ammo_type) -> int:
	return ammo_storage[type]

func set_ammo_label(val: int) -> void:
	ammo_label.text = str(val)

func on_weapon_updated() -> void:
	update_ammo_label()

func update_ammo(type: AmmoHandler.ammo_type, val: int) -> void:
	ammo_storage[type] += val

func on_ammo_collected(type: AmmoHandler.ammo_type, val: int) -> void:
	update_ammo(type, val)
	if type == weapon_handler.get_current_bullet_type():	
		set_ammo_label(get_num_bullets(type))
