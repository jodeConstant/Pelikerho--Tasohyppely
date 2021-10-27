extends Area2D

export var nopeus: float = 200
export var kohde_ryhma: String = "tuhoutuvat"

onready var _animoitu_kuva = $AnimatedSprite

func _process(delta):
	move_local_x(nopeus * delta)

func _on_EnergiaPallo_body_entered(body):
	nopeus = 0
	_animoitu_kuva.play("törmäys")
	# KinematicBody2D ja StaticBody2D on
	# johdettu CollisionObject2D:stä
	if body is CollisionObject2D:
		if body.is_in_group(kohde_ryhma):
			body.queue_free()

# Poistetaan kun räjähdys-animaatio on loppunut
func _on_AnimatedSprite_animation_finished():
	queue_free()
