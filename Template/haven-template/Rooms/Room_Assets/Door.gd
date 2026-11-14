extends Area2D
@export var target_room: PackedScene
@export var target_door_name: String
@onready var tween = get_tree().create_tween()
@onready var marker: Marker2D = $Spawn
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	var expected := GameManager.target_door_name.strip_edges()
	if expected != "":
		print("Loaded door '", name, "'  | Looking for '", expected, " ' ")
	if expected == name:
		GameManager.target_door_name = ""
		for child in get_tree().current_scene.get_children(): 
			if child is CharacterBody2D:
				var camera = get_viewport().get_camera_2d()
				child.global_position = $Start.global_position
				$CollisionShape2D.disabled = true 
				tween.set_parallel()
				tween.tween_property(camera, "global_position", camera.global_position + Vector2(0, -270), 1)
				tween.tween_property(child, "position", $Spawn.global_position, 1)
				tween.tween_callback(func(): $CollisionShape2D.disabled = false)
				print("moved the player to", $Spawn.global_position)
				break
func _on_body_entered(body: Node2D) -> void: 
	if body is CharacterBody2D and target_room != null:
		GameManager.target_door_name = target_door_name
		var tscn = target_room.instantiate()
		tscn.global_position = global_position + Vector2(-240, -270)
		get_tree().current_scene.add_child(tscn)
		print("Successfully instantiated next room.")
	else:
		print("Error on collision.")
