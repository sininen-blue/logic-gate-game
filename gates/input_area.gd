extends Area2D

signal making_connection(sender)
signal recieving_connection(sender)
signal dropped_connection(sender)

var hovering : bool = false

func _ready() -> void:
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)
	
	making_connection.connect(GrabVariables._on_making_connection)
	recieving_connection.connect(GrabVariables._on_recieving_connection)
	dropped_connection.connect(GrabVariables._on_dropping_connection)


func _process(_delta: float) -> void:
	$Label.text = str(hovering)
	
	
	if Input.is_action_just_released('left_click'):
		if hovering:
			recieving_connection.emit(self)
		else:
			dropped_connection.emit(self)
	
	if hovering:
		if Input.is_action_just_pressed("left_click"):
			print(get_parent().name, "start")
			making_connection.emit(self)


func _on_mouse_entered() -> void:
	hovering = true

func _on_mouse_exited() -> void:
	hovering = false
