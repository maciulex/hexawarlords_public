extends Node2D

@onready
var animation :AnimationPlayer = $AnimationPlayer;

func deactivate(speed):
	animation.play("smaller",-1,speed)
	
func activate(speed):
	animation.play("bigger",-1,speed)

func setColor(color):
	$Shild.modulate = color;


func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"bigger":
			$Shild.scale = Vector2(0.15, 0.15)
		"smaller":
			$Shild.scale = Vector2(0.09, 0.09)
