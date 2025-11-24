extends Node2D

var rng:= RandomNumberGenerator.new()

var is_executed := false
var scoring_animation := load("res://Scenes/scoringAnimation.tscn")

const MIN_FUEL_DISTANCE := 150.0  # 다른 fuel과 이 거리 이상 떨어지게
const MAX_REPOSITION_TRIES := 10 # 너무 많이 도는 것 방지용

func _ready():
	GameState.is_game_over_changed.connect(on_is_game_over_changed)
	
	rng.randomize()
	
	# ------ Randomize Position ------
	var viewport_size = get_viewport().get_visible_rect().size
	var existing_fuels = get_parent().get_children()
	
	position = Util.random_non_overlapping_position(
		viewport_size,
		existing_fuels,
		MIN_FUEL_DISTANCE, # 최소 거리
		MAX_REPOSITION_TRIES # 최대 시도 횟수
	)
	
	# 사실 상 yield다.
	await get_tree().create_timer(5.0).timeout
	play_faded_out_animation()

func _on_body_entered(_body: Node2D) -> void:
	if (!is_executed):
		is_executed = true
		GameState.add_fuel(5)
		$Fuel.modulate.a = 0
		
		var score_anim = scoring_animation.instantiate()
		score_anim.position = position
		score_anim.scale = Vector2(2,2)
		
		get_parent().add_child(score_anim)
		
func play_faded_out_animation():
		# 1초간 투명도 0으로 줄이기 (페이드아웃)
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.3) # 1초 동안 a(투명도)를 0으로
	
	# 애니메이션 끝날 때까지 정확히 대기
	await tween.finished
	 
	# 제거
	queue_free()
	
func on_is_game_over_changed(game_over):
	if game_over == true:
		play_faded_out_animation()
	
	
