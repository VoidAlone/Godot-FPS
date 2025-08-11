class_name IMove extends Resource

@export var SPEED : float = 14.0
@export var GRAVITY : float = 75.0

var owning_player: Character
enum MoveState {GROUND, AIR, SWIM, FLY}

@export var current_move_state: MoveState = MoveState.GROUND

func _init(owner = null):
	owning_player = owner

func _ready() -> void:
	if owning_player == null:
		push_error("No owning player defined")
		
func move(delta: float) -> Vector3:
	push_error('not implemented')
	return Vector3.ZERO
