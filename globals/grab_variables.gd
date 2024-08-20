extends Node2D

# fundamentally the wrong way to go about thsi

var carrying : bool = false

var current_line : Line2D
var current_start_point : Area2D
var making_connection : bool = false
var line_connected : bool = false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if making_connection:
		current_line.set_point_position(1, get_global_mouse_position())


func _on_making_connection(source : Area2D):
	carrying = true
	making_connection = true
	
	
	var line = Line2D.new()
	line.add_point(source.global_position)
	line.add_point(get_global_mouse_position())
	
	current_line = line
	current_start_point = source
	
	add_child(line)


func _on_recieving_connection(source : Area2D):
	if source != current_start_point:
		print("fuck")
		line_connected = true
		
	current_start_point = null


func _on_dropping_connection(source : Area2D):
	if current_line != null and line_connected == false:
		#remove_child(current_line)
		pass
	
	making_connection = false
	current_line = null
	line_connected = false
