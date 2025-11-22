extends Area2D

var speed = 800

func _ready() -> void:
	var tween = create_tween()
	tween.tween_property($Laser, 'scale', Vector2(4,32), 0.05).from(Vector2(0,0))
	
func _process(delta: float) -> void:
	position.y -= speed * delta
