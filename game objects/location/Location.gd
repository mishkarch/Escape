extends Spatial

onready var player = $Player

func _ready():
	for pl in get_tree().get_nodes_in_group("PLATFORMS"):
		player.platforms.append(pl)

func _process(delta):
	if Input.is_action_just_pressed("FULLSCREEN"):
		OS.window_fullscreen = !OS.window_fullscreen
