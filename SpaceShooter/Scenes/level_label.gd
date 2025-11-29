extends Label

func _ready() -> void:
	# 초기 레벨 반영
	text = "Level: " + str(GameState.level)

	# 레벨 바뀔 때마다 텍스트 갱신
	GameState.level_changed.connect(_on_level_changed)

func _on_level_changed(new_level: int) -> void:
	text = "Level: " + str(new_level)
