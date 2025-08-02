class_name player extends CharacterBody3D

var move_strat : IMove
#var QuakeMove = preload('res://Movement/QuakeMove.gd')

func _ready() -> void:
	if move_strat == null:
		move_strat = QuakeMove.new(self)
	if move_strat.owning_player == null:
		move_strat.owning_player = self

func _physics_process(delta: float) -> void:
	if move_strat:
		move_strat.move(delta)
		
