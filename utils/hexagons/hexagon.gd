extends Node2D

signal nodeClicked;
var nodeId = 0;

func _on_touch_screen_button_pressed():
	emit_signal("nodeClicked", nodeId)
