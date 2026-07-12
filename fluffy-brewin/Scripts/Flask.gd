class_name Flask
extends Node3D

var contained_ingredients: Array[Ingredient] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print('Flask contains ingredients: ', contained_ingredients.map(func (r): return r.name))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
