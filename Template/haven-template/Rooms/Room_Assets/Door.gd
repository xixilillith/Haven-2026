extends Area2D
@export_file("*.tscn") var target_room: String
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
		for child in get_parent().get_children(): 
			if child is CharacterBody2D:
				child.global_position = $Start.global_position
				$CollisionShape2D.disabled = true 
				tween.tween_property(child, ":position", $Spawn.global_position, 1)
				tween.tween_callback(func(): $CollisionShape2D.disabled = false)
				print("moved the player to", $Spawn.global_position)
				break
func _on_body_entered(body: Node2D) -> void: 
	if body is CharacterBody2D and target_room!= "":
		GameManager.target_door_name = target_door_name
		get_tree().change_scene_to_file.call_deferred(target_room)
