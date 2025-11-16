extends Node2D


func _on_timer_timeout() -> void:
	print('timeout')

# 1. load the scene
var meteor_scene: PackedScene = load("res://Scenes/meteor.tscn")

func _on_meteor_spawn_timer_timeout() -> void:
	# 2. create an instance
	var meteor = meteor_scene.instantiate()

	# 3. attach the node to the scene tree
	#add_child(meteor)
	$Meteors.add_child(meteor)
