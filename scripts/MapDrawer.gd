extends Node2D

var Board_Ref = null;
var GameData  = null;
var MainGame  = null;
var Interface = null;

var BOARD : Array = [];
var LAND_CLAIM : Array = [];
var refReady : bool = false;

enum IconType    {CAPITAL, CITY, PORT, SOLDER, ALTHIRERY, TANK, MARINE}
var  IconScale = [2.3, 2.5, 1.3];

enum  UnitsType  {SHIP, SOLDER, ALTILERY, TANK, SUBMARINE};
var  UnitsScale= [0.065, 0.05, 0.12, 0.038, 0.09];
#var  UnitsScale= [0.065, 0.05,  0.12, 0.037, 0.09];
var hexSize = Vector2i(36,40);

var rng = RandomNumberGenerator.new()

var  landAmount = 35
var  landTextureIndex = [];

var possibleMovementData = [];

var UnitsIcons : Array = [
	"res://images/units/ship.png",
	"res://images/units/solder.png",
	"res://images/units/alitrery.png",
	"res://images/units/tank.png",
	"res://images/units/submarine.png",
];

var CapitalIcons : Array = [
	"res://images/icons/capital_red.png",
	"res://images/icons/capital_blue.png",
	"res://images/icons/capital_violet.png",
	"res://images/icons/capital_green.png"
];

var CityIcon : String = "res://images/icons/townhall.png";
var PortIcon : String = "res://images/icons/anchor.png";

var City_normal : Array = [
	"res://images/urban/c_1.png", "res://images/urban/c_2.png",
	"res://images/urban/c_3.png", "res://images/urban/c_4.png",
	"res://images/urban/c_5.png", "res://images/urban/c_6.png"
];

var City_destroyed : Array = [
	"res://images/urban/cd_1.png", "res://images/urban/cd_2.png",
	"res://images/urban/cd_3.png", "res://images/urban/cd_4.png",
	"res://images/urban/cd_5.png", "res://images/urban/cd_6.png"
];

var Land_destroyed: Array = [
	"res://images/land/ld_1.png","res://images/land/ld_2.png",
	"res://images/land/ld_3.png","res://images/land/ld_4.png",
	"res://images/land/ld_5.png","res://images/land/ld_6.png"
];

var Land_normal : Array = [
	"res://images/land/l_1.png","res://images/land/l_2.png",
	"res://images/land/l_3.png","res://images/land/l_4.png",
	"res://images/land/l_5.png","res://images/land/l_6.png"
];

var Water : Array = [
	"res://images/water/m_1.png","res://images/water/m_2.png",
	"res://images/water/m_3.png","res://images/water/m_4.png",
	"res://images/water/m_5.png","res://images/water/m_6.png"
];

func getPositionFromHexPosition(pos : Vector2i):
	var offset = 0 if (pos.x % 2 == 0) else hexSize.y/2;	
	return Vector2i(
					(hexSize.x*pos.x), 
					(hexSize.y*pos.y)+offset						
					)

func isReady():
	if (GameData != null && Board_Ref != null):
		refReady = true;
	else:
		refReady = false;
	return refReady;
	

func setBoardReference(ref):
	Board_Ref = ref;
	
func setGameDataReference(ref):
	GameData = ref;

func getHexPathColor(pos : Vector2i):
	var yIndex = "" if pos.y == 0 else str(pos.y+1);
	return "SuperBorder/Graphic/hexGridColors/x"+str(pos.x)+"/hexagon"+yIndex;

func getHexPositionInPX(pos : Vector2i):
	return Board_Ref.get_node(getHexPath(pos)).position

func getHexPath(pos : Vector2i):
	var yIndex = "" if pos.y == 0 else str(pos.y+1);
	return "SuperBorder/hexGrid/x"+str(pos.x)+"/hexagon"+yIndex;

func getBoard():
	if (!isReady()):
		return false;
	
	for x in range(GameData.BOARD_SIZE.x):
		var yRow : Array = [];
		var yRow2 : Array = [];
		
		for y in range(GameData.BOARD_SIZE.y):
			yRow.push_back(Board_Ref.get_node(getHexPathColor(Vector2i(x,y))));
			yRow2.push_back(null);
		BOARD.push_back(yRow)
		LAND_CLAIM.push_back(yRow2)
		
	pass;
	
	
