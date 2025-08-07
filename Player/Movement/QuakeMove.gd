class_name QuakeMove extends IMove

func move(delta, basis) -> Vector3:
	var velocity : Vector3
	match self.current_state:
		MoveState.GROUND:
			velocity = self.ground_move(delta)
		MoveState.AIR:
			pass
		MoveState.SWIM:
			pass
		MoveState.FLY:
			pass
		_:
			pass
	return velocity

func ground_move(delta: float,) -> Vector3:
	var velocity
	var input_dir = Vector3(
		Input.get_axis("move_left", "move_right"), 
		0, 
		Input.get_axis("move_forward", "move_back"))

	if input_dir != Vector3.ZERO:
		input_dir = owning_player.global_transform.basis * input_dir
		input_dir.y = 0
		input_dir = input_dir.normalized()

	return velocity

func accel():
	pass
	
func friction():
	pass
	
