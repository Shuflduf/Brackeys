class_name Box
extends CharacterBody3D

@onready var area: Area3D = $Area3D

var player: Player = null

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if player == null:
		velocity.x = 0

	move_and_slide()



	if area.has_overlapping_bodies():
		var body = area.get_overlapping_bodies()[0]
		if body is Player:
			player = body
			body.active_box = self
	else:
		if player != null:
			player.active_box = null
			player = null
