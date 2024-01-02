extends Sprite2D

func _ready():
	ghosting()
func  _physics_process(_delta):
	frame = self.frame
func set_property(tx_pos, tx_scale):
	position = tx_pos
	scale = tx_scale
 
func ghosting():
	var tween_fade = create_tween()
 
	tween_fade.tween_property(self, "self_modulate",Color(1, 1, 1, 0), 0.75 )
	await tween_fade.finished
 
	queue_free()

func Delete_Blast():
	self.queue_free()
