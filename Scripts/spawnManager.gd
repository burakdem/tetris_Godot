extends Node2D

var pieceShapeArea = []
var pieceShapeAreaFill = []

var pieceShape = []
var pieceShapeHeight = 3
var pieceShapeWidth = 5

var spawnPosition = Vector2()
var currentPiece 

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawnPositionSet():
	#var x = (get_parent().gridWidth * get_parent().gridSize) / 2
	var grid = get_parent().grid
	var x_index = int(grid.size()/2)
	var y_index = 0
	spawnPosition = grid[x_index][y_index]

func pieceShapeAreaMaker():
	for x in range(pieceShapeWidth):
		var row = []
		for y in range(pieceShapeHeight):
			row.append(Vector2(x, y))
		pieceShapeArea.append(row)
	pieceShapeAreaFill = pieceShapeArea.duplicate()

func pieceShapeMaker():
	pieceShapeAreaMaker()
	var pickedShape = []
	var shapeCount = randi_range(2 , pieceShapeHeight * pieceShapeWidth)
	var pickedCell =[]
	var pickedRow = []
	pickedRow.clear()
	pickedShape.clear()
	for x in range(shapeCount):
		pieceShapeAreaFill.shuffle()
		pieceShapeAreaFill.reverse()
		pickedRow = pieceShapeAreaFill.pop_front()
		if pickedRow == null:
			continue
		pickedRow.shuffle()
		pickedRow.reverse()
		pickedCell = pickedRow.pop_front()
		if pickedCell in pickedShape or pickedCell == null:
			continue
		pickedShape.append(pickedCell)
		if pickedRow.size() > 0:
			pieceShapeAreaFill.append(pickedRow)
	pieceShapeAreaFill = pieceShapeArea.duplicate()
	#might change for showing next piece
	pickedShape.sort()
	pieceShape = pickedShape.duplicate()
	print("shape is ", pieceShape)
