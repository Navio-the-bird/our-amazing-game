class_name PotionButton
extends BaseInteractable

signal activate

func _interact() -> void:
	activate.emit()
	print('Ouch! I was clicked!')

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
