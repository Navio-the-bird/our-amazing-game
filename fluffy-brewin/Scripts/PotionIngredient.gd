class_name PotionIngredient
extends RigidBody3D

#Ingredient is a resource here
#Apparently it's better to have each ingredient object be independent but have this script assigned to it,
#
@export var ingredient_data: Ingredient

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
