extends Sprite2D

func _ready():
	ghosting()
	
func set_property(tx_texture_head, tx_texture_body,tx_pos, tx_scale, tx_frame, tx_flip_h ):
	texture = tx_texture_head
	$Head.texture = tx_texture_body
	position = tx_pos
	scale = tx_scale
	frame = tx_frame
	$Head.frame = tx_frame
	flip_h = tx_flip_h
 
func ghosting():
	var tween_fade = get_tree().create_tween()
 
	tween_fade.parallel().tween_property(self, "self_modulate",Color(1, 1, 1, 0), 0.75)
	tween_fade.parallel().tween_property($Head, "self_modulate",Color(1, 1, 1, 0), 0.75)
	await tween_fade.finished
 
	queue_free()
