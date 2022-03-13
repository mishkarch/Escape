extends KinematicBody

const GRAVITY = 10

export var RUN_SPEED = 6
export var JUMP_SPEED = 6

var velocity: Vector3
var move_direction = Vector3()

var speed = RUN_SPEED
const ACCEL = 3
const DEACCEL = 5

var platforms = []

func _physics_process(delta):
	process_input(delta)
	process_movement(delta)
	if translation.y < -5:
		climbing()


func process_movement(delta: float):
	move_direction.y = 0
	move_direction = move_direction.normalized()

	velocity.y -= delta * GRAVITY
	var horiz_velocity = velocity
	var target_velocity = move_direction * speed
	var accel = ACCEL if move_direction.dot(horiz_velocity) > 0 else DEACCEL

	horiz_velocity = lerp(horiz_velocity, target_velocity, accel * delta)
	velocity.x = horiz_velocity.x
	velocity.z = horiz_velocity.z
	velocity = move_and_slide(velocity, Vector3(0,1,0))


func process_input(delta: float):
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if OS.window_fullscreen else Input.MOUSE_MODE_VISIBLE)
	
	var input_movement_vector = Vector2()
	input_movement_vector.x = Input.get_action_strength("MOVE_RIGHT") - Input.get_action_strength("MOVE_LEFT")
	input_movement_vector.y = Input.get_action_strength("MOVE_BACKWARD") - Input.get_action_strength("MOVE_FORWARD")
	input_movement_vector = input_movement_vector.normalized()

	move_direction = Vector3.ZERO
	move_direction += transform.basis.z * input_movement_vector.y
	move_direction += transform.basis.x * input_movement_vector.x
	var hor_rotation = $CameraRoot/Hor.rotation.y
	move_direction = move_direction.rotated(Vector3.UP, hor_rotation)
	
	if is_on_floor():
		if Input.is_action_just_pressed("JUMP"):
			velocity.y = JUMP_SPEED

func climbing():
# взбирание на ближайшую из кувшинок нижнего уровня в случае падения в воду
	var platform = platforms[0]
	for pl in platforms:
		if (translation - pl.translation).length_squared() < (translation - platform.translation).length_squared():
			platform = pl
	translation = platform.translation + Vector3.UP