func getUnitSprite(unitType):
	return UnitsIcons[unitType]

func getUnitType(unitStrenght, cords):
	if (GameData.BOARD[cords.x][cords.y] == GameData.cellType.WATER):
		if (unitStrenght < 50):
			return UnitsType.SHIP;
		else:
			return UnitsType.SUBMARINE;
	if (unitStrenght < 30):
		return UnitsType.SOLDER;
	if (unitStrenght < 70):
		return UnitsType.ALTILERY;
	return UnitsType.TANK;
	
func isOutsideBoard(cords : Vector2i):
	if (cords.x < 0 || cords.y < 0 || cords.x >= GameData.BOARD_SIZE.x || cords.y >= GameData.BOARD_SIZE.y):
		return true;
	return false;
	
func undrawColorMask(cords):
	var color;
	if (LAND_CLAIM[cords.x][cords.y] == null):
		color = Color(0,0,0,0);
	else:
		color = GameData.CountriesColors[LAND_CLAIM[cords.x][cords.y]];
		color.a8 = 90;
	Board_Ref.get_node(getHexPath(cords)+"/poly").color = color;
	
func unDrawPossibleMovement():
	for i in possibleMovementData:
		undrawColorMask(i);
	
	possibleMovementData = [];

func hightLightUnits(units):
	var color = Color(1,1,0);
	color.a8 = 90;
	for u in units:
		if (u.lockedForMovement):
			continue;
		Board_Ref.get_node(getHexPath(u.cords)+"/poly").color = color;
		

		
func possibleMovement(cords : Vector2i, offset : Vector2i, saveData = true):
	var continuity = true;
	
	var dest = Vector2i(cords.x+offset.x,cords.y+offset.y);
	if (isOutsideBoard(dest)):
		return false;
	var unitFrom = GameData.COUNTRIES[GameData.PlayerTour].getUnitInCountryAsUnit(cords);
	var unitTo   = MainGame.getUnitOnCell(dest);
	
	if unitTo != null && saveData:
		continuity = false;
		if (unitTo.Country == unitFrom.Country && unitTo.manpower == GameData.ManpowerMax):
			return false; 
	
	if (GameData.BOARD[dest.x][dest.y] == GameData.cellType.CAPITAL ||
		GameData.BOARD[dest.x][dest.y] == GameData.cellType.CITY    ||
		GameData.BOARD[dest.x][dest.y] == GameData.cellType.PORT):
		continuity = false;
	if ((GameData.BOARD[dest.x][dest.y] == GameData.cellType.WATER && 
		GameData.BOARD[cords.x][cords.y] != GameData.cellType.PORT) &&
		GameData.BOARD[cords.x][cords.y] != GameData.cellType.WATER):
		return false;
	if (GameData.BOARD[dest.x][dest.y] == GameData.cellType.WATER):
		if (GameData.BOARD[cords.x][cords.y] != GameData.cellType.WATER):
			continuity = false;
		if (unitTo != null && saveData && unitTo.Country == unitFrom.Country):
			return false;
	if (GameData.BOARD[dest.x][dest.y] == GameData.cellType.EARTH &&
		GameData.BOARD[cords.x][cords.y] == GameData.cellType.WATER):
		continuity = false;
	if (saveData):
		if (possibleMovementData.find(dest) == -1):
			possibleMovementData.push_back(dest);
	else:
		return true;
	return continuity;

func drawPossibleMovement(cords):
	var color = Color(1,1,0);
	color.a8 = 90;;
	if (possibleMovementData.size() == 0):
		getPossibleMovement(cords);
	for x in possibleMovementData:
		Board_Ref.get_node(getHexPath(x)+"/poly").color = color;

func debugColorCords(cords,color):
	Board_Ref.get_node(getHexPath(cords)+"/poly").color = color;

func clearPossibleMovement():
	possibleMovementData = [];

