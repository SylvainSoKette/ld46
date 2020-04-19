extends Node

var win_count = 0
var current_char = 0
var characters = [
	"racoon",
	"seagull",
	"rat",
	"cat"
]
var characters_t = {
	0: preload("res://scenes/entities/animals/Racoon.tscn"),
	1: preload("res://scenes/entities/animals/Seagull.tscn"),
	2: preload("res://scenes/entities/animals/Rat.tscn"),
	3: preload("res://scenes/entities/animals/Cat.tscn")
}

var outline_mat = preload("res://materials/OutlineMaterial.tres")
