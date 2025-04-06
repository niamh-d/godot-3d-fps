extends Area3D

@export var ammo_type: AmmoHandler.ammo_type = AmmoHandler.ammo_type.BULLET
@export var amount := 20


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		SignalManager.ammo_collected.emit(ammo_type, amount)
		print("pickup!")
		queue_free()
