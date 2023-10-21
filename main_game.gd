extends Node2D

@onready
var GameData    : Node2D  = $Scripts/GameData;
@onready
var MapGenerator: Node2D = $Scripts/MapGenerator;
@onready
var MapDrawer   : Node2D = $Scripts/MapDrawer;
@onready
var Board       : Node2D  = $Board;
@onready
var Interface   : Node2D  = $interface;
@onready
var Camera                = $Camera/Camera
@onready
var globalVar = get_node("/root/GlobalData")

@onready
var beforeStartInterface = $interface/BeforeStart
@onready
var afterStartInterface = $interface/AfterStart

var possibleMovementDrawn = false;
var possibleMovementDrawnFrom = Vector2i(0,0);

var SeedValue = randi_range(0,999999);

func _ready():
	GameData.MainGame_ref = self;
	Interface.MainGameRef = self;
	MapDrawer.MainGame    = self;
	Camera.MainGame       = self
	GameData.Interface_ref = Interface;
	MapDrawer.Interface    = Interface;
	
	Interface.GameDataRef = GameData;
	
	Interface.prepareInterface();
	
	setZoomControlVisibilityToGlobalVar()
	
	if (globalVar.seedValue != null):
		SeedValue = globalVar.seedValue;
	Interface.setSeedValue(SeedValue);
	

	
	prepareGame(SeedValue)
	return;
	var path = GameData.COUNTRIES[GameData.PlayerTour].pathFinding(GameData.Capitals[0], GameData.Capitals[3])
	#var path = GameData.COUNTRIES[GameData.PlayerTour].pathFinding(GameData.Capitals[0], Vector2i(5,5))
	
	
	var c = Color(1,1,1,0.5)
	for cell in path:
		print(cell);
		MapDrawer.debugColorCords(cell,c);
	return;

func setZoomControlVisibilityToGlobalVar():
	if (globalVar.zoomControlActive):
		$Camera/ZoomControl.visible = true;
	else:
		$Camera/ZoomControl.visible = false;

func changeSeed(seed):
	globalVar.seedValue = seed;
	get_tree().reload_current_scene();

func prepareGame(seed = null):
	MapGenerator.getGameDataRef(GameData);
	MapGenerator.generateWorld(seed);
	
	MapDrawer.setGameDataReference(GameData);
	MapDrawer.setBoardReference(Board);
	MapDrawer.getBoard();
	MapDrawer.drawEveryThing();
	
	Interface._on_toggle_fast_moving_pressed();
	
	var boardHexGrid = Board.get_node("SuperBorder/hexGrid")
	boardHexGrid.activateSignalListnig();
	boardHexGrid.connect("nodeInBoardClicked", userInputOnBoard);
	
	for i in range(GameData.PlayersAmount):
		var ct = load("res://utils/countiries/Country.tscn").instantiate();
		ct.name = "ct"+str(i);
		ct.Country_name = GameData.CountriesNames[i];
		ct.Country_id   = i;
		ct.Country_color = GameData.CountriesColors[i];
		ct.cities.push_back(GameData.Capitals[i]);
		ct.GameData_ref = GameData;
		ct.Drawer_ref   = MapDrawer;
		
		GameData.COUNTRIES.push_back(ct);
		$Countries.add_child(ct);
	for c in GameData.COUNTRIES:
		c.prepareToGame();


func gameBegin(playerChoose):
	beforeStartInterface.visible  = false;
	afterStartInterface .visible  = true;
	if (playerChoose != null):
		GameData.Players[playerChoose] = GameData.playerType.PLAYER
	Interface.updateInterfaceNewPlayerHaveTour(null);
	GameData.COUNTRIES[GameData.PlayerTour].myTour()


func getUnitOnCell(cords): 
	var country = MapDrawer.LAND_CLAIM[cords.x][cords.y];
	if (GameData.BOARD[cords.x][cords.y] == GameData.cellType.WATER):
		for c in GameData.COUNTRIES:
			for u in c.units:
				if (u.cords.x == cords.x && u.cords.y == cords.y):
					return u;
		return null;
	if (country != null):
		for u in GameData.COUNTRIES[country].units:
			if (u.cords.x == cords.x && u.cords.y == cords.y):
				return u;
	return null;

