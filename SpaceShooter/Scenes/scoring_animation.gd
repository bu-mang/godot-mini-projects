# '반짝' 애니메이션

extends AnimatedSprite2D

func _ready() -> void:
	play("default")  # 재생 시작

func _on_animation_finished() -> void:
	queue_free()     # 끝나면 자동 삭제
