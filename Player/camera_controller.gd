extends Node

#########################
#     Player Exports    #
#########################
@export_group("Player")
@export var character: CharacterBody3D
@export var head: Node3D

#########################
#     Mouse Settings	#
#########################
@export_group("Settings")

@export_subgroup("Mouse Settings")
@export_range(1,100,1) var mouse_sensitivity: int = 50

@export_subgroup("Clamp Settings")
@export var max_pitch: float = 90
@export var min_pitch: float = -90

func _ready():
	'''
		Quick and dirty mouse capture settings
		Adjust later to account for UI in _unhandled_input
	'''
	Input.set_use_accumulated_input(false)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		aim_look(event)
		
func aim_look(event: InputEventMouseMotion) -> void:
	var viewport_transform: Transform2D = get_tree().root.get_final_transform()
	var motion: Vector2 = event.xformed_by(viewport_transform).relative
	var degrees_per_unit: float = 0.001
	
	motion *= mouse_sensitivity
	motion *= degrees_per_unit
	
	add_yaw(motion.x)
	add_pitch(motion.y)
	
	clamp_pitch()
	
	
func add_yaw(x) -> void:
	if is_zero_approx(x):
		return
	
	character.rotate_object_local(Vector3.DOWN, deg_to_rad(x))
	character.orthonormalize()
	
func add_pitch(y) -> void:
	if is_zero_approx(y):
		return
	
	head.rotate_object_local(Vector3.LEFT, deg_to_rad(y))
	head.orthonormalize()
	
func clamp_pitch() -> void:
	var min_pitch_rad: float = deg_to_rad(min_pitch)
	var max_pitch_rad: float  = deg_to_rad(max_pitch)
	
	if head.rotation.x > min_pitch_rad and head.rotation.x < max_pitch_rad:
		return
	
	head.rotation.x = clamp(head.rotation.x, min_pitch_rad, max_pitch_rad)
	head.orthonormalize()
