extends RigidBody2D

onready var animation = $AnimationPlayer

func _process(dt):
	var niceness = 8
	var viewport = get_viewport().size
	if (position.x < -niceness or
		position.x > viewport.x + niceness or
		position.y > viewport.y + niceness
	):
		queue_free()

func _on_Timer_timeout():
	animation.play("fade_out")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade_out":
		queue_free()
