extends Area2D

@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	pass

func _on_body_entered(body):
	animate()

func animate():
	animated_sprite.play("finish")


