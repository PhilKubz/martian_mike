extends Node2D

@export var next_level: PackedScene = null
@export var is_final_level: bool = false
@export var level_time = 60

@onready var start = $Start
@onready var exit = $Exit
@onready var death_zone = $Deathzone
@onready var hud = $UILayer/HUD
@onready var ui_layer = $UILayer

var player = null
var timer_node = null
var time_left
var win = false

func _ready():
	player = get_tree().get_first_node_in_group("player")
	player.global_position = start.get_spawn_pos()
	
	time_left = level_time
	hud.set_time_label(time_left)
	
	timer_node = Timer.new()
	timer_node.name = "Level Timer"
	timer_node.wait_time = 1
	timer_node.timeout.connect(_on_level_timer_timeout)
	add_child(timer_node)
	timer_node.start()
	
	exit.body_entered.connect(_on_exit_body_entered)
	death_zone.body_entered.connect(_on_deathzone_body_entered)
	
	var traps = get_tree().get_nodes_in_group("traps")
	for trap in traps:
		trap.touched_player.connect(_on_trap_touched_player)
	
#	var array = [1, 2, 3, "hello", 2.3, true]
#	array[0] = "first"
#	array.append("new")
#	array.remove_at(1)
#	array.erase("hello")
#	print(array)
#	print("arrayArray Size: " + str(array.size()))

func _on_level_timer_timeout():
	if win == false:
		time_left -= 1
		hud.set_time_label(time_left)
		if time_left < 0:
			AudioPlayer.play_sfx("hurt")
			player_position_reset()
			time_left = level_time
			hud.set_time_label(time_left)

func _process(delta):
	if Input.is_action_pressed("quit"):
		get_tree().quit()
		
	elif Input.is_action_pressed("reset"):
		get_tree().reload_current_scene()



func _on_deathzone_body_entered(body):
	player_position_reset()
	AudioPlayer.play_sfx("hurt")
#	print("Hurt is playing at the start of the scene from here")
	


func _on_trap_touched_player():
	AudioPlayer.play_sfx("hurt")
	player_position_reset()

func player_position_reset():
	player.velocity = Vector2.ZERO
	player.global_position = start.get_spawn_pos()

func _on_exit_body_entered(body):
	if body is Player:
		if is_final_level || (next_level != null):
			exit.animate()
			player.active = false
			win = true
			await get_tree().create_timer(1.5).timeout
			if is_final_level:
				ui_layer.show_win_screen(true)
			else:
				get_tree().change_scene_to_packed(next_level)

