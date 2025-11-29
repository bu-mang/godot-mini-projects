extends Area2D

var speed = GameState._laser_speed

func _ready() -> void:
	# GameState의 laser_scale 값 가져오기 (1.0 ~ 1.8)
	var laser_scale = GameState.laser_scale

	# 기본 크기에 scale 적용 (세로는 조금 둔하게)
	var y_scale = (laser_scale - 0.1) if laser_scale == 1.0 else laser_scale * 0.9
	var final_scale = Vector2(4 * laser_scale, 32 * y_scale)

	var tween = create_tween()
	tween.tween_property($Laser, 'scale', final_scale, 0.05).from(Vector2(0,0))

	# 충돌 범위도 scale에 맞게 조정
	scale = Vector2(laser_scale, laser_scale)

func _process(delta: float) -> void:
	position.y -= speed * delta
