extends Node

signal kill_me(source)

var hovering : bool = false

@onready var parent : Line2D = get_parent()
@onready var main : Node2D = get_parent().get_parent()

func _ready() -> void:
	parent.mouse_entered.connect(_on_mouse_entered)
	parent.mouse_exited.connect(_on_mouse_exited)
	
	# self.kill_me.connect(main._on_connetion_kill)


func _input(event: InputEvent) -> void:
	pass
	#if event.is_action_pressed("right_click") and hovering:
		#print("???")
		#kill_me.emit(parent)

func _on_mouse_entered() -> void:
	hovering = true

func _on_mouse_exited() -> void:
	hovering = false
