extends Node2D

signal dragging_start(source)
signal dragging_stop(source)

var draggable : bool = false
var dragging : bool = false

var offset : Vector2

@onready var parent : Area2D = get_parent()
@onready var main : Node2D = get_parent().get_parent()

func _ready() -> void:
	parent.mouse_entered.connect(_on_mouse_entered)
	parent.mouse_exited.connect(_on_mouse_exited)
	
	self.dragging_start.connect(main._on_gate_dragging_start)
	self.dragging_stop.connect(main._on_gate_dragging_stop)


func _process(_delta: float) -> void:
	if draggable:
		if Input.is_action_just_pressed("left_click") and main.state == 0:
			dragging_start.emit(parent)
			
			offset = get_global_mouse_position() - parent.global_position
			dragging = true
	
	if dragging:
		parent.global_position = get_global_mouse_position() - offset
		
		if Input.is_action_just_released("left_click"):
			dragging_stop.emit(parent)
			dragging = false

func _on_mouse_entered() -> void:
	draggable = true

func _on_mouse_exited() -> void:
	draggable = false
