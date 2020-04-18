extends Node2D

onready var animation = $AnimationPlayer

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "throw":
		animation.play("idle")
