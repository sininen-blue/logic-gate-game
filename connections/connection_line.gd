extends Line2D
class_name ConnectionLine

#go to the start point
#add an area2d
#check if the distance to the next point is less than the radius of the area2d
#if so
#add an area2d
#go again
#until you reach the end

# I feel like I should change this entireley

var start_point : Vector2
var end_point : Vector2

var distance : float = 30
var index : int = 0

func _ready() -> void:
	fill()

func fill():
	var distance_to_prev_point : float = 0.0
	var last_point : Vector2 = points[-1]
	
	while points[index].distance_to(last_point) > distance:
		create_area(points[index])
		var current_point : Vector2 = points[index]
		var next_point : Vector2 = current_point + (current_point.direction_to(last_point) * 5)
		self.add_point(points[index] + points[index].direction_to(last_point) * distance, index + 1)
		
		index += 1

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("left_click"):
		#self.set_point_position(self.get_point_count()-1, get_global_mouse_position())
		#fill()

func create_area(target : Vector2):
	var area : Area2D = Area2D.new()
	area.global_position = target
	
	var collision : CollisionShape2D = CollisionShape2D.new()
	var shape: CircleShape2D = CircleShape2D.new()
	shape.radius = 20
	
	collision.shape = shape
	self.add_child(area)
	area.add_child(collision)
