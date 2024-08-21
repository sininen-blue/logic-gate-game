extends Node2D

var gates : Array[Gate]
class Gate:
	var node : Area2D
	var type : String

var connections : Array[Connection]
class Connection:
	var start : Gate
	var end : Gate
	var value : bool

@export var and_scene : PackedScene
@export var nand_scene : PackedScene
@export var or_scene : PackedScene
@export var nor_scene : PackedScene
@export var xor_scene : PackedScene
@export var xnor_scene : PackedScene
@export var not_scene : PackedScene

@onready var mouse_area: Area2D = $MouseArea



func create_gate(gate_node: Area2D) -> Gate:
	var new_gate : Gate = Gate.new()
	new_gate.node = gate_node
	new_gate.type = gate_node.name
	
	return new_gate

func _on_and_pressed() -> void:
	var and_gate = and_scene.instantiate()
	gates.append(create_gate(and_gate))
	add_child(and_gate)

func _on_nand_pressed() -> void:
	var nand_gate = nand_scene.instantiate()
	gates.append(create_gate(nand_gate))
	add_child(nand_gate)

func _on_or_pressed() -> void:
	var or_gate = or_scene.instantiate()
	gates.append(create_gate(or_gate))
	add_child(or_gate)

func _on_nor_pressed() -> void:
	var nor_gate = nor_scene.instantiate()
	gates.append(create_gate(nor_gate))
	add_child(nor_gate)

func _on_xor_pressed() -> void:
	var xor_gate = xor_scene.instantiate()
	gates.append(create_gate(xor_gate))
	add_child(xor_gate)

func _on_xnor_pressed() -> void:
	var xnor_gate = xnor_scene.instantiate()
	gates.append(create_gate(xnor_gate))
	add_child(xnor_gate)

func _on_not_pressed() -> void:
	var not_gate = not_scene.instantiate()
	gates.append(create_gate(not_gate))
	add_child(not_gate)

## Actions
enum {
	IDLE,
	MOVING_GATE,
	CREATING_CONNECTION,
}
var state : int = IDLE

func _on_gate_dragging_start(_source : Area2D):
	state = MOVING_GATE

func _on_gate_dragging_stop(_source : Area2D):
	state = IDLE

var new_connection : Connection
func _on_connection_start(source : Area2D):
	state = CREATING_CONNECTION
	
	new_connection = Connection.new()
	for gate in gates:
		if gate.node == source:
			new_connection.start = gate

func _on_connection_stop(source : Area2D):
	state = IDLE
	
	if mouse_area.has_overlapping_areas() == false:
		new_connection = null
		
	# check if the area under the mouse position is an input
	var areas = mouse_area.get_overlapping_areas()
	for area in areas:
		# check if start is an input or not
		# since the start will always be an input
		# I can just check if it's an input or now once
		# I do the output area programming
		# that or just throw another variable to null
		# will havea weird issue with simulation though
		if area.is_in_group("inputs") and area.parent != source:
			for gate in gates:
				if gate.node == area.parent:
					new_connection.end = gate
			
			connections.append(new_connection)
			new_connection = null


func _process(_delta: float) -> void:
	mouse_area.global_position = get_global_mouse_position()
	
	# debug line
	if connections.is_empty() == false:
		$Line2D.set_point_position(0, connections[0].start.node.global_position)
		$Line2D.set_point_position(1, connections[0].end.node.global_position)
	
	match state:
		IDLE:
			pass
		MOVING_GATE:
			pass
		CREATING_CONNECTION:
			pass


#var connections : Array
#enum Con_Type {NONE, INPUT, OUTPUT}
#var con_type = Con_Type.NONE
#var start_gate : Area2D
#var end_gate : Area2D
#var current_connection : Line2D
#
#var potential_close : Area2D
#
#func handle_connections():
	#if connections == null:
		#return
	#
	#for connection in connections:
		#connection[0].set_point_position(0 ,connection[1].global_position)
		#connection[0].set_point_position(1 ,connection[2].global_position)

#func _on_input_hover(source : Area2D):
	#if current_connection == null:
		#var line : Line2D = Line2D.new()
		#line.add_point(source.global_position)
		#
		#start_gate = source
		#current_connection = line
		#con_type = Con_Type.INPUT
	#else:
		#if current_connection.get_point_position(0) != source.global_position:
			#if con_type == Con_Type.OUTPUT:
				#potential_close = source
#
#func _on_output_hover(source : Area2D):
	#if current_connection == null:
		#var line : Line2D = Line2D.new()
		#start_gate = source
		#line.add_point(start_gate.global_position)
		#current_connection = line
		#con_type = Con_Type.OUTPUT
	#else:
		#if current_connection.get_point_position(0) != source.global_position:
			#if con_type == Con_Type.INPUT:
				#potential_close = source
#func _on_input_unhover(source : Area2D):
	#if current_connection != null and state != CREATING_CONNECTION:
		#current_connection = null
#
#func _on_output_unhover(source : Area2D):
	#if current_connection != null and state != CREATING_CONNECTION:
		#current_connection = null
