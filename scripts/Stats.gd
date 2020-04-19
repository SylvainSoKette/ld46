extends Node

signal dead

export var MAX_HP = 5
#export var MAX_HUNGER = 10

var hp
#var hunger

onready var hp_bar = $HpBar
#onready var hunger_bar = $HungerBar

func _ready():
	hp = MAX_HP
#	hunger = MAX_HUNGER

func _process(delta):
	hp_bar.rect_scale.x = float(hp) / MAX_HP
#	hunger_bar.rect_scale.x = float(hunger) / MAX_HUNGER
	if hp <= 0:
		emit_signal("dead")

func take_damage(amount):
	hp -= amount
	hp = int(clamp(hp, 0, MAX_HP))
