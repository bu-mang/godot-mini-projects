# util.gd
extends Node
class_name Util  # 전역처럼 그냥 Util.함수()로 사용할 수 있게 해줌

static func random_non_overlapping_position(
	viewport_size: Vector2,
	existing_nodes: Array,
	min_distance: float = 80.0,
	max_tries: int = 10
) -> Vector2:
	var rng := RandomNumberGenerator.new()
	rng.randomize()

	for i in max_tries:
		var x = rng.randf_range(0, viewport_size.x)
		var y = rng.randf_range(0, viewport_size.y)
		var candidate := Vector2(x, y)

		if not _is_too_close(candidate, existing_nodes, min_distance):
			return candidate

	# 실패하면 그냥 중앙 리턴
	return viewport_size * 0.5


static func _is_too_close(candidate: Vector2, nodes: Array, min_distance: float) -> bool:
	for n in nodes:
		if not n is Node2D:
			continue
		if n.position.distance_to(candidate) < min_distance:
			return true
	return false
