extends Area2D
@export_file("*.tscn") var target_room: String
@export var target_door_name: String

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	if GameManager.target_door_name == name: 
		GameManager.target_door_name = ""
		var player := get_tree().current_scene.get_node_or_null("CharacterBody2D")
		if player: 
				player.global_position = $Spawn.global_position
func _on_body_entered(body: Node2D) -> void: 
	if body is CharacterBody2D and target_room!= "":
		GameManager.target_door_name = target_door_name
		get_tree().change_scene_to_file.call_deferred(target_room)
