extends Node2D

# have a list of all laready existing gates
# add and remove gates
var gates

func _ready() -> void:
	gates = get_tree().get_nodes_in_group("gates")


# drag gates
var current_gate : Area2D

enum {
	IDLE,
	MOVING_GATE,
	CREATING_CONNECTION,
}
var state = IDLE


# TODO:
# current issue is that you can have multiple connections with the same start and stop
# a way to delete connections

func _process(_delta: float) -> void:
	handle_connections()
	match state:
		IDLE:
			if Input.is_action_just_pressed("left_click"):
				if current_gate != null:
					state = MOVING_GATE
				
				if current_connection != null:
					current_connection.add_point(get_global_mouse_position())
					add_child(current_connection)
					
					state = CREATING_CONNECTION

		MOVING_GATE:
			current_gate.global_position = get_global_mouse_position()
			
			if Input.is_action_just_released("left_click"):
				current_gate = null
				state = IDLE

		CREATING_CONNECTION:
			current_connection.set_point_position(1, get_global_mouse_position())
			
			if Input.is_action_just_released("left_click"):
				if potential_close != null:
					end_gate = potential_close
					
					connections.append([current_connection, start_gate, end_gate])
					
					start_gate = null
					end_gate = null
					potential_close = null
					current_connection = null
					con_type = Con_Type.NONE
					state = IDLE
				else:
					remove_child(current_connection)
					start_gate = null
					end_gate = null
					current_connection = null
					state = IDLE


func _on_gate_hover(source : Area2D):
	if current_gate == null:
		current_gate = source

func _on_gate_unhover(source : Area2D):
	if current_gate != null and state != MOVING_GATE:
		current_gate = null



var connections : Array
enum Con_Type {NONE, INPUT, OUTPUT}
var con_type = Con_Type.NONE
var start_gate : Area2D
var end_gate : Area2D
var current_connection : Line2D

var potential_close : Area2D

func handle_connections():
	if connections == null:
		return
	
	for connection in connections:
		connection[0].set_point_position(0 ,connection[1].global_position)
		connection[0].set_point_position(1 ,connection[2].global_position)

# TODO add a check to make sure inputs only go to outputs and vice versa
func _on_input_hover(source : Area2D):
	if current_connection == null:
		var line : Line2D = Line2D.new()
		line.add_point(source.global_position)
		
		start_gate = source
		current_connection = line
		con_type = Con_Type.INPUT
	else:
		if current_connection.get_point_position(0) != source.global_position:
			if con_type == Con_Type.OUTPUT:
				potential_close = source

func _on_output_hover(source : Area2D):
	if current_connection == null:
		var line : Line2D = Line2D.new()
		start_gate = source
		line.add_point(start_gate.global_position)
		current_connection = line
		con_type = Con_Type.OUTPUT
	else:
		if current_connection.get_point_position(0) != source.global_position:
			if con_type == Con_Type.INPUT:
				potential_close = source


func _on_input_unhover(source : Area2D):
	if current_connection != null and state != CREATING_CONNECTION:
		current_connection = null

func _on_output_unhover(source : Area2D):
	if current_connection != null and state != CREATING_CONNECTION:
		current_connection = null
