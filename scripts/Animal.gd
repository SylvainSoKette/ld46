extends KinematicBody2D
class_name Animal

signal game_lost

export var MOVE_SPEED = 20
export var RUN_FACTOR = 3
export var REACTIVITY_DELAY = 0.5

var hero = false

var current_direction = Vector2.RIGHT
var current_speed = 0

onready var sprite = $Sprite
onready var timer = $Timer
onready var hitbox_pivot = $HitboxPivot
onready var debug_label = $DebugLabel
onready var stats = $Stats
onready var hurtbox = $HitboxPivot/Hurtbox
onready var front_detector = $HitboxPivot/Frontdetecter
onready var back_detector = $HitboxPivot/Backdetector


###########################
# ENGINE ##################
###########################
func get_class():
	return "Animal"

func _ready():
	randomize()
	$HeroIndicator.visible = false

func _process(dt):
	if hero:
		$HeroIndicator.visible = true
	
	move_and_collide(current_direction  * current_speed * dt)

###########################
# STATES ##################
###########################
func turn():
	debug_label.text = "turn"
	current_speed = 0
	if current_direction == Vector2.RIGHT:
		current_direction = Vector2.LEFT
		hitbox_pivot.rotation_degrees = 180
		sprite.flip_h = true
	else:
		sprite.flip_h = false
		current_direction = Vector2.RIGHT
		hitbox_pivot.rotation_degrees = 0

func move():
	debug_label.text = "move"
	current_speed = MOVE_SPEED

func run():
	debug_label.text = "run"
	current_speed = MOVE_SPEED * RUN_FACTOR

func attack(enemy_hitbox):
	current_speed = 0
	enemy_hitbox.emit_signal('hit')

func eat(food):
	current_speed = 0
	food.get_eaten()
	stats.take_damage(-1)
	debug_label.text = "eat"

func choose_action():
	var food = is_food_at_range()
	var enemy = is_enemy_at_range()
	
	# 'AI' -> if galore
	if stats.hp < stats.MAX_HP and food:
		eat(food)
	elif is_food_front():
		run()
	elif is_food_back():
		turn()
	else:
		if enemy:
			attack(enemy)
		elif is_enemy_front():
			run()
		elif is_enemy_back():
			turn()
		else:
			if food:
				eat(food)
			else:
				var rand = randi()
				rand = rand % 4
				match rand:
					0: turn()
					1: move()
					2: move()
					3: run()

###########################
# UTILS ###################
###########################
func is_food_front():
	for body in front_detector.get_overlapping_bodies():
		if body.get_class() == "Projectile":
			return true
	return false

func is_food_back():
	for body in back_detector.get_overlapping_bodies():
		if body.get_class() == "Projectile":
			return true
	return false

func is_food_at_range():
	for body in hurtbox.get_overlapping_bodies():
		if body.get_class() == "Projectile":
			return body
	return false

func is_enemy_front():
	for body in front_detector.get_overlapping_bodies():
		if body.get_instance_id() == get_instance_id():
			continue
		if body.get_class() == "Animal":
			return true
	return false

func is_enemy_back():
	for body in back_detector.get_overlapping_bodies():
		if body.get_instance_id() == get_instance_id():
			continue
		if body.get_class() == "Animal":
			return true
	return false

func is_enemy_at_range():
	for area in hurtbox.get_overlapping_areas():
		if area.get_node("../..").get_instance_id() == self.get_instance_id():
			continue
		if area.name == "Hitbox":
			return area
	return false

func set_hero():
	hero = true
	set_material(Globals.outline_mat) # I just don't understand why it both does not work as I except and does not crash either...

func get_random_from_array(array):
	return array[int(rand_range(0, array.size() - 1))]


###########################
# CALLBACKS ###############
###########################
func _on_Timer_timeout():
	var time_offset = [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8]
	timer.set_wait_time(REACTIVITY_DELAY + get_random_from_array(time_offset))
	choose_action()

func _on_Hitbox_hit():
	stats.take_damage(1)

func _on_Stats_dead():
	if hero:
		emit_signal("game_lost")
	queue_free()
