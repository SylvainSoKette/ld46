extends RigidBody2D
class_name Projectile

onready var sprite = $Sprite
onready var animation = $AnimationPlayer

func get_class():
	return "Projectile"

func _ready():
	var rand = randi() % 4
	sprite.set_frame(rand)

func _process(dt):
	var niceness = 8
	var viewport = get_viewport().size
	if (position.x < -niceness or
		position.x > viewport.x + niceness or
		position.y > viewport.y + niceness
	):
		queue_free()

func get_eaten():
	animation.play("fade_out")

func _on_Timer_timeout():
	animation.play("fade_out")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade_out":
		queue_free()
