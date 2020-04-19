extends Control

const win_text = "Consecutive win: "

onready var win_label = $VBoxContainer/WinLabel
onready var character_portrait = $VBoxContainer/Portrait

func _ready():
	update_win_count_label()
	update_character_portrait()

func _process(dt):
	if Input.is_action_just_released("ui_cancel"):
		get_tree().change_scene("res://scenes/Title.tscn")

func update_character_portrait():
	Globals.current_char = Globals.current_char % len(Globals.characters)
	character_portrait.texture.region = Rect2(Globals.current_char * 32, 0, 32, 32)

func update_win_count_label():
	win_label.text = win_text + str(Globals.win_count)

func _on_Back_pressed():
	get_tree().change_scene("res://scenes/Title.tscn")
