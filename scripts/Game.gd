extends Node

export var MAX_THROW_POWER = 250
export var THROW_INCREASE_STEP = 500

var started = false
var throw_power = 0
var throw_from = Vector2.ZERO
var throw_direction = Vector2.ZERO

onready var projectiles = $Scene/Projectiles
onready var player = $Scene/Player
onready var player_anim = $Scene/Player/AnimationPlayer
onready var player_hand = $Scene/Player/Hand
onready var player_hand_arrow = $Scene/Player/Hand/Arrow
onready var projectile = load("res://entities/projectiles/Projectile.tscn")

func _ready():
	randomize()
	player_hand_arrow.visible = false
	setup_game()

func _on_FadeEffect_can_start():
	started = true

func _process(dt):
	if not started:
		return

	if Input.is_action_just_released("ui_cancel"):
		get_tree().change_scene("res://scenes/Title.tscn")

	if Input.is_action_pressed("left_click") or Input.is_action_pressed("right_click"):
		# prepare throw calculation
		throw_from = player_hand.global_position
		throw_direction = (get_viewport().get_mouse_position() - throw_from).normalized()
		throw_power += THROW_INCREASE_STEP * dt
		throw_power = min(throw_power, MAX_THROW_POWER)
		# handle helper arrow
		player_hand_arrow.visible = true
		player_hand_arrow.modulate = Color(1.0, 0.0, 1.0, lerp(0, 1.0, throw_power / MAX_THROW_POWER))
		player_hand.set_rotation_degrees(rad2deg(Vector2.RIGHT.angle_to(throw_direction)))
	elif Input.is_action_just_released("left_click"):
		throw_item()
	elif Input.is_action_just_released("right_click"):
		throw_item()

func throw_item():
	var p = projectile.instance()
	print(player_hand.position)
	p.position = throw_from
	p.angular_velocity = randf() * 25
	p.linear_velocity = throw_direction * throw_power
	projectiles.add_child(p)
	# reset stuff
	throw_power = 0
	player_hand_arrow.visible = false
	player_anim.play("throw")

func setup_game():
	pass
