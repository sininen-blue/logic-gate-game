extends Node2D

signal gate_hover(source)
signal gate_unhover(source)

@onready var parent : Node = get_parent()
@onready var main : Node2D = get_parent().get_parent()

func _ready() -> void:
	parent.mouse_entered.connect(_on_mouse_entered)
	parent.mouse_exited.connect(_on_mouse_exited)
	
	self.gate_hover.connect(main._on_gate_hover)
	self.gate_unhover.connect(main._on_gate_unhover)

func _on_mouse_entered() -> void:
	gate_hover.emit(parent)

func _on_mouse_exited() -> void:
	gate_unhover.emit(parent)
