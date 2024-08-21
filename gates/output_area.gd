extends Area2D

#signal output_hover(source)
#signal output_unhover(source)
#
#@onready var main : Node2D = get_parent().get_parent()
#
#func _ready() -> void:
	#self.mouse_entered.connect(_on_mouse_entered)
	#self.mouse_exited.connect(_on_mouse_exited)
	#
	#self.output_hover.connect(main._on_output_hover)
	#self.output_unhover.connect(main._on_output_unhover)
#
#func _on_mouse_entered() -> void:
	#output_hover.emit(self)
#
#func _on_mouse_exited() -> void:
	#output_unhover.emit(self)
