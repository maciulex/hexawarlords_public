extends Node2D

var GAME_DATA_REF = null;
var rng = RandomNumberGenerator.new()

@export
var PORT_CHANCE_MIN = 1;
@export
var PORT_CHANCE_MAX = 4;
@export
var PORT_CHANCE_TRE = 1;
@export
var CITI_CHANCE_TRE = 80;

func getGameDataRef(ref):
	GAME_DATA_REF = ref

func getCapitals():
	for cap in GAME_DATA_REF.Capitals:
		GAME_DATA_REF.BOARD[cap.x][cap.y] = GAME_DATA_REF.cellType.CAPITAL
		for x in range(-1,2):
			for y in range(-1,2):
				if (cap.x % 2 == 1):
					if ((x == -1 || x == 1) && y == -1): continue;
				else:
					if ((x == -1 || x == 1) && y == 1): continue;					
				if (x == 0 && y == 0): continue;
				GAME_DATA_REF.BOARD[cap.x+x][cap.y+y] = GAME_DATA_REF.cellType.EARTH;

func getWater():
	for w in rng.randi_range(GAME_DATA_REF.MinWaterSourcesTries, GAME_DATA_REF.waterSourcesTries):
		var startingPos = Vector2i(rng.randi_range(0, GAME_DATA_REF.BOARD_SIZE.x),
									rng.randi_range(0, GAME_DATA_REF.BOARD_SIZE.y));
		for s in rng.randi_range(GAME_DATA_REF.MinmakxWaterSourceSize, GAME_DATA_REF.makxWaterSourceSize):
			var direction = Vector2i(rng.randi_range(-1, 1), rng.randi_range(-1, 1));
			direction.x += startingPos.x;
			direction.y += startingPos.y;
			if(direction.x >= GAME_DATA_REF.BOARD_SIZE.x || direction.x < 0 ||   
			   direction.y >= GAME_DATA_REF.BOARD_SIZE.y || direction.y < 0): continue;
			if (GAME_DATA_REF.BOARD[direction.x][direction.y] == null):
				GAME_DATA_REF.BOARD[direction.x][direction.y] = GAME_DATA_REF.cellType.WATER

func portHelper(pos):
	var isCapital = false;
	var capitalSafe = false
	for xx in range(-1,2):
		for yy in range(-1,2):
			if (xx == 0 && yy == 0): continue;			
			if (pos.x % 2 == 1):
				if ((xx == -1 || xx == 1) && yy == -1): continue;
			else:
				if ((xx == -1 || xx == 1) && yy == 1): continue;
			if (GAME_DATA_REF.BOARD_SIZE.x <= pos.x+xx || pos.x+xx < 0): continue;
			if (GAME_DATA_REF.BOARD_SIZE.y <= pos.y+yy || pos.y+yy < 0): continue;	
			
			if (GAME_DATA_REF.cellType.CAPITAL == GAME_DATA_REF.BOARD[pos.x+xx][pos.y+yy] && !capitalSafe):
				isCapital = true;
			
			if (GAME_DATA_REF.BOARD[pos.x+xx][pos.y+yy] == GAME_DATA_REF.cellType.WATER):
				if (randi_range(PORT_CHANCE_MIN,PORT_CHANCE_MAX) > PORT_CHANCE_TRE && (!isCapital)):
					return;
				GAME_DATA_REF.BOARD[pos.x][pos.y] = GAME_DATA_REF.cellType.PORT;
				capitalSafe = true;
				return;

func getPorts():
	for x in range(GAME_DATA_REF.BOARD_SIZE.x):
		for y in range(GAME_DATA_REF.BOARD_SIZE.y):
			if GAME_DATA_REF.BOARD[x][y] == GAME_DATA_REF.cellType.EARTH:
				portHelper(Vector2i(x,y));

func cityHelper(pos):
	
	for xx in range(-1,2):
		for yy in range(-1,2):
			if (pos.x % 2 == 1):
				if ((xx == -1 || xx == 1) && yy == -1): continue;
			else:
				if ((xx == -1 || xx == 1) && yy == 1): continue;
			if (GAME_DATA_REF.BOARD_SIZE.x <= pos.x+xx || pos.x+xx < 0): continue;
			if (GAME_DATA_REF.BOARD_SIZE.y <= pos.y+yy || pos.y+yy < 0): continue;
			if (GAME_DATA_REF.BOARD[pos.x+xx][pos.y+yy] == GAME_DATA_REF.cellType.CITY ||
					GAME_DATA_REF.BOARD[pos.x+xx][pos.y+yy] == GAME_DATA_REF.cellType.PORT ||
					GAME_DATA_REF.BOARD[pos.x+xx][pos.y+yy] == GAME_DATA_REF.cellType.CAPITAL ):
				return;
	GAME_DATA_REF.BOARD[pos.x][pos.y] = GAME_DATA_REF.cellType.CITY
	GAME_DATA_REF.SET_OF_CITIES.push_back(pos);
		

func getCities():
	for cit in range(CITI_CHANCE_TRE):
		var startingPos = Vector2i(rng.randi_range(0, GAME_DATA_REF.BOARD_SIZE.x-1),
									rng.randi_range(0, GAME_DATA_REF.BOARD_SIZE.y-1));
		if (GAME_DATA_REF.cellType.EARTH == GAME_DATA_REF.BOARD[startingPos.x][startingPos.y]):
			cityHelper(startingPos)

func fillGrass():
	for x in range(GAME_DATA_REF.BOARD_SIZE.x):
		for y in range(GAME_DATA_REF.BOARD_SIZE.y):
			if GAME_DATA_REF.BOARD[x][y] == null:
				GAME_DATA_REF.BOARD[x][y] = GAME_DATA_REF.cellType.EARTH;

func generateWorld(seedInput = null):
	getCapitals();
	if (seedInput != null):
		rng.seed = seedInput;
	else:
		seedInput = randi_range(1,99999);
		rng.seed = seedInput;
	getWater();
	fillGrass();
	getPorts();
	getCities();
	return seedInput;
	
