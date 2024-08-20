extends Area2D

signal input_hover(source)
signal input_unhover(source)

@onready var main : Node2D = get_parent().get_parent()

func _ready() -> void:
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)
	
	self.input_hover.connect(main._on_input_hover)
	self.input_unhover.connect(main._on_input_unhover)

func _on_mouse_entered() -> void:
	input_hover.emit(self)

func _on_mouse_exited() -> void:
	input_unhover.emit(self)
