extends KinematicBody2D

export var MOVE_SPEED = 20
export var RUN_FACTOR = 3

enum STATE {
	IDLE,
	MOVE_LEFT,
	MOVE_RIGHT,
	EAT,
	ATTACK,
	FLEE_LEFT,
	FLEE_RIGHT
}

var current_state = STATE.MOVE_LEFT
var current_direction = Vector2.LEFT

onready var timer = $Timer
onready var hitbox_pivot = $HitboxPivot
onready var debug_label = $DebugLabel
onready var stats = $Stats


###########################
# ENGINE ##################
###########################
func _ready():
	randomize()

func _process(dt):
	call({
		STATE.IDLE: "process_idle",
		STATE.MOVE_LEFT: "process_move_left",
		STATE.MOVE_RIGHT: "process_move_right",
		STATE.EAT: "process_eat",
		STATE.ATTACK: "process_attack",
		STATE.FLEE_LEFT: "process_flee_left",
		STATE.FLEE_RIGHT: "process_flee_right",
	}[current_state], dt)


###########################
# STATES ##################
###########################
func setup_idle():
	debug_label.text = "idle"

func process_idle(dt):
	pass

func setup_move_left():
	debug_label.text = "move_left"
	current_direction = Vector2.LEFT
	hitbox_pivot.rotation_degrees = 180

func process_move_left(dt):
	move(dt)
	
func setup_move_right():
	debug_label.text = "move_right"
	current_direction = Vector2.RIGHT
	hitbox_pivot.rotation_degrees = 0

func process_move_right(dt):
	move(dt)

func setup_eat():
	debug_label.text = "eat"

func process_eat(dt):
	pass

func setup_attack():
	debug_label.text = "attack"
	for area in get_node("HitboxPivot/Hurtbox").get_overlapping_areas():
		if area.name == 'Hitbox':
			area.emit_signal('hit')
			return # stop at first enemy hit

func process_attack(dt):
	pass

func setup_flee_left():
	debug_label.text = "flee_left"
	current_direction = Vector2.LEFT
	hitbox_pivot.rotation_degrees = 180

func process_flee_left(dt):
	move(dt, true)

func setup_flee_right():
	debug_label.text = "flee_right"
	current_direction = Vector2.RIGHT
	hitbox_pivot.rotation_degrees = 0

func process_flee_right(dt):
	move(dt, true)

func choose_state():
	var states = [
		STATE.IDLE,
		STATE.ATTACK, STATE.EAT,
		STATE.FLEE_LEFT, STATE.FLEE_RIGHT,
		STATE.MOVE_LEFT, STATE.MOVE_RIGHT
	]
	current_state = get_random_from_array(states)
	call({
		STATE.IDLE: "setup_idle",
		STATE.MOVE_LEFT: "setup_move_left",
		STATE.MOVE_RIGHT: "setup_move_right",
		STATE.EAT: "setup_eat",
		STATE.ATTACK: "setup_attack",
		STATE.FLEE_LEFT: "setup_flee_left",
		STATE.FLEE_RIGHT: "setup_flee_right",
	}[current_state])

func move(dt, run=false):
	if run:
		move_and_collide(current_direction  * MOVE_SPEED * RUN_FACTOR * dt)
	else:
		move_and_collide(current_direction  * MOVE_SPEED * dt)

###########################
# UTILS ###################
###########################
func get_random_from_array(array):
	return array[int(rand_range(0, array.size() - 1))]


###########################
# CALLBACKS ###############
###########################
func _on_Timer_timeout():
	var time_list = [0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]
	timer.set_wait_time(get_random_from_array(time_list))
	choose_state()

func _on_Hitbox_hit():
	stats.take_damage(1)

func _on_Stats_dead():
	queue_free()
