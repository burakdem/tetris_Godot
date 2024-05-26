extends Node2D

var grid = []

@onready var filler = $Filler

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func generateGrid():
	for x in range(get_parent().gridWidth):
		var row = []
		for y in range(get_parent().gridHeight):
			var pos_x = (x * get_parent().gridSize) + (get_parent().gridSize / 2)
			var pos_y = (y * get_parent().gridSize) + (get_parent().gridSize / 2)
			row.append(Vector2(pos_x, pos_y))
		grid.append(row)

func fillGrid():
	for row in grid:
		for cell in row:
			var x = cell.x
			var y = cell.y
			var BGPiece = filler.duplicate()
			BGPiece.position = Vector2(x, y)
			add_child(BGPiece)