func getPossibleMovement(cords):
	if (cords.x % 2 == 0):
		#ściana 1
		if (possibleMovement(cords, Vector2i(0, -1))):
			possibleMovement(cords, Vector2i(0, -2),Vector2i(0, -1))
			possibleMovement(cords, Vector2i(-1, -2),Vector2i(0, -1));
			possibleMovement(cords, Vector2i(+1, -2),Vector2i(0, -1));
		#ściana 2
		if (possibleMovement(cords, Vector2i(+1, -1))):
			possibleMovement(cords, Vector2i(+1, -2), Vector2i(+1, -1))
			possibleMovement(cords, Vector2i(2, -1), Vector2i(+1, -1));
			possibleMovement(cords, Vector2i(2, 0), Vector2i(+1, -1));
		#sciana 3
		if (possibleMovement(cords, Vector2i(+1, +0))):
			possibleMovement(cords, Vector2i(+2, +0), Vector2i(+1, +0))
			possibleMovement(cords, Vector2i(+2,  1), Vector2i(+1, +0))
			possibleMovement(cords, Vector2i(+1, +1), Vector2i(+1, +0))
		#sciana 4
		if (possibleMovement(cords, Vector2i(0, +1))):
			possibleMovement(cords, Vector2i(0, +2), Vector2i(0, +1))
			possibleMovement(cords, Vector2i(-1, +1), Vector2i(0, +1));
			possibleMovement(cords, Vector2i(+1, +1), Vector2i(0, +1));
		#sciana 5
		if (possibleMovement(cords, Vector2i(-1, 0))):
			possibleMovement(cords, Vector2i(-1, +1), Vector2i(-1, 0))
			possibleMovement(cords, Vector2i(-2, +0), Vector2i(-1, 0));
			possibleMovement(cords, Vector2i(-2, +1), Vector2i(-1, 0));
		#ściana 6
		if (possibleMovement(cords, Vector2i(-1, -1))):
			possibleMovement(cords, Vector2i(-2, -1), Vector2i(-1, -1))
			possibleMovement(cords, Vector2i(-2, 0), Vector2i(-1, -1));
			possibleMovement(cords, Vector2i(-1, -2), Vector2i(-1, -1));
	else:
		#ściana 1
		if (possibleMovement(cords, Vector2i(0, -1))):
			possibleMovement(cords, Vector2i(0, -2), Vector2i(0, -1))
			possibleMovement(cords, Vector2i(-1, -1), Vector2i(0, -1));
			possibleMovement(cords, Vector2i(+1, -1), Vector2i(0, -1));
		#ściana 2
		if (possibleMovement(cords, Vector2i(+1, 0))):
			possibleMovement(cords, Vector2i(+1, -1), Vector2i(+1, 0))
			possibleMovement(cords, Vector2i(2, -1), Vector2i(+1, 0));
			possibleMovement(cords, Vector2i(2, 0), Vector2i(+1, 0));
		#sciana 3
		if (possibleMovement(cords, Vector2i(+1, +1))):
			possibleMovement(cords, Vector2i(+2, +0), Vector2i(+1, +1))
			possibleMovement(cords, Vector2i(+2,  1), Vector2i(+1, +1))
			possibleMovement(cords, Vector2i(+1, +2), Vector2i(+1, +1))
		#sciana 4
		if (possibleMovement(cords, Vector2i(0, +1))):
			possibleMovement(cords, Vector2i(0, +2), Vector2i(0, +1))
			possibleMovement(cords, Vector2i(-1, +2), Vector2i(0, +1));
			possibleMovement(cords, Vector2i(+1, +2), Vector2i(0, +1));
		#sciana 5
		if (possibleMovement(cords, Vector2i(-1, +1))):
			possibleMovement(cords, Vector2i(-1, +2), Vector2i(-1, +1))
			possibleMovement(cords, Vector2i(-2, +0), Vector2i(-1, +1));
			possibleMovement(cords, Vector2i(-2, +1), Vector2i(-1, +1));
		#ściana 6
		if (possibleMovement(cords, Vector2i(-1, 0))):
			possibleMovement(cords, Vector2i(-2, -1), Vector2i(-1, 0))
			possibleMovement(cords, Vector2i(-2, 0), Vector2i(-1, 0));
			possibleMovement(cords, Vector2i(-1, -1), Vector2i(-1, 0));

