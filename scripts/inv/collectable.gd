extends CSGBox3D

@onready var area_3d = $Area3D

@export var item :InvItem
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		print("collected")
		body.collect(item)
		queue_free()
