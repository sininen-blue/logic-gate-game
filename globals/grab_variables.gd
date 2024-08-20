extends Node2D

# have a list of all laready existing gates
# add and remove gates
var gates

func _ready() -> void:
	gates = get_tree().get_nodes_in_group("gates")


# drag gates
var current_target : Area2D

func _process(_delta: float) -> void:
	if current_target == null:
		return
	
	if Input.is_action_pressed("left_click"):
		current_target.global_position = get_global_mouse_position()


func _on_gate_hover(source : Area2D):
	if current_target == null:
		current_target = source

func _on_gate_unhover(source : Area2D):
	if current_target == source:
		current_target = null

# make a lsit of all connections
# start connection
# drop connection
# end connection
