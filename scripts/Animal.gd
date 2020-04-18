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

func process_idle(dt):
	debug_label.text = "idle"

func process_move_left(dt):
	debug_label.text = "move_left"
	current_direction = Vector2.LEFT
	hitbox_pivot.rotation_degrees = 180
	move(dt)
func process_move_right(dt):
	debug_label.text = "move_right"
	current_direction = Vector2.RIGHT
	hitbox_pivot.rotation_degrees = 0
	move(dt)

func process_eat(dt):
	debug_label.text = "eat"

func process_attack(dt):
	debug_label.text = "attack"

func process_flee_left(dt):
	debug_label.text = "flee_left"
	current_direction = Vector2.LEFT
	hitbox_pivot.rotation_degrees = 180
	move(dt, true)

func process_flee_right(dt):
	debug_label.text = "flee_right"
	current_direction = Vector2.RIGHT
	hitbox_pivot.rotation_degrees = 0
	move(dt, true)

func choose_state():
	var states = [
		STATE.IDLE,
		STATE.ATTACK, STATE.EAT,
		STATE.FLEE_LEFT, STATE.FLEE_RIGHT,
		STATE.MOVE_LEFT, STATE.MOVE_RIGHT
	]
	current_state = get_random_from_array(states)

func move(dt, run=false):
	if run:
		move_and_collide(current_direction  * MOVE_SPEED * RUN_FACTOR * dt)
	else:
		move_and_collide(current_direction  * MOVE_SPEED * dt)

# UTILS
func get_random_from_array(array):
	return array[int(rand_range(0, array.size() - 1))]

# CALLBACKS
func _on_Timer_timeout():
	var time_list = [0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]
	timer.set_wait_time(get_random_from_array(time_list))
	choose_state()

func _on_Hurtbox_area_entered(area):
	print("got hit captain !")
	queue_free()
