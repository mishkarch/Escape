extends Spatial

var camrot_h = 0
var camrot_v = 0
var cam_v_max = 65
var cam_v_min = -45
var h_sensitivity = 0.1
var v_sensitivity = 0.1
var h_acceleration = 100
var v_acceleration = 100

func _ready():
	$Hor/Vert/ClippedCamera.add_exception(get_parent())


func _input(event):
	if event is InputEventMouseMotion:
		camrot_h += -event.relative.x * (h_sensitivity)
		camrot_v += -event.relative.y * (v_sensitivity)

func _physics_process(delta):
	camrot_v = clamp(camrot_v, cam_v_min, cam_v_max)
	$Hor.rotation_degrees.y = lerp($Hor.rotation_degrees.y, camrot_h, delta * h_acceleration)
	$Hor/Vert.rotation_degrees.x = lerp($Hor/Vert.rotation_degrees.x, camrot_v, delta * v_acceleration)