func isCapCitiPort(cords : Vector2i):
	if (GameData.cellType.PORT    == GameData.BOARD[cords.x][cords.y] ||
		GameData.cellType.CITY    == GameData.BOARD[cords.x][cords.y] ||
		GameData.cellType.CAPITAL == GameData.BOARD[cords.x][cords.y]):
		return true;
	return false;

func isUnitOnWater(unit):
	if (GameData.BOARD[unit.cords.x][unit.cords.y] == GameData.cellType.WATER):
		return true;
	return false;

func conquareEvent(conqueror, looser):
	var color = GameData.CountriesColors[conqueror];
	color.a8 = 90
	for x in range(LAND_CLAIM.size()):
		for y in range(LAND_CLAIM[x].size()):
			if (LAND_CLAIM[x][y] == looser):
				LAND_CLAIM[x][y] = conqueror;
				Board_Ref.get_node(getHexPath(Vector2i(x,y))+"/poly").color = color;

func EXPLOSION_AT(cords):
	if (!MainGame.globalVar.ExplosionAnimation): 
		return;
	var instOfExp = GameData.explosion.instantiate();
	instOfExp.position = getPositionFromHexPosition(cords);
	instOfExp.setSasSound(MainGame.globalVar.sesActive);
	print(MainGame.globalVar.sesActive)
	Board_Ref.get_node("SuperBorder/Graphic/Explosion").add_child(instOfExp);

func claimLand(unit, ignoreUrban = false):
	if (isUnitOnWater(unit)):
		return;
	var landClamed = 0;
	var color = unit.color;
	color.a8 = 90;
	for xx in range(-1,2):
		for yy in range(-1,2):
			if (unit.cords.x % 2 == 1):
				if ((xx == -1 || xx == 1) && yy == -1): continue;
			else:
				if ((xx == -1 || xx == 1) && yy == 1): continue;
			var cord = unit.cords;
			cord.x += xx;
			cord.y += yy;
			if (isOutsideBoard(cord)):
				continue;
			if (LAND_CLAIM[cord.x][cord.y] == unit.Country):
				continue;
			if (xx == 0 && yy == 0):
				Board_Ref.get_node(getHexPath(cord)+"/poly").color = color;
				LAND_CLAIM[cord.x][cord.y] = unit.Country;
				landClamed += 1;
			if (MainGame.getUnitOnCell(cord) != null):
				continue;
			if ((GameData.cellType.WATER   != GameData.BOARD[cord.x][cord.y] &&
				!isCapCitiPort(cord)) || ignoreUrban):
				Board_Ref.get_node(getHexPath(cord)+"/poly").color = color;
				LAND_CLAIM[cord.x][cord.y] = unit.Country
				landClamed += 1;
	unit.morale += landClamed;

func newUnit(unit):
	var unitType = getUnitType(unit.manpower, unit.cords)
	var unitSprite = unit.get_node("texture")
	unitSprite.texture = load(getUnitSprite(unitType));
	unit.position = getPositionFromHexPosition(unit.cords);
	unitSprite.scale = Vector2(UnitsScale[unitType],UnitsScale[unitType]);
	unitSprite.modulate = unit.color;
	unit.name = "unit"+str(unit.unit_id)
	unit.type = unitType;
	Board_Ref.get_node("SuperBorder/Graphic/Solders").add_child(unit);
	unit.unitBoardRef = Board_Ref.get_node("SuperBorder/Graphic/Solders/"+str("unit"+str(unit.unit_id)));
	unit.unitBoardRef.get_node("poly2").visible = Interface.isUnitDataVisible
	claimLand(unit);
	moveIconToCorner(unit.cords);

func changeUnitType(unit, type):
	unit.unitBoardRef.get_node("texture").texture = load(getUnitSprite(type));
	unit.unitBoardRef.get_node("texture").scale = Vector2(UnitsScale[type],UnitsScale[type]);
	unit.type = type;

func assureUnitCorrectType(unit):
	var unitType =getUnitType(unit.manpower, unit.cords);	
	if (unitType != unit.type):
		changeUnitType(unit, unitType);

signal MoveDone;

func moveDoneOperator(unit):
	emit_signal("MoveDone");
	unit.disconnect("moveDone", moveDoneOperator)
	

