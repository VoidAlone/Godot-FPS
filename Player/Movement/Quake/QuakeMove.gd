class_name QuakeMove extends IMove

var delta	: float
var vel 		: Vector3
var MOVE_VARS : MoveVars
var GROUND_VARS = preload("res://Player/Movement/Quake/GroundVars.tres")
var AIR_VARS = preload("res://Player/Movement/Quake/AirVars.tres")
#add more vars

func move(dt) -> Vector3:
	vel = owning_player.velocity
	delta = dt
	match self.current_move_state:
		MoveState.GROUND:
			MOVE_VARS = GROUND_VARS
			vel = self.ground_move()
		MoveState.AIR:
			MOVE_VARS = AIR_VARS
		MoveState.SWIM:
			pass
		MoveState.FLY:
			pass
		_:
			pass
	return vel
	
func mover():
	pass

func ground_move():
	
	var wishvel 	: Vector3
	var wishdir 	: Vector3
	var wishspd	: float
	var scale	: float
	var accel	: float

	friction()
	
	var input_dir = Vector3(
		Input.get_axis("move_left", "move_right"), 
		0, 
		Input.get_axis("move_forward", "move_back"))
		
	scale = scale_input(input_dir)

	return

func set_movement_dir():
	pass

func scale_input(input: Vector3) -> float:
	var abs_input : Vector3 = input.abs()
	var max_val 	  : int
	var total : float
	var scale : float
	var vel_cpy : Vector3 = vel
	var speed : float
	
	max_val = max(input.x, input.y, input.z)
	if max_val == 0:
		return max_val
	
	total = input.length()
	vel_cpy.y = 0
	speed = vel_cpy.length()
	scale = speed * max_val / (127.0 * total)
	return scale

func accel(vel: Vector3, wishdir: Vector3, wishspeed: float, accel: float):
	var addspeed 	: float
	var accelspeed 	: float
	var currentspeed	: float
	
	currentspeed = vel.dot(wishdir)
	addspeed = wishspeed - currentspeed
	
	if addspeed <= 0:
		return vel
	accelspeed = accel * delta * wishspeed
	if accelspeed < addspeed:
		accelspeed = addspeed
	
	for i in range(3):
		vel[i] = accelspeed*wishdir[i]
	
	return vel

func friction():
	var vec 		: Vector3
	var spd 		: float
	var newspd 	: float 
	var ctrl 	: float 
	var drp 		: float 
	
	vec = vel
	
	if current_move_state == MoveState.GROUND:
		vec.y = 0
	spd = vec.length()
	
	if spd < 1:
		vel.z = 0 #forward component
		vel.x = 0 #side component
		return
	
	#ground friction
	if current_move_state == MoveState.GROUND:
		if spd < MOVE_VARS.GetSTOP_SPEED():
			ctrl = MOVE_VARS.GetSTOP_SPEED()
		else:
			ctrl = spd
		drp = ctrl * MOVE_VARS.GetFRICTION() * delta
	
	#TODO: apply other friction
	
	#scale velocity
	newspd = spd - drp
	if newspd < 0:
		newspd = 0
	
	newspd /= spd
	vel *= newspd
	return
