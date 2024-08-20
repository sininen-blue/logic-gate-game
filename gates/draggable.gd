extends Node2D

var hovering : bool = false
var being_carried : bool = false

@onready var parent : Node = get_parent()

func _ready() -> void:
	parent.mouse_entered.connect(_on_mouse_entered)
	parent.mouse_exited.connect(_on_mouse_exited)

func _process(_delta: float) -> void:
	if hovering and GrabVariables.carrying == false:  
		if Input.is_action_pressed("left_click"):
			GrabVariables.carrying = true
			being_carried = true
					
	if Input.is_action_just_released("left_click"):
		GrabVariables.carrying = false
		being_carried = false
	
	if being_carried:
		parent.global_position = get_global_mouse_position()


func _on_mouse_entered() -> void:
	hovering = true
		

func _on_mouse_exited() -> void:
	hovering = false
