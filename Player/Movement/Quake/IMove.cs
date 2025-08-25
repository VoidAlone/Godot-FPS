using Godot;
using System;

public partial class IMove : Resource
{
	public float SPEED = 14;
	public float GRAVITY = 75;
	// Character owning_player;
	
	enum MoveState {GROUND, AIR, SWIM, FLY}
	MoveState current_move_state = MoveState.GROUND;
}

//func _init(owner = null):
	//owning_player = owner
//
//func _ready() -> void:
	//if owning_player == null:
		//push_error("No owning player defined")
		//
//func move(delta: float) -> Vector3:
	//push_error('not implemented')
	//return Vector3.ZERO
