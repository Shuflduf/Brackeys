class_name Player
extends CharacterBody3D

@onready var camera: Camera3D = $Camera3D

@export var speed = 5.0
@export var moving_prop_speed = 2.0
@export var jump_velocity = 4.5

@export var two_d_position = Vector3(0, 0, 7)
@export var top_down_position = Vector3(0, 4, 5)

var is_topdown = false
var switching = false

var active_box: Box = null

func _ready() -> void:
	var animation: Animation = $AnimationPlayer.get_animation("switch_perspective")
	animation.track_set_key_value(0, 0, two_d_position)
	animation.track_set_key_value(0, 1, top_down_position)

	camera.position = two_d_position

func _process(_delta: float) -> void:
	if switching:
		camera.look_at(position)


func _physics_process(delta: float) -> void:
	if switching:
		return

	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	velocity.x = Input.get_axis("left", "right") * get_speed()
	if active_box != null:
		active_box.velocity.x = velocity.x
	if is_topdown:
		velocity.z = Input.get_axis("up", "down") * get_speed()

	move_and_slide()

func get_speed() -> float:
	return speed if active_box == null else moving_prop_speed

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("switch"):

		if switching:
			return

		switching = true

		if is_topdown:
			$AnimationPlayer.play_backwards(&"switch_perspective")
			is_topdown = false

		else:
			camera.global_position.z = two_d_position.z
			$AnimationPlayer.play(&"switch_perspective")
			is_topdown = true

		await $AnimationPlayer.animation_finished

		if not is_topdown:
			camera.global_position.z = 100


		switching = false
