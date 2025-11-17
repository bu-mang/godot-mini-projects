extends Area2D

var speed = 300

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	position.y -= speed * delta
