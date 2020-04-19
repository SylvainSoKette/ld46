extends Node

export var MAX_THROW_POWER = 250
export var THROW_INCREASE_STEP = 500
export var ENEMY_COUNT = 3

var started = false
var throw_power = 0
var throw_from = Vector2.ZERO
var throw_direction = Vector2.ZERO
var spawn_locations = [
		Vector2(-120, 0),
		Vector2(-80, 0),
		Vector2(-40, 0),
		Vector2(0, 0),
		Vector2(40, 0),
		Vector2(80, 0),
		Vector2(120, 0),
	]

var musics = [
	preload("res://musics/main1.ogg"),
	preload("res://musics/main2.ogg"),
	preload("res://musics/main3.ogg"),
	preload("res://musics/main4.ogg")
]

onready var music = $AudioStreamPlayer
onready var projectiles = $Scene/Projectiles
onready var animals = $Scene/Animals
onready var player = $Scene/Player
onready var player_anim = $Scene/Player/AnimationPlayer
onready var player_hand = $Scene/Player/Hand
onready var player_hand_arrow = $Scene/Player/Hand/Arrow
onready var projectile = preload("res://scenes/entities/projectiles/Projectile.tscn")

func _ready():
	randomize()
	player_hand_arrow.visible = false
	music.stream = get_random_from_array(musics)
	music.play(0.0)
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
	elif Input.is_action_just_released("left_click") or Input.is_action_just_released("right_click"):
		throw_item()

	# lose condition
	var lost = true
	for animal in animals.get_children():
		if animal.hero:
			lost = false
	if lost:
		Globals.win_count = 0
		get_tree().change_scene("res://scenes/Lose.tscn")
		return

	# win condition
	if animals.get_child_count() <= 1:
		Globals.win_count += 1
		get_tree().change_scene("res://scenes/Win.tscn")

func throw_item():
	var p = projectile.instance()
	print(p)
	p.position = throw_from
	p.angular_velocity = -randf() * 50
	p.linear_velocity = throw_direction * throw_power
	projectiles.add_child(p)
	# reset stuff
	throw_power = 0
	player_hand_arrow.visible = false
	player_anim.play("throw")

func setup_game():
	print(Globals.current_char)
	var hero_type = Globals.characters_t[Globals.current_char]
	var hero = hero_type.instance()
	hero.position = get_random_from_array(spawn_locations, true)
	hero.set_hero()
	animals.add_child(hero)

	for i in range(ENEMY_COUNT):
		var rand = randi() % Globals.characters_t.size()
		var enemy_type = Globals.characters_t[rand]
		var enemy = enemy_type.instance()
		enemy.position = get_random_from_array(spawn_locations, true)
		animals.add_child(enemy)

func get_random_from_array(array, remove=false):
	if remove:
		var index = randi() % len(array)
		var value = array[index]
		array.remove(index)
		return value
	else:
		return array[randi() % len(array)]

func _on_AudioStreamPlayer_finished():
	music.stream = get_random_from_array(musics)
	music.play(0.0)
