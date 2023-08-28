extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D


func _process(delta):
	#Testing movement/input
	if Input.is_action_pressed("move_right"):
		animated_sprite.play("run")
