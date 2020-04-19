extends Node

var win_count = 0
var current_char = 0
var characters = [
	"racoon",
	"seagull",
	"cat",
	"rat" 
]
var characters_t = {
	0: preload("res://scenes/entities/animals/Racoon.tscn"),
	1: preload("res://scenes/entities/animals/Seagull.tscn"),
	2: preload("res://scenes/entities/animals/Cat.tscn"),
	3: preload("res://scenes/entities/animals/Rat.tscn")
}

var outline_mat = preload("res://materials/OutlineMaterial.tres")

func _ready():
	pass