func moveUnit(unit):
	unit.connect("moveDone", moveDoneOperator)
	unit.moveUnitSmooth(unit.unitBoardRef.position, getPositionFromHexPosition(unit.cords), GameData.UNIT_SPEED);
	assureUnitCorrectType(unit)
	claimLand(unit)
	
	

func DrawCityTexture(cords):
	var sprite = Sprite2D.new();
	sprite.texture = load(City_normal[rng.randi_range(0,5)]);
	sprite.position = getPositionFromHexPosition(cords);
	sprite.scale = Vector2(0.95,0.95)
	sprite.rotation_degrees = randi_range(0,360);
	Board_Ref.get_node("SuperBorder/Graphic/Cities").add_child(sprite);	

func setGrass(cords : Vector2i):
	BOARD[cords.x][cords.y].get_node("poly").color = Color(0,100,0,200)
	
func setWater(cords : Vector2i):
	BOARD[cords.x][cords.y].get_node("poly").color = Color(0,0,255,255)
	var sprite = Sprite2D.new();
	sprite.texture = load(Water[rng.randi_range(0,5)]);
	sprite.position = getPositionFromHexPosition(cords);
	sprite.scale = Vector2(0.95,0.95)
	Board_Ref.get_node("SuperBorder/Graphic/Water").add_child(sprite);

func moveIconToCorner(cords: Vector2i):
	if (!isCapCitiPort(cords)):
		return;
	var icon = Board_Ref.get_node(getHexPathColor(cords)+"/icon");
	icon.position.x += 20;
	icon.position.y -= 20;
	
func comebackIconFromCorner(cords: Vector2i):
	if (!isCapCitiPort(cords)):
		return;
	var icon = Board_Ref.get_node(getHexPathColor(cords)+"/icon");
	icon.position.x -= 20;
	icon.position.y += 20;

func getIconPath(iconType, place = null):
	match iconType:
		IconType.CAPITAL:
			if (place == null):
				return null;
			for x in range(4):
				if ((GameData.Capitals[x].x == place.x) && (GameData.Capitals[x].y == place.y)):
					return CapitalIcons[x];
		IconType.PORT:
			return PortIcon
		IconType.CITY:
			return CityIcon

func placeIcon(iconType, place : Vector2i):
	if (iconType == null):
		return false;
	var iconPath = getIconPath(iconType, place);
	var sprite = Sprite2D.new();
	sprite.texture = load(iconPath);
	sprite.name = "icon";
	if (GameData.UnitsOnBoard[place.x][place.y] != null):
		sprite.position.x += 20;
		sprite.position.y -= 20;
	sprite.z_index = 50;
	
	sprite.scale = Vector2(IconScale[iconType],IconScale[iconType]);
	Board_Ref.get_node(getHexPathColor(place)).add_child(sprite);
	
func cellTypeToIconType(cellType):
	match cellType:
		GameData.cellType.CAPITAL:
			return IconType.CAPITAL;
		GameData.cellType.CITY:
			return IconType.CITY;
		GameData.cellType.PORT:
			return IconType.PORT;
	return null;
	
func setGrassTexture():
	var startingPoint = Board_Ref.position;
	startingPoint.x -= 160;
	startingPoint.y -= 140;
	for x in range(0,20):
		for y in range(0,9):
			var sprite = Sprite2D.new();
			sprite.texture = load(Land_normal[rng.randi_range(0,5)]);
			sprite.position = Vector2i(x*80+startingPoint.x, y*80+startingPoint.y);
			
			sprite.rotation_degrees = randi_range(0,360);
			Board_Ref.get_node("SuperBorder/Graphic/Filds").add_child(sprite);


func drawEveryThing():
	landTextureIndex = [];	
	for x in range(GameData.BOARD_SIZE.x):
		for y in range(GameData.BOARD_SIZE.y):
			match GameData.BOARD[x][y]:
				GameData.cellType.EARTH:
					setGrass(Vector2i(x,y));
				GameData.cellType.CAPITAL, GameData.cellType.CITY, GameData.cellType.PORT:
					setGrass(Vector2i(x,y));
					placeIcon(cellTypeToIconType(GameData.BOARD[x][y]), Vector2i(x,y));
					DrawCityTexture(Vector2i(x,y));
				GameData.cellType.WATER:
					setWater(Vector2i(x,y));
					
	setGrassTexture();

		
	pass;
