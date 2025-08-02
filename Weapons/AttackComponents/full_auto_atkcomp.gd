class_name full_auto_atkcomp extends attack_component #

func _process(delta):
	if Input.is_action_pressed("shoot"):
		print('Attacking Full Auto')
