extends Node3D

@export var weapon_1: HitScanWeapon
@export var weapon_2: HitScanWeapon

func _ready() -> void:
	equip(weapon_1)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("weapon_1"):
		equip(weapon_1)
	elif event.is_action_pressed("weapon_2"):
		equip(weapon_2)
	elif event.is_action_pressed("next_weapon"):
		next_weapon()
	elif event.is_action_pressed("last_weapon"):
		previous_weapon()

func equip(active_weapon: HitScanWeapon) -> void:
	for child in get_children():
		if child == active_weapon:
			child.visible = true
			child.set_process(true)
		else:
			child.visible = false
			child.set_process(false)

func next_weapon() -> void:
	equip_by_index(1)

func previous_weapon() -> void:
	equip_by_index(-1)
	
func equip_by_index(index_modifier) -> void:
	var index = get_current_index()
	index = wrapi(index + index_modifier, 0, get_child_count())
	equip(get_child(index))

func get_current_index() -> int:
	for index in get_child_count():
		if get_child(index).visible:
			return index
	return 0
