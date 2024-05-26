extends Node2D

var grid = []
var backGrid = []
var spawnPosition
var pierPosition = []
var pierTeam = []
var pierOldTeam = []

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
	pierPosition.clear()
	pierTeam.clear()
	spawn_manager.pieceShapeMaker()
	for cell in spawn_manager.pieceShape:
		var pier = pietro.duplicate()
		var pos_x = (cell.x * gridSize) + (gridSize / 2)
		var pos_y = (cell.y * gridSize) + (gridSize / 2)
		pier.position = Vector2(pos_x, pos_y)
		pierTeam.append(pier)
		add_child(pier)
		pierPosition.append(pier.position)
	print("pierPosition at Spawn is ", pierPosition)

func shapeMoveCheck(dir):
	var pierDownPosition = []
	var pierLeftPosition = []
	var pierRightPosition = []
	var availableMove = false
	if dir == 0:
		for cell in pierPosition:
			var x = cell.x
			var y = cell.y + gridSize
			pierDownPosition.append(Vector2(x, y))
		for move in pierDownPosition:
			if move.y <= gridHeight * gridSize && move not in backGrid:
				availableMove = true
			else:
				availableMove = false
				break
	elif dir == 1:
		for cell in pierPosition:
			var x = cell.x +(gridSize * moveDirection)
			var y = cell.y + gridSize
			pierRightPosition.append(Vector2(x, y))
		for move in pierRightPosition:
			if move.x < gridWidth * gridSize && move not in backGrid:
				availableMove = true
			else:
				availableMove = false
				break
	elif dir == -1:
		for cell in pierPosition:
			var x = cell.x +(gridSize * moveDirection)
			var y = cell.y + gridSize
			pierLeftPosition.append(Vector2(x, y))
		for move in pierLeftPosition:
			if move.x >= 0  && move not in backGrid:
				availableMove = true
			else:
				availableMove = false
				break
	return availableMove

func moveShapeDown():
	var pierNewPosition = []
	for pier in pierTeam:
		var y 
		y = pier.position.y + gridSize
		pier.position.y = y
	for cell in pierPosition:
			var x = cell.x
			var y = cell.y + gridSize
			pierNewPosition.append(Vector2(x, y))
	pierPosition.clear()
	pierPosition = pierNewPosition.duplicate()

func moveShapeSides():
	var pierNewPosition = []
	for pier in pierTeam:
		var x 
		x = pier.position.x + (gridSize * moveDirection)
		pier.position.x = x
	for cell in pierPosition:
			var x = cell.x + (gridSize * moveDirection)
			var y = cell.y
			pierNewPosition.append(Vector2(x, y))
	pierPosition.clear()
	pierPosition = pierNewPosition.duplicate()

func changePiece():
	for pier in pierTeam:
		pierOldTeam.append(pier)
	for piece in pierPosition:
		backGrid.append(piece)
	shapeSpawn()
	print("backGrid is ", backGrid)
