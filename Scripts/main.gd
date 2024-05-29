extends Node2D

var grid = []
var backGrid = []
var spawnPosition
var piecePosition = []
var pieceTeam = []
var pieceOldTeam = []

var moveDirection

@export var gridWidth = 24
@export var gridHeight = 10
@export var gridSize = 64
@export var cameraVerticalOffset = 50

@onready var grid_manager = $gridManager
@onready var pietro = $pietro
@onready var camera_2d = $Camera2D
@onready var spawn_manager = $spawnManager

# Called when the node enters the scene tree for the first time.
func _ready():
	setCameraPosition()
	setGrid()
	shapeSpawn()

func setGrid():
	grid_manager.generateGrid()
	grid_manager.fillGrid()
	grid = grid_manager.grid
	spawn_manager.spawnPositionSet()
	spawnPosition = spawn_manager.spawnPosition

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("down"):
		moveDirection = 0
		if shapeMoveCheck(moveDirection) == true:
			moveShapeDown()
	elif Input.is_action_just_pressed("left"):
		moveDirection = -1
		if shapeMoveCheck(moveDirection) == true:
			moveShapeSides()
	elif Input.is_action_just_pressed("right"):
		moveDirection = 1
		if shapeMoveCheck(moveDirection) == true:
			moveShapeSides()
	elif Input.is_action_just_pressed("space"):
		changePiece()

func setCameraPosition():
	var x = (gridWidth * gridSize) / 2 
	var y = (gridHeight * gridSize) / 2 - cameraVerticalOffset
	camera_2d.position = Vector2(x , y)

func shapeSpawn():
	piecePosition.clear()
	pieceTeam.clear()
	spawn_manager.pieceShapeMaker()
	for cell in spawn_manager.pieceShape:
		var piece = pietro.duplicate()
		var childSprite = piece.get_node("Sprite2D")
		childSprite.visible = true
		var pos_x = (cell.x * gridSize) + (gridSize / 2)
		var pos_y = (cell.y * gridSize) + (gridSize / 2)
		piece.position = Vector2(pos_x, pos_y)
		pieceTeam.append(piece)
		add_child(piece)
		piecePosition.append(piece.position)
	print("piecePosition at Spawn is ", piecePosition)

func shapeMoveCheck(dir):
	var pieceDownPosition = []
	var pieceLeftPosition = []
	var pieceRightPosition = []
	var availableMove = false
	if dir == 0:
		for cell in piecePosition:
			var x = cell.x
			var y = cell.y + gridSize
			pieceDownPosition.append(Vector2(x, y))
		for move in pieceDownPosition:
			if move.y <= gridHeight * gridSize && move not in backGrid:
				availableMove = true
			else:
				print("no move")
				availableMove = false
				break
	elif dir == 1:
		for cell in piecePosition:
			var x = cell.x +(gridSize * moveDirection)
			var y = cell.y
			pieceRightPosition.append(Vector2(x, y))
		for move in pieceRightPosition:
			if move.x < gridWidth * gridSize && move not in backGrid:
				availableMove = true
			else:
				print("no move")
				availableMove = false
				break
	elif dir == -1:
		for cell in piecePosition:
			var x = cell.x +(gridSize * moveDirection)
			var y = cell.y
			pieceLeftPosition.append(Vector2(x, y))
		for move in pieceLeftPosition:
			if move.x >= 0  && move not in backGrid:
				availableMove = true
			else:
				print("no move")
				availableMove = false
				break
	return availableMove

func moveShapeDown():
	var pieceNewPosition = []
	for piece in pieceTeam:
		var y 
		y = piece.position.y + gridSize
		piece.position.y = y
	for cell in piecePosition:
			var x = cell.x
			var y = cell.y + gridSize
			pieceNewPosition.append(Vector2(x, y))
	piecePosition.clear()
	piecePosition = pieceNewPosition.duplicate()

func moveShapeSides():
	var pieceNewPosition = []
	for piece in pieceTeam:
		var x 
		x = piece.position.x + (gridSize * moveDirection)
		piece.position.x = x
	for cell in piecePosition:
			var x = cell.x + (gridSize * moveDirection)
			var y = cell.y
			pieceNewPosition.append(Vector2(x, y))
	piecePosition.clear()
	piecePosition = pieceNewPosition.duplicate()

func changePiece():
	for piece in pieceTeam:
		!piece.visible
		pieceOldTeam.append(piece)
	for piece in piecePosition:
		backGrid.append(piece)
	grid_manager.fillBackGrid()
	shapeSpawn()
	print("backGrid is ", backGrid)
