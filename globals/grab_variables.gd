extends Node2D

var gates : Array[Gate]
class Gate:
	var node : Area2D
	var type : String

var connections : Array[Connection]
class Connection:
	var line : Line2D
	var start : Gate
	var end : Gate
	var value : bool

@export var connection_line : PackedScene
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


func _on_gate_kill(source: Area2D):
	var gate_item : Gate
	for gate in gates:
		if gate.node == source:
			gate_item = gate
	
	var connection_items : Array[Connection]
	for connection in connections:
		if connection.start == gate_item or connection.end == gate_item:
			connection_items.append(connection)
	
	remove_child(gate_item.node)
	gates.erase(gate_item)
	
	for to_delete in connection_items:
		remove_child(to_delete.line)
		connections.erase(to_delete)

func _on_connection_kill(source : Line2D):
	print("??")

var new_connection : Connection
func _on_connection_start(source : Area2D, type : String):
	state = CREATING_CONNECTION
	
	new_connection = Connection.new()
	var source_gate : Gate
	for gate in gates:
		if gate.node == source:
			source_gate = gate
	
	if type == "output":
		new_connection.start = source_gate
	if type == "input":
		new_connection.end = source_gate


func _on_connection_stop(source : Area2D):
	state = IDLE
	
	if mouse_area.has_overlapping_areas() == false:
		new_connection = null
	
	# check if the area under the mouse position is an input
	var areas = mouse_area.get_overlapping_areas()
	for area in areas:
		# if connection started with an output
		if new_connection.end == null:
			if area.is_in_group("inputs") and area.parent != source:
				for gate in gates:
					if gate.node == area.parent:
						new_connection.end = gate
				
				new_connection.line = ConnectionLine.new()
				new_connection.line.add_point(Vector2.ZERO)
				new_connection.line.add_point(Vector2.ZERO)
				add_child(new_connection.line)
				
				connections.append(new_connection)
				new_connection = null
				break
			
		# if connection started with an input
		if new_connection.start == null:
			if area.is_in_group("outputs") and area.parent != source:
				for gate in gates:
					if gate.node == area.parent:
						new_connection.start = gate
				
				# probably change this line2d at some point
				new_connection.line = ConnectionLine.new()
				new_connection.line.add_point(Vector2.ZERO)
				new_connection.line.add_point(Vector2.ZERO)
				add_child(new_connection.line)
				
				connections.append(new_connection)
				new_connection = null
				break


func _process(_delta: float) -> void:
	mouse_area.global_position = get_global_mouse_position()
	
	if connections.is_empty() == false:
		for connection in connections:
			var last_point_index : int = connection.line.get_point_count() -1
			connection.line.set_point_position(0, connection.start.node.output_area.global_position)
			connection.line.set_point_position(last_point_index, connection.end.node.input_area.global_position)
	
	match state:
		IDLE:
			## TODO: put this in a state transition instead to save compute time
			for connection in connections:
				connection.line.distribute_areas()
		MOVING_GATE:
			pass
		CREATING_CONNECTION:
			pass