func isInPossibleMovement(cords):
	if (MapDrawer.possibleMovementData.find(cords) == -1):
		return false;
	return true;

func cancelAnyPossibleMovement():
		MapDrawer.unDrawPossibleMovement();
		if (GameData.playerType.PLAYER == GameData.Players[GameData.PlayerTour]):
			MapDrawer.hightLightUnits(GameData.COUNTRIES[GameData.PlayerTour].units)
		possibleMovementDrawn = false;

func userInputOnBoard(x,y):
	if !GameData.isPlayerTour() || GameData.BlockMovement:
		return;
		
	if (isInPossibleMovement(Vector2i(x,y))):
		await GameData.COUNTRIES[GameData.PlayerTour].moveUnit(possibleMovementDrawnFrom, Vector2i(x,y));
		MapDrawer.unDrawPossibleMovement();
		MapDrawer.hightLightUnits(GameData.COUNTRIES[GameData.PlayerTour].units);
		possibleMovementDrawn = false;
		return;
		
	if (possibleMovementDrawn):
		print("undrawing possiblemovement")		
		MapDrawer.unDrawPossibleMovement();
		MapDrawer.hightLightUnits(GameData.COUNTRIES[GameData.PlayerTour].units)
		possibleMovementDrawn = false;
	
	var unitOnCell = getUnitOnCell(Vector2i(x,y));
	if (unitOnCell == null):
		print("there is no unit on board")
		return;
	
	if (unitOnCell.Country != GameData.PlayerTour):
		print("unit does not belong to player")
		return;
		
	if (unitOnCell.lockedForMovement):
		print("unit Is Locked")
		return;
	possibleMovementDrawnFrom = Vector2i(x,y);
	GameData.COUNTRIES[GameData.PlayerTour].unHighLightUnits();
	MapDrawer.drawPossibleMovement(possibleMovementDrawnFrom);
	print(MapDrawer.possibleMovementData)
	possibleMovementDrawn = true;

var iRegistEndOfTour= null;

func checkForGameEnd():
	var alivePlayers = 0;
	var playerAlive  = false;
	for u in range(0,GameData.PlayersStatus.size()):
		if (GameData.PlayersStatus[u] == GameData.playerStatus.ALIVE):
			alivePlayers += 1;
			if (GameData.Players[u] == GameData.playerType.PLAYER):
				playerAlive = true;
	if (playerAlive && alivePlayers == 1):
		GameData.GameComeToEnd = true;
		Interface.GameEnd(true);

	if (!playerAlive):
		GameData.GameComeToEnd = true;
		Interface.GameEnd(false);

		
func end_of_tour(countryId):
	if (GameData.GameComeToEnd || countryId == null || countryId != GameData.PlayerTour):
		return;
	GameData.COUNTRIES[countryId].unHighLightUnits();
	countryId = null
	var lastPlayer = GameData.PlayerTour;
	GameData.PlayerTour+=1;
	while (true):
		if (GameData.PlayerTour >= GameData.Players.size()):
			GameData.PlayerTour = 0;
			GameData.tour += 1;
			for c in GameData.COUNTRIES:
				if (GameData.PlayersStatus[c.Country_id] != GameData.playerStatus.ALIVE):
					continue;
				c.iknowItsMyTour = false;
				c.before_next_tour();
		if (GameData.PlayersStatus[GameData.PlayerTour] == GameData.playerStatus.ALIVE):
			break;
		else:
			GameData.PlayerTour+=1;
	Interface.updateInterfaceNewPlayerHaveTour(lastPlayer);
	await GameData.COUNTRIES[GameData.PlayerTour].myTour();
	
	
#await get_tree().create_timer(2).timeout
func _process(delta):
	end_of_tour(iRegistEndOfTour)
	await get_tree().create_timer(0.5).timeout




func button_new_game_start():
	changeSeed(randi_range(0,999999))

