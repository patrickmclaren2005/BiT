extends Area2D

@export var enemy_start_point:Vector2
@export var is_still:bool = true

func _on_body_entered(body: Node2D) -> void:
	if body is player:
		print("triggered enemy trigger")
		EventBus.add_enemy.emit(enemy_start_point, is_still)
		self.queue_free()
