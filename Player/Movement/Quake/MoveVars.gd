class_name MoveVars extends Resource

@export var STOP_SPEED : float = 100.0
@export var DUCK_SCALE : float = 0.25
@export var SWIM_SCALE : float = 0.50
@export var WADE_SCALE : float = 0.75

@export var FRICTION	: float = 6.0
@export var ACCEL 	: float = 10.0
@export var GRAVITY 	: float = 9.8
@export var SPEED 	: float = 10.0

func GetSTOP_SPEED():
	return STOP_SPEED
func GetDUCK_SCALE():
	return DUCK_SCALE
func GetSWIM_SCALE():
	return SWIM_SCALE
func GetWADE_SCALE():
	return WADE_SCALE

func GetFRICTION():
	return FRICTION
func GetACCEL():
	return ACCEL
func GetGRAVITY():
	return GRAVITY
func GetSPEED():
	return SPEED
