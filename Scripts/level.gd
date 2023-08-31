extends Node2D

@onready var start_position = $StartPosition
@onready var player = $Player

func _ready():
	var traps = get_tree().get_nodes_in_group("traps")
	for trap in traps:
		trap.touched_player.connect(_on_trap_touched_player)
	
#		trap.touched_player.connect(_on_trap_touched_player)
		
#	var array = [1, 2, 3, "hello", 2.3, true]
#	array[0] = "first"
#	array.append("new")
#	array.remove_at(1)
#	array.erase("hello")
#	print(array)
#	print("arrayArray Size: " + str(array.size()))


func _process(delta):
	if Input.is_action_pressed("quit"):
		get_tree().quit()
		
	elif Input.is_action_pressed("reset"):
		get_tree().reload_current_scene()




func _on_deathzone_body_entered(body):
	player_position_reset()


func _on_trap_touched_player():
	player_position_reset()

func player_position_reset():
	player.velocity = Vector2.ZERO
	player.global_position = start_position.global_position
