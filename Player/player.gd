class_name player extends CharacterBody3D

var move_strat : IMove
#var QuakeMove = preload('res://Movement/QuakeMove.gd')

func _ready() -> void:
	if move_strat == null:
		move_strat = QuakeMove.new(self)

func _physics_process(delta: float) -> void:
	velocity = move_strat.move(delta, self.global_transform.basis)
	custom_move_and_slide()
		
func custom_move_and_slide():
	pass
