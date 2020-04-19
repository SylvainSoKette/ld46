extends KinematicBody2D
class_name Animal

export var MOVE_SPEED = 20
export var RUN_FACTOR = 3
export var REACTIVITY_DELAY = 0.5

var hero = false

var current_direction = Vector2.LEFT
var current_speed = 0

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
	return 'Animal'

func _ready():
	randomize()

func _process(dt):
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
	else:
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
	debug_label.text = "eat"
	
func choose_action():
	var food = is_food_at_range()
	var enemy = is_enemy_at_range()
	
	# 'AI' -> if galore
	if stats.hp < stats.MAX_HP:
		if food:
			eat(food)
		elif is_food_front():
			move()
		elif is_food_back():
			turn()
	else:
		if enemy:
			attack(enemy)
		elif is_enemy_front():
			move()
		elif is_enemy_back():
			turn()
		else:
			if food:
				eat(food)
			else:
				var rand = randi()
				rand = rand % 3
				match rand:
					0: turn()
					1: move()
					2: turn()
					3: run()

###########################
# UTILS ###################
###########################
func is_food_front():
	for body in front_detector.get_overlapping_bodies():
		if body.get_class() == 'Projectile':
			return true
	return false
	
func is_food_back():
	for body in back_detector.get_overlapping_bodies():
		if body.get_class() == 'Projectile':
			return true
	return false

func is_food_at_range():
	for body in hurtbox.get_overlapping_bodies():
		if body.get_class() == 'Projectile':
			return body
	return false

func is_enemy_front():
	for body in front_detector.get_overlapping_bodies():
		if body.get_instance_id() == self.get_instance_id():
			print("is myself lol")
			continue
		if body.get_class() == 'Animal':
			return true
	return false
	
func is_enemy_back():
	for body in back_detector.get_overlapping_bodies():
		if body.get_instance_id() == self.get_instance_id():
			print("is myself lol")
			continue
		if body.get_class() == 'Animal':
			return true
	return false

func is_enemy_at_range():
	for area in hurtbox.get_overlapping_areas():
		if area.get_node("../..").get_instance_id() == self.get_instance_id():
			continue
		if area.name == 'Hitbox':
			return area
	return false

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
	queue_free()
