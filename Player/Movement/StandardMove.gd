class_name StandardMove extends IMove

var player_basis : Basis

func Move(delta: float):
	owning_player.velocity = self.calc_velocity(delta)
	owning_player.move_and_slide()
	
func calc_velocity(delta: float) -> Vector3:
	var input_dir = Vector3(
		Input.get_axis("move_left", "move_right"), 
		0, 
		Input.get_axis("move_forward", "move_back"))

	if input_dir != Vector3.ZERO:
		input_dir = player_basis * input_dir
		input_dir.y = 0
		input_dir = input_dir.normalized()

	var velocity = input_dir * SPEED
	velocity.y = owning_player.velocity.y

	if not owning_player.is_on_floor():
		velocity.y -= GRAVITY * delta
	else:
		velocity.y = 0

	return velocity
