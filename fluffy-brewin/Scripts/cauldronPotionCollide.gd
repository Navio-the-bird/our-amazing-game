extends Node

@export var flask_scene: PackedScene
@export var flask_spawn_parent: Node3D
@export var flask_spawn_point: Marker3D

var added_ingredients: Array[Ingredient] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_collide(body: Node3D) -> void:
	if !(body is PotionIngredient):
		return
	var new_i = (body as PotionIngredient).ingredient_data
	print('Adding ingredient: ' + new_i.name)
	added_ingredients.push_back(new_i)
	body.queue_free()

func on_potion_complete() -> void:
	if (len(added_ingredients) == 0): 
		print('Cauldron is empty')
		return
	var new_flask = flask_scene.instantiate() as Flask
	new_flask.contained_ingredients = added_ingredients.duplicate()	
	new_flask.global_position = flask_spawn_point.global_position
	new_flask.add_to_group('pickup')
	flask_spawn_parent.add_child(new_flask)
	added_ingredients.clear()
