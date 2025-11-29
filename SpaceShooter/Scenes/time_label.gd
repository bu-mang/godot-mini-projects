extends Label

func _ready() -> void:
	# 초기 시간 반영
	update_time(GameState.elapsed_time)

	# 1초마다 업데이트
	GameState.game_timer.timeout.connect(_on_timer_update)

func _on_timer_update() -> void:
	update_time(GameState.elapsed_time)

func update_time(seconds: float) -> void:
	var total_seconds = int(seconds)
	var minutes = total_seconds / 60
	var secs = total_seconds % 60
	text = "Time: %d:%02d" % [minutes, secs]
