extends Node
"""
#allows it to autoload
const DIR := {
	#assigns direction to grid offsets
	"N": Vector2i.UP
	"E": Vector2i.RIGHT
	"S": Vector2i.DOWN
	"W": Vector2i.LEFT
} 
const OPPOSITE := {
	#shows the direction you arrive in when you go through the door
	"N": "S",, 
	"S": "N",
	"W": "E",
	"E": "W",
}
const Room_Pools := {
	#1-door
	"N"
"""
var target_door_name: String = ""
