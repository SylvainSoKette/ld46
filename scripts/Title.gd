extends Control

var current_char = 0
var characters = [
	"racoon",
	"seagull",
	"cat",
	"rat" 
]

onready var character_portrait = $Menu/Body/Character/Portrait

func _ready():
	update_character_portrait()

func _process(dt):
	if Input.is_action_just_released("ui_cancel"):
		get_tree().quit()

func update_character_portrait():
	current_char = current_char % len(characters)
	character_portrait.get_node("DebugName").text = characters[current_char]

func _on_Previous_pressed():
	current_char -= 1
	update_character_portrait()

func _on_Next_pressed():
	current_char += 1
	update_character_portrait()

func _on_Start_pressed():
	get_tree().change_scene("res://scenes/Game.tscn")

func _on_Story_pressed():
	get_tree().change_scene("res://scenes/Story.tscn")

func _on_Quit_pressed():
	get_tree().quit()
