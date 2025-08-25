class_name QuakeMove extends IMove

var delta			: float
var mover_velocity 	: Vector3
var mover_forward 	: Vector3
var mover_side		: Vector3

var MOVE_VARS 		: MoveVars
var GROUND_VARS 	: MoveVars = preload("res://Player/Movement/Quake/GroundVars.tres")
var AIR_VARS 		: MoveVars = preload("res://Player/Movement/Quake/AirVars.tres")
#add more vars

func Move(dt) -> Vector3:
	var	mover_basis 	= owning_player.transform.basis
	mover_velocity 	= owning_player.velocity
	delta 			= dt

	match self.current_move_state:
		MoveState.GROUND:
			MOVE_VARS = GROUND_VARS
			mover_velocity = self.Mover(mover_velocity, mover_basis)
		MoveState.AIR:
			MOVE_VARS = AIR_VARS
		MoveState.SWIM:
			pass
		MoveState.FLY:
			pass
		_:
			pass
	return mover_velocity


#init local vars
#defensively check current state for transition that was missed in outer logic
#friction calls
#get input, scale, project
#optionally clip velocity
#normalize vectors, and iteratively set wish velocity 
#set wishspeed
#check substates and clamp speeds
#accelerate
#clean up ground velocity
#stepslidemove (with gravity var passed?)

func Mover(velocity : Vector3, mover_basis : Basis):
	var wishdir 	: Vector3
	var wishspeed 	: float
	#defensively check current state for transition that was missed in outer logic
	#friction calls
	velocity = Friction(velocity)
	#get input, scale, project
	var input_dir = Vector3(
		Input.get_axis("move_left", "move_right"), 
		0, 
		Input.get_axis("move_forward", "move_back")
		)
	#project moves down to flat plane
	#optionally clip local velocity
	#normalize vectors, and set wish velocity 
	wishdir	= mover_basis * input_dir
	wishdir = wishdir.normalized()
	
	#set wishspeed
	wishspeed = wishdir.length()
	wishspeed *= MOVE_VARS.SPEED
	
	#check substates and clamp speeds (add a template method hook)

	#accelerate
	velocity = Accelerate(velocity, wishdir, wishspeed)
	#clean up ground velocity
	#stepslidemove (with gravity var passed?)
	return velocity

func SetMovementDir():
	pass

func ScaleInput(input: Vector3) -> float:
	# var abs_input 	: Vector3 = input.abs()
	var max_val		: int
	var total 		: float
	var scale 		: float
	var vel_cpy 	: Vector3 = mover_velocity
	var speed 		: float
	
	max_val = max(input.x, input.y, input.z)
	if max_val == 0:
		return max_val
	
	total = input.length()
	vel_cpy.y = 0
	speed = vel_cpy.length()
	scale = speed * max_val / (127.0 * total)
	return scale

func Accelerate(vel: Vector3, wishdir: Vector3, wishspeed: float):
	var addspeed 		: float
	var accelspeed 		: float
	var currentspeed	: float
	
	currentspeed 	= vel.dot(wishdir)
	addspeed 		= wishspeed - currentspeed

	if addspeed <= 0:
		return vel

	accelspeed = MOVE_VARS.ACCEL * delta * wishspeed
	if accelspeed < addspeed:
		accelspeed = addspeed

	vel += wishdir * accelspeed
	
	return vel

func ClipVelocity(basis_vector : Vector3, normal : Vector3, overbounce : float) -> Vector3:
	var clipped_velocity 	: Vector3
	var backoff 			: float = basis_vector.dot(normal)
	var change 				: float

	if backoff < 0:
		backoff *= overbounce
	else:
		backoff /= overbounce

	for i in range(3):
		change = normal[i]*backoff
		clipped_velocity[i] = basis_vector[i] - change
	
	return clipped_velocity



func Friction(velocity : Vector3) -> Vector3:
	var speed 		: float
	var new_speed 	: float 
	var control 	: float 
	var drop 		: float 

	#design to remove this conditional
	if current_move_state == MoveState.GROUND:
		velocity.y = 0

	speed = velocity.length()
	
	if speed < 1:
		mover_velocity.z = 0 #forward component
		mover_velocity.x = 0 #side component
		return velocity

	#remove conditionals for states
	#ground friction
	if current_move_state == MoveState.GROUND:
		if speed < MOVE_VARS.GetSTOP_SPEED():
			control = MOVE_VARS.GetSTOP_SPEED()
		else:
			control = speed
		drop = control * MOVE_VARS.GetFRICTION() * delta
	
	#TODO: apply other friction
	
	#scale velocity
	new_speed = speed - drop
	if new_speed < 0:
		new_speed = 0
	
	new_speed /= speed
	velocity *= new_speed

	return velocity

