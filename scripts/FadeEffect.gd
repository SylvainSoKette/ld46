extends ColorRect

signal can_start

onready var animation = $AnimationPlayer

func _ready():
	visible = true
	animation.play("fade_in")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade_in":
		visible = false
		emit_signal("can_start")
