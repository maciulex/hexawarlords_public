GDPC                @	                                                                         T   res://.godot/exported/133200997/export-13b34b254d6bcc6d79c8a712518e6aca-Country.scn \      ~      tٮ?
"sz�c���%    T   res://.godot/exported/133200997/export-292ca7c583a5a67a75e6f4bd048dfd19-hex_grid.scn�f      �0      A�����9�|TD�    X   res://.godot/exported/133200997/export-52da0abab86e6d1a7311a08b23751124-main_game.scn   ��      �      �s�8�&�&�D�FJ�dS    T   res://.godot/exported/133200997/export-a83cf8f48b1cf9ea574e7f03773d7d43-board.scn   ��      �	      9�����^'A��u/��m    P   res://.godot/exported/133200997/export-ba7a3e54b58df59e6a48050ba30edfef-unit.scn �      �      �"!��*m��8��AV    T   res://.godot/exported/133200997/export-d5d70f145d23cf8622885027cca8444b-hexagon.scn  _      �      vz�D���L����    ,   res://.godot/global_script_class_cache.cfg  ��      s      �zG4���4�x�=��    D   res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex��      �      �̛�*$q�*�́        res://.godot/uid_cache.bin   �      �      Hwp�h	���8����       res://board.tscn.remap   �      b       ����`�z�D:�g�       res://icon.svg  `�      �      C��=U���^Qu��U3       res://icon.svg.import   `�      �       w�����A�|�jG{`�       res://main_game.gd  0�      }      .�~�~��f6�S�*       res://main_game.tscn.remap  p�      f       *]���25�<}��."�       res://project.binary��      x      �����6�+�p�0�       res://scripts/GameData.gd           d      _�p>�!c���&��}       res://scripts/MapDrawer.gd  p      �1      �x����됿�ѷ�e�        res://scripts/MapGenerator.gd   0D      �      ����\3m�<�5w�H    $   res://utils/countiries/Country.gd   �S            ��h��` �t�Yʔ    ,   res://utils/countiries/Country.tscn.remap   @�      d       [sM��e�?D3���        res://utils/hexagons/hex_grid.gd e      U      �2��k�i-9�e����    (   res://utils/hexagons/hex_grid.tscn.remap �      e       �o��q�anc�.�        res://utils/hexagons/hexagon.gd �^      �       +��O�����o"B�hu    (   res://utils/hexagons/hexagon.tscn.remap ��      d       ��/ѤG��_}�FO��    $   res://utils/hexagons/row_script.gd  0�      4      ��'�è��*�M=r       res://utils/unit/unit.gdp�      �       ��A�������9І���        res://utils/unit/unit.tscn.remap��      a       �d�0Tg�����    �~4 H0�extends Node2D

enum playerType {PLAYER, AI};

var MainGame_ref;

var PlayersAmount = 4;
var CountriesNames = ["Redrosia", "Blugeria", "Purplestan", "Greendom"];
var CountriesColors =[Color(255,0,0), Color(0,0,255), Color(128,0,128), Color(0,255,0)];

var tour = 0;
var PlayerTour = 0;

var Players : Array = [playerType.PLAYER, playerType.AI,
					   playerType.AI, playerType.AI];
var unitCounter = 0;
#capital, city, port is allways placed on earth
enum cellType {EARTH, WATER, CAPITAL, CITY, PORT}

var BOARD_SIZE : Vector2i = Vector2i(23, 12);
var BOARD : Array = [];

var COUNTRIES = [];

var UnitsOnBoard : Array = [];

var Capitals : Array = [Vector2i(1,1), Vector2i(21,1), 
						Vector2i(1,10), Vector2i(21,10)]

var TownsName : Array = ["Abu Dhabi", "Abuja", "Accra", "Addis Ababa", "Algiers", "Amman", "Amsterdam", "Ankara", "Antananarivo", "Apia", "Ashgabat", "Asmara", "Astana", "Asunción", "Athens",
		  "Baghdad", "Baku", "Bamako", "Bangkok", "Bangui", "Banjul", "Basseterre", "Beijing", "Beirut", "Belgrade", "Belmopan", "Berlin", "Bern", "Bishkek", "Bissau", "Bogotá",
		  "Brasília", "Bratislava", "Brazzaville", "Bridgetown", "Brussels", "Bucharest", "Budapest", "Buenos Aires", "Bujumbura", "Cairo", "Canberra",
		  "Cape Town", "Caracas", "Castries", "Chisinau", "Conakry", "Copenhagen", "Cotonou",
		  "Dakar", "Damascus", "Dhaka", "Dili", "Djibouti", "Dodoma", "Doha", "Dublin", "Dushanbe", "Delhi",
		  "Freetown", "Funafuti", "Gabarone", "Georgetown", "Guatemala City", "Hague", "Hanoi", "Harare", "Havana", "Helsinki", "Honiara", "Hong Kong",
		  "Islamabad", "Jakarta", "Jerusalem", "Kabul", "Kampala", "Kathmandu", "Khartoum", "Kyiv", "Kigali", "Kingston", "Kingstown", "Kinshasa", "Kuala Lumpur", "Kuwait City",
		  "La Paz", "Liberville", "Lilongwe", "Lima", "Lisbon", "Ljubljana", "Lobamba", "Lomé", "London", "Luanda", "Lusaka", "Luxembourg",
		  "Madrid", "Majuro", "Malé", "Managua", "Manama", "Manila", "Maputo", "Maseru", "Mbabane", "Melekeok", "Mexico City", "Minsk", "Mogadishu", "Monaco", "Monrovia", "Montevideo", "Moroni", "Moscow", "Muscat",
		  "Nairobi", "Nassau", "Naypyidaw", "N'Djamena", "New Delhi", "Niamey", "Nicosia", "Nouakchott", "Nuku'alofa", "Nuuk",
		  "Oslo", "Ottawa", "Ouagadougou", "Palikir", "Panama City", "Paramaribo", "Paris", "Phnom Penh", "Podgorica", "Prague", "Praia", "Pretoria", "Pyongyang",
		  "Quito", "Rabat", "Ramallah", "Reykjavík", "Riga", "Riyadh", "Rome", "Roseau",
		  "San José", "San Marino", "San Salvador", "Sanaá", "Santiago", "Santo Domingo", "Sao Tomé", "Sarajevo", "Seoul", "Singapore", "Skopje", "Sofia", "South Tarawa", "St. George's", "St. John's", "Stockholm", "Sucre", "Suva",
		  "Taipei", "Tallinn", "Tashkent", "Tbilisi", "Tegucigalpa", "Teheran", "Thimphu", "Tirana", "Tokyo", "Tripoli", "Tunis", "Ulaanbaatar",
		  "Vaduz", "Valletta", "Victoria", "Vienna", "Vientiane", "Vilnius", "Warsaw", "Washington", "Wellington", "Windhoek", "Yamoussoukro", "Yaoundé", "Yerevan", "Zagreb", "Zielona Góra",
		  "Poznań", "Wrocław", "Gdańsk", "Szczecin", "Łódź", "Białystok", "Toruń", "St. Petersburg", "Turku", "Örebro", "Chengdu",
		  "Wuppertal", "Frankfurt", "Düsseldorf", "Essen", "Duisburg", "Magdeburg", "Bonn", "Brno", "Tours", "Bordeaux", "Nice", "Lyon", "Stara Zagora", "Milan", "Bologna", "Sydney", "Venice", "New York",
		  "Barcelona", "Zaragoza", "Valencia", "Seville", "Graz", "Munich", "Birmingham", "Naples", "Cologne", "Turin", "Marseille", "Leeds", "Kraków", "Palermo", "Genoa",
		  "Stuttgart", "Dortmund", "Rotterdam", "Glasgow", "Málaga", "Bremen", "Sheffield", "Antwerp", "Plovdiv", "Thessaloniki", "Kaunas", "Lublin", "Varna", "Ostrava", "Iaşi", "Katowice",
		  "Cluj-Napoca", "Timişoara", "Constanţa", "Pskov", "Vitebsk", "Arkhangelsk", "Novosibirsk", "Samara", "Omsk", "Chelyabinsk", "Ufa", "Volgograd", "Perm", "Kharkiv", "Odessa", "Donetsk", "Dnipropetrovsk",
		  "Los Angeles", "Chicago", "Houston", "Phoenix", "Philadelphia", "Dallas", "Detroit", "Indianapolis", "San Francisco", "Atlanta", "Austin", "Vermont", "Toronto", "Montreal", "Vancouver", "Gdynia", "Edmonton",]

@export
var waterSourcesTries      : int = 20;
@export
var MinWaterSourcesTries   : int = 7;
@export
var makxWaterSourceSize    : int = 50;
@export
var MinmakxWaterSourceSize : int = 7;

func isPlayerTour():
	if(Players[PlayerTour] == playerType.PLAYER):
		return true;
	return false;

func getUnitUniqueId():
	unitCounter += 1;
	return unitCounter-1;

func _ready():
	for x in range(BOARD_SIZE.x):
		var yRow : Array = [];
		var yRow2 : Array = [];
		for y in range(BOARD_SIZE.y):
			yRow.push_back(null);
			yRow2.push_back(null);
			
		BOARD.push_back(yRow)
		UnitsOnBoard.push_back(yRow2)
i�tެ�H�g|Jextends Node2D

var Board_Ref = null;
var GameData  = null;

var BOARD : Array = [];
var LAND_CLAIM : Array = [];
var refReady : bool = false;

enum IconType    {CAPITAL, CITY, PORT, SOLDER, ALTHIRERY, TANK, MARINE}
var  IconScale = [2.3, 2.5, 1.3, 2, 2, 2, 2];

enum  UnitsType  {SHIP, SOLDER, ALTILERY, TANK};
var  UnitsScale= [0.065, 0.05, 0.04, 0.037];

var hexSize = Vector2i(36,40);

var rng = RandomNumberGenerator.new()

var  landAmount = 35
var  landTextureIndex = [];

var possibleMovementData = [];

var UnitsIcons : Array = [
	"res://images/units/ship.png",
	"res://images/units/solder.png",
	"res://images/units/alitrery.png",
	"res://images/units/tank.png"
];

var CapitalIcons : Array = [
	"res://images/icons/capital_red.png",
	"res://images/icons/capital_blue.png",
	"res://images/icons/capital_violet.png",
	"res://images/icons/capital_green.png"
];

var CityIcon : String = "res://images/icons/city.png";
var PortIcon : String = "res://images/icons/port.png";

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
		return UnitsType.SHIP;
	if (unitStrenght < 40):
		return UnitsType.SOLDER;
	if (unitStrenght < 80):
		return UnitsType.ALTILERY;
	return UnitsType.TANK;
	
func isOutsideBoard(cords : Vector2i):
	if (cords.x < 0 || cords.y < 0 || cords.x >= GameData.BOARD_SIZE.x || cords.y >= GameData.BOARD_SIZE.y):
		return true;
	return false;

func unDrawPossibleMovement():
	for i in possibleMovementData:
		var color;
		if (LAND_CLAIM[i.x][i.y] == null):
			color = Color(0,0,0,0);
		else:
			color = GameData.CountriesColors[LAND_CLAIM[i.x][i.y]];
			color.a8 = 90;
		Board_Ref.get_node(getHexPath(i)+"/poly").color = color;
	
	possibleMovementData = [];

func possibleMovement(cords : Vector2i, offset : Vector2i, parentCords : Vector2i = Vector2i(0, 0)):
	var continuity = true;
	var color = Color(1,1,0);
	color.a8 = 90;;
	
	var dest =Vector2i(cords.x+offset.x,cords.y+offset.y);
	if (isOutsideBoard(dest)):
		return false;
	if (GameData.BOARD[dest.x][dest.y] == GameData.cellType.CAPITAL ||
		GameData.BOARD[dest.x][dest.y] == GameData.cellType.CITY||
		GameData.BOARD[dest.x][dest.y] == GameData.cellType.PORT):
		continuity = false;
	if (GameData.BOARD[dest.x][dest.y] 				 == GameData.cellType.WATER && 
		GameData.BOARD[cords.x][cords.y] != GameData.cellType.PORT):
		return false;
			
	Board_Ref.get_node(getHexPath(dest)+"/poly").color = color;
	if (possibleMovementData.find(dest) == -1):
		possibleMovementData.push_back(dest);
	return continuity;



func drawPossibleMovement(cords):
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

func claimLand(unit, ignoreUrban = false):
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
			if (xx == 0 && yy == 0):
				Board_Ref.get_node(getHexPath(cord)+"/poly").color = color;
				LAND_CLAIM[cord.x][cord.y] = unit.Country;
			if ((GameData.cellType.WATER   != GameData.BOARD[cord.x][cord.y] &&
				!isCapCitiPort(cord)) || ignoreUrban):
				Board_Ref.get_node(getHexPath(cord)+"/poly").color = color;
				LAND_CLAIM[cord.x][cord.y] = unit.Country

func newUnit(unit):
	var unitType = getUnitType(unit.manpower, unit.cords)
	var unitSprite = unit.get_node("texture")
	unitSprite.texture = load(getUnitSprite(unitType));
	unit.position = getPositionFromHexPosition(unit.cords);
	unitSprite.scale = Vector2(UnitsScale[unitType],UnitsScale[unitType]);
	unitSprite.modulate = unit.color;
	unit.name = "unit"+str(unit.unit_id)
	Board_Ref.get_node("SuperBorder/Graphic/Solders").add_child(unit);
	unit.unitBoardRef = Board_Ref.get_node("SuperBorder/Graphic/Solders/"+str("unit"+str(unit.unit_id)));
	claimLand(unit);
	moveIconToCorner(unit.cords);

func moveUnit(unit):
	unit.unitBoardRef.position = getPositionFromHexPosition(unit.cords);
	claimLand(unit)
	
	pass;

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
	icon.position.x += 30;
	icon.position.y -= 30;
	
func comebackIconFromCorner(cords: Vector2i):
	if (!isCapCitiPort(cords)):
		return;
	var icon = Board_Ref.get_node(getHexPathColor(cords)+"/icon");
	icon.position.x -= 30;
	icon.position.y += 30;

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
		sprite.position.x += 30;
		sprite.position.y -= 30;
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
n�$N%�h� V��extends Node2D

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
	print(rng.randf())
	return seedInput;
	
�Ae@extends Node2D

var GameData_ref;
var Drawer_ref;

var Country_name = "";
var Country_id   = 0;
var Country_color= null;

var cities = [];
var units  = [];
var morale = 10;

var unitScene = load("res://utils/unit/unit.tscn")

enum MERGE_TYPE {JOIN, END_OF_ROUND};


func addToUnit(mergeType : MERGE_TYPE, cordsTo : Vector2i, cordsFrom : Vector2i = Vector2i(0,0) ):
	pass;

func getUnitInCountry(cords : Vector2i):
	var c = 0;
	for u in units:
		c+=1;
		if (u.cords.x == cords.x && u.cords.y == cords.y):
			return c-1;
	return 0;

func captureCity(cords : Vector2i):
	print("capture city");
	cities.push_back(cords);
	
func deafeatEnemy(cords : Vector2i):
	pass;
	
func landOwner(cords):
	if (Drawer_ref.LAND_CLAIM[cords.x][cords.y] == Country_id):
		print("Land is ours already")
		return;
	if (GameData_ref.BOARD[cords.x][cords.y] == GameData_ref.cellType.CITY):
		captureCity(cords)
	if (GameData_ref.BOARD[cords.x][cords.y] == GameData_ref.cellType.CAPITAL):
		deafeatEnemy(cords);
		captureCity(cords);
			
func moveUnit(from, to):
	print(from ,to)
	var destUnit = GameData_ref.MainGame_ref.getUnitOnCell(to);
	var fromUnit = getUnitInCountry(from);
	if (destUnit == null):
		landOwner(to);
		Drawer_ref.comebackIconFromCorner(units[fromUnit].cords)
		units[fromUnit].cords = to;
		Drawer_ref.moveUnit(units[fromUnit]);
		Drawer_ref.moveIconToCorner(units[fromUnit].cords)

		
func createUnit(pos : Vector2i):
	var unit = unitScene.instantiate();
	unit.unit_id  = GameData_ref.getUnitUniqueId();
	unit.Country  = Country_id;
	unit.manpower = 20;
	unit.morale   = morale;
	unit.cords    = pos;
	unit.color    = Country_color;
	
	units.push_back(unit);
	Drawer_ref.newUnit(unit);
	
func isUnitOn(pos : Vector2i):
	for i in units:
		if (units[i].Cords.x == pos.x && units[i].Cords.y == pos.y):
			return true;
	return false;

func end_tour():
	for citi in cities:
		if (isUnitOn(citi)):
			addToUnit(MERGE_TYPE.END_OF_ROUND, citi);
		else:
			createUnit(citi)
			
func prepareToGame():
	for citi in cities:
		createUnit(citi);
		Drawer_ref.claimLand(units[0], true);		
(#��ӹ��RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script "   res://utils/countiries/Country.gd ��������      local://PackedScene_h6yna          PackedScene          	         names "         Country    script    Node2D    	   variants                       node_count             nodes     	   ��������       ����                    conn_count              conns               node_paths              editable_instances              version             RSRC�extends Node2D

signal nodeClicked;
var nodeId = 0;

func _on_touch_screen_button_pressed():
	emit_signal("nodeClicked", nodeId)
0� ����ҌF�}��RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name    custom_solver_bias    points    script 	   _bundled       Script     res://utils/hexagons/hexagon.gd ��������   #   local://ConvexPolygonShape2D_ogp3d h         local://PackedScene_uq8np �         ConvexPolygonShape2D       %        �B   B   B  �B   �  �B   �   B   �   �   B   �         PackedScene          	         names "         hexagon    scale    script    metadata/_edit_lock_    Node2D    poly 	   position    color    polygon 
   Polygon2D    Border    points    width    default_color    Line2D    TouchScreenButton    z_index    shape     _on_touch_screen_button_pressed    pressed    	   variants       
      ?   ?                
     ��   �     �?  �?  �?    %        �B   B   B  �B   �  �B   �   B   �   �   B   �
      A   B%        $�  ��   �   A  �A   A   B   �  �A  ��   �  ��  `�   �  $�  ��      @     �?  �?  �?���>   �                  node_count             nodes     :   ��������       ����                                  	      ����                                          
   ����                        	                           ����      
                         conn_count             conns                                      node_paths              editable_instances              version             RSRCy��B�v��h>extends Node2D


signal nodeInBoardClicked;

func activateSignalListnig():
	var counter = 0;
	for _child in self.get_children():
		_child.rowId = counter;
		_child.activateSignalListnig();
		counter += 1; 
		_child.connect("nodeInRowClicked", onNodeClick);
	
func onNodeClick(rowId,id):
	emit_signal("nodeInBoardClicked", rowId, id);
	pass;
�`�ۡ����RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script !   res://utils/hexagons/hex_grid.gd ��������   Script #   res://utils/hexagons/row_script.gd ��������   PackedScene "   res://utils/hexagons/hexagon.tscn ɪ�[�      local://PackedScene_amqvd �         PackedScene          	         names "   '      hexGrid 	   position    script    Node2D    x0    hexagon 	   hexagon2 	   hexagon3 	   hexagon4 	   hexagon5 	   hexagon6 	   hexagon7 	   hexagon8 	   hexagon9 
   hexagon10 
   hexagon11 
   hexagon12    x1    x2    x3    x4    x5    x6    x7    x8    x9    x10    x11    x12    x13    x14    x15    x16    x17    x18    x19    x20    x21    x22    	   variants    1   
     �A  �A                            
          B
         �B
         �B
          C
         HC
         pC
         �C
         �C
         �C
         �C
         �C
     B    
         �A
         pB
         �B
         C
         4C
         \C
         �C
         �C
         �C
         �C
         �C
         �C
     �B    
     �B  �A
     C    
     4C  �A
     XC    
     |C  �A
     �C    
     �C  �A
     �C    
     �C  �A
     �C    
     �C  �A
     �C    
     D  �A
     D    
     D  �A
     "D    
     +D  �A
     4D    
     =D  �A
     FD          node_count    ,        nodes     �
  ��������       ����                                  ����                    ���                     ���                          ���                          ���                          ���	                          ���
                          ���            	              ���            
              ���                          ���                          ���                          ���                                 ����                          ���                          ���                          ���                          ���                          ���	                          ���
                          ���                          ���                          ���                          ���                          ���                          ���                                 ����                          ���                     ���                          ���                          ���                          ���	                          ���
                          ���            	              ���            
              ���                          ���                          ���                          ���                                 ����                   (       ���              (       ���                   (       ���                   (       ���                   (       ���	                   (       ���
                   (       ���            	       (       ���            
       (       ���                   (       ���                   (       ���                   (       ���                                 ����                   5       ���              5       ���                   5       ���                   5       ���                   5       ���	                   5       ���
                   5       ���            	       5       ���            
       5       ���                   5       ���                   5       ���                   5       ���                                 ����                   B       ���              B       ���                   B       ���                   B       ���                   B       ���	                   B       ���
                   B       ���            	       B       ���            
       B       ���                   B       ���                   B       ���                   B       ���                                 ����                    O       ���              O       ���                   O       ���                   O       ���                   O       ���	                   O       ���
                   O       ���            	       O       ���            
       O       ���                   O       ���                   O       ���                   O       ���                                 ����      !             \       ���              \       ���                   \       ���                   \       ���                   \       ���	                   \       ���
                   \       ���            	       \       ���            
       \       ���                   \       ���                   \       ���                   \       ���                                 ����      "             i       ���              i       ���                   i       ���                   i       ���                   i       ���	                   i       ���
                   i       ���            	       i       ���            
       i       ���                   i       ���                   i       ���                   i       ���                                 ����      #             v       ���              v       ���                   v       ���                   v       ���                   v       ���	                   v       ���
                   v       ���            	       v       ���            
       v       ���                   v       ���                   v       ���                   v       ���                                 ����      $             �       ���              �       ���                   �       ���                   �       ���                   �       ���	                   �       ���
                   �       ���            	       �       ���            
       �       ���                   �       ���                   �       ���                   �       ���                                 ����      %             �       ���              �       ���                   �       ���                   �       ���                   �       ���	                   �       ���
                   �       ���            	       �       ���            
       �       ���                   �       ���                   �       ���                   �       ���                                 ����      &             �       ���              �       ���                   �       ���                   �       ���                   �       ���	                   �       ���
                   �       ���            	       �       ���            
       �       ���                   �       ���                   �       ���                   �       ���                                 ����      '             �       ���              �       ���                   �       ���                   �       ���                   �       ���	                   �       ���
                   �       ���            	       �       ���            
       �       ���                   �       ���                   �       ���                   �       ���                                 ����      (             �       ���              �       ���                   �       ���                   �       ���                   �       ���	                   �       ���
                   �       ���            	       �       ���            
       �       ���                   �       ���                   �       ���                   �       ���                                 ����      )             �       ���              �       ���                   �       ���                   �       ���                   �       ���	                   �       ���
                   �       ���            	       �       ���            
       �       ���                   �       ���                   �       ���                   �       ���                                  ����      *             �       ���              �       ���                   �       ���                   �       ���                   �       ���	                   �       ���
                   �       ���            	       �       ���            
       �       ���                   �       ���                   �       ���                   �       ���                              !   ����      +             �       ���              �       ���                   �       ���                   �       ���                   �       ���	                   �       ���
                   �       ���            	       �       ���            
       �       ���                   �       ���                   �       ���                   �       ���                              "   ����      ,             �       ���              �       ���                   �       ���                   �       ���                   �       ���	                   �       ���
                   �       ���            	       �       ���            
       �       ���                   �       ���                   �       ���                   �       ���                              #   ����      -             �       ���              �       ���                   �       ���                   �       ���                   �       ���	                   �       ���
                   �       ���            	       �       ���            
       �       ���                   �       ���                   �       ���                   �       ���                              $   ����      .                   ���                    ���                         ���                         ���                         ���	                         ���
                         ���            	             ���            
             ���                         ���                         ���                         ���                              %   ����      /                   ���                    ���                         ���                         ���                         ���	                         ���
                         ���            	             ���            
             ���                         ���                         ���                         ���                              &   ����      0                   ���                    ���                         ���                         ���                         ���	                         ���
                         ���            	             ���            
             ���                         ���                         ���                         ���                         conn_count              conns               node_paths              editable_instances              version             RSRC�6`Jפ���2xn&extends Node2D

signal nodeInRowClicked;

var rowId = 0;

func activateSignalListnig():
	var counter = 0;
	for _child in self.get_children():
		_child.nodeId = counter;
		counter += 1; 
		_child.connect("nodeClicked", onNodeClick);
	
func onNodeClick(id):
	emit_signal("nodeInRowClicked", rowId, id);
	pass;
u�[�8�*����extends Node2D

var unit_id;
var Country = 0;
var morale  = 0;
var manpower= 0;
var cords: Vector2i;
var color: Color;
var unitBoardRef;
���kRSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script    res://utils/unit/unit.gd ��������      local://PackedScene_mvmrn          PackedScene          	         names "         unit    script    Node2D    texture 	   Sprite2D    	   variants                       node_count             nodes        ��������       ����                            ����              conn_count              conns               node_paths              editable_instances              version             RSRC��\��PRSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       PackedScene #   res://utils/hexagons/hex_grid.tscn ��W���X      local://PackedScene_le1xn          PackedScene          	         names "         Board 	   position    metadata/_edit_lock_    Node2D    SuperBorder    clip_children    z_index    z_as_relative    polygon 
   Polygon2D    Icons    hexGrid    Graphic    hexGridColors    Filds    Cities    Water    Solders    	   variants       
     ��                   2          
     (�   A%   �     XB   �  (B   A  XB  �A  (B  HB  XB  �B  (B  �B  XB  �B  (B  C  XB  C  (B  *C  XB  >C  (B  RC  XB  fC  (B  zC  XB  �C  (B  �C  XB  �C  (B  �C  XB  �C  (B  �C  XB  �C  (B  �C  XB  �C  (B  �C  XB  �C  �B  �C  �B  �C  �B  �C  �B  �C  C  �C  "C  �C  :C  �C  FC  �C  ^C  �C  jC  �C  �C  �C  �C  �C  �C  �C  �C  �C  �C  �C  �C  �C  �C  �C  �C  �C  �C  �C  �C  �C  �C  �C  �C  �C  �C  �C  �C  �C  �C  �C �D  �C �D  �C �D  �C �D  �C �D  �C �D  �C �D  �C �#D  �C �&D  �C �,D  �C �/D  �C �5D  �C �8D  �C �>D  �C �AD  �C �GD  �C �JD  �C �PD  �C �SD  �C �YD  �C �\D  �C �YD  �C �\D  �C �YD  �C �\D  �C �YD  �C �\D  �C �YD  �C �\D  �C �YD  �C �\D  zC �YD  fC �\D  RC �YD  >C �\D  *C �YD  C �\D  C �YD  �B �\D  �B �YD  �B �\D  HB �YD  �A �\D   A �YD   � �SD   � �PD   A �JD   A �GD   � �AD   � �>D   A �8D   A �5D   � �/D   � �,D   A �&D   A �#D   � �D   � �D   A �D   A �D   � �D   � �D   A �D   A  �C   �  �C   �  �C   A  �C   A  �C   �  �C   �  �C   A  �C   A  �C   �  �C   �  �C   A  �C   A  �C   �  �C   �  �C   A  jC   A  ^C   �  FC   �  :C   A  "C   A  C   �  �B   �  �B   A  �B   A  �B   �      
     �B   A             
   
              �        node_count    
         nodes     t   ��������       ����                            	      ����                                                     
   ����                                ���   	         
                                ����                          ���   	                             ����                          ����                          ����                          ����                               conn_count              conns               node_paths              editable_instances              version             RSRC_���y���O��qGST2   �   �      ����               � �        �  RIFF�  WEBPVP8L�  /������!"2�H�$�n윦���z�x����դ�<����q����F��Z��?&,
ScI_L �;����In#Y��0�p~��Z��m[��N����R,��#"� )���d��mG�������ڶ�$�ʹ���۶�=���mϬm۶mc�9��z��T��7�m+�}�����v��ح�m�m������$$P�����එ#���=�]��SnA�VhE��*JG�
&����^x��&�+���2ε�L2�@��		��S�2A�/E���d"?���Dh�+Z�@:�Gk�FbWd�\�C�Ӷg�g�k��Vo��<c{��4�;M�,5��ٜ2�Ζ�yO�S����qZ0��s���r?I��ѷE{�4�Ζ�i� xK�U��F�Z�y�SL�)���旵�V[�-�1Z�-�1���z�Q�>�tH�0��:[RGň6�=KVv�X�6�L;�N\���J���/0u���_��U��]���ǫ)�9��������!�&�?W�VfY�2���༏��2kSi����1!��z+�F�j=�R�O�{�
ۇ�P-�������\����y;�[ ���lm�F2K�ޱ|��S��d)é�r�BTZ)e�� ��֩A�2�����X�X'�e1߬���p��-�-f�E�ˊU	^�����T�ZT�m�*a|	׫�:V���G�r+�/�T��@U�N׼�h�+	*�*sN1e�,e���nbJL<����"g=O��AL�WO!��߈Q���,ɉ'���lzJ���Q����t��9�F���A��g�B-����G�f|��x��5�'+��O��y��������F��2�����R�q�):VtI���/ʎ�UfěĲr'�g�g����5�t�ۛ�F���S�j1p�)�JD̻�ZR���Pq�r/jt�/sO�C�u����i�y�K�(Q��7őA�2���R�ͥ+lgzJ~��,eA��.���k�eQ�,l'Ɨ�2�,eaS��S�ԟe)��x��ood�d)����h��ZZ��`z�պ��;�Cr�rpi&��՜�Pf��+���:w��b�DUeZ��ڡ��iA>IN>���܋�b�O<�A���)�R�4��8+��k�Jpey��.���7ryc�!��M�a���v_��/�����'��t5`=��~	`�����p\�u����*>:|ٻ@�G�����wƝ�����K5�NZal������LH�]I'�^���+@q(�q2q+�g�}�o�����S߈:�R�݉C������?�1�.��
�ڈL�Fb%ħA ����Q���2�͍J]_�� A��Fb�����ݏ�4o��'2��F�  ڹ���W�L |����YK5�-�E�n�K�|�ɭvD=��p!V3gS��`�p|r�l	F�4�1{�V'&����|pj� ߫'ş�pdT�7`&�
�1g�����@D�˅ �x?)~83+	p �3W�w��j"�� '�J��CM�+ �Ĝ��"���4� ����nΟ	�0C���q'�&5.��z@�S1l5Z��]�~L�L"�"�VS��8w.����H�B|���K(�}
r%Vk$f�����8�ڹ���R�dϝx/@�_�k'�8���E���r��D���K�z3�^���Vw��ZEl%~�Vc���R� �Xk[�3��B��Ğ�Y��A`_��fa��D{������ @ ��dg�������Mƚ�R�`���s����>x=�����	`��s���H���/ū�R�U�g�r���/����n�;�SSup`�S��6��u���⟦;Z�AN3�|�oh�9f�Pg�����^��g�t����x��)Oq�Q�My55jF����t9����,�z�Z�����2��#�)���"�u���}'�*�>�����ǯ[����82һ�n���0�<v�ݑa}.+n��'����W:4TY�����P�ר���Cȫۿ�Ϗ��?����Ӣ�K�|y�@suyo�<�����{��x}~�����~�AN]�q�9ޝ�GG�����[�L}~�`�f%4�R!1�no���������v!�G����Qw��m���"F!9�vٿü�|j�����*��{Ew[Á��������u.+�<���awͮ�ӓ�Q �:�Vd�5*��p�ioaE��,�LjP��	a�/�˰!{g:���3`=`]�2��y`�"��N�N�p���� ��3�Z��䏔��9"�ʞ l�zP�G�ߙj��V�>���n�/��׷�G��[���\��T��Ͷh���ag?1��O��6{s{����!�1�Y�����91Qry��=����y=�ٮh;�����[�tDV5�chȃ��v�G ��T/'XX���~Q�7��+[�e��Ti@j��)��9��J�hJV�#�jk�A�1�^6���=<ԧg�B�*o�߯.��/�>W[M���I�o?V���s��|yu�xt��]�].��Yyx�w���`��C���pH��tu�w�J��#Ef�Y݆v�f5�e��8��=�٢�e��W��M9J�u�}]釧7k���:�o�����Ç����ս�r3W���7k���e�������ϛk��Ϳ�_��lu�۹�g�w��~�ߗ�/��ݩ�-�->�I�͒���A�	���ߥζ,�}�3�UbY?�Ӓ�7q�Db����>~8�]
� ^n׹�[�o���Z-�ǫ�N;U���E4=eȢ�vk��Z�Y�j���k�j1�/eȢK��J�9|�,UX65]W����lQ-�"`�C�.~8ek�{Xy���d��<��Gf�ō�E�Ӗ�T� �g��Y�*��.͊e��"�]�d������h��ڠ����c�qV�ǷN��6�z���kD�6�L;�N\���Y�����
�O�ʨ1*]a�SN�=	fH�JN�9%'�S<C:��:`�s��~��jKEU�#i����$�K�TQD���G0H�=�� �d�-Q�H�4�5��L�r?����}��B+��,Q�yO�H�jD�4d�����0*�]�	~�ӎ�.�"����%
��d$"5zxA:�U��H���H%jس{���kW��)�	8J��v�}�rK�F�@�t)FXu����G'.X�8�KH;���[ �t�����qh��[remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://byyl0polyf331"
path="res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex"
metadata={
"vram_texture": false
}
 �GǼ�z;��^�IVzextends Node2D

@onready
var GameData    : Node2D  = $Scripts/GameData;
@onready
var MapGenerator: Node2D = $Scripts/MapGenerator;
@onready
var MapDrawer   : Node2D = $Scripts/MapDrawer;
@onready
var Board       : Node2D  = $Board;

var possibleMovementDrawn = false;
var possibleMovementDrawnFrom = Vector2i(0,0);
func _ready():
	GameData.MainGame_ref = self;
	
	MapGenerator.getGameDataRef(GameData);
	MapGenerator.generateWorld();
	
	MapDrawer.setGameDataReference(GameData);
	MapDrawer.setBoardReference(Board);
	MapDrawer.getBoard();
	MapDrawer.drawEveryThing();
	
	
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
		ct.prepareToGame();
		GameData.COUNTRIES.push_back(ct);
		$Countries.add_child(ct);

func getUnitOnCell(cords):
	for c in GameData.COUNTRIES:
		for u in c.units:
			if (u.cords.x == cords.x && u.cords.y == cords.y):
				return u;
	return null;

func isInPossibleMovement(cords):
	if (MapDrawer.possibleMovementData.find(cords) == -1):
		return false;
	return true;
	
func userInputOnBoard(x,y):
	if !GameData.isPlayerTour():
		return;
		
	if (isInPossibleMovement(Vector2i(x,y))):
		GameData.COUNTRIES[GameData.PlayerTour].moveUnit(possibleMovementDrawnFrom, Vector2i(x,y));
		MapDrawer.unDrawPossibleMovement();
		possibleMovementDrawn = false;
		return;
		
	if (possibleMovementDrawn):
		MapDrawer.unDrawPossibleMovement();
		possibleMovementDrawn = false;
	
	var unitOnCell = getUnitOnCell(Vector2i(x,y));
	if (unitOnCell == null):
		return;
	
	if (unitOnCell.Country != GameData.PlayerTour):
		return;
	
	possibleMovementDrawnFrom = Vector2i(x,y);
	MapDrawer.drawPossibleMovement(possibleMovementDrawnFrom);
	possibleMovementDrawn = true;


func _process(delta):
	pass;
�\RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script    res://main_game.gd ��������   PackedScene    res://board.tscn a�ϗ#   Script    res://scripts/MapGenerator.gd ��������   Script    res://scripts/MapDrawer.gd ��������   Script    res://scripts/GameData.gd ��������      local://PackedScene_ysawi �         PackedScene          	         names "      	   MainGame    scale    script    Node2D    Board 	   position 
   Countries    Scripts    MapGenerator 
   MapDrawer 	   GameData    SuperRectangle    z_index    color    polygon 
   Polygon2D    	   variants       
   ���?���?                   
   ?�C  C
     �?  �?                              ���                 �?%      ?Ux�  �� �w�q��DH}
E ИDH�
EZU��      node_count             nodes     L   ��������       ����                            ���                                       ����                      ����                     ����                       	   ����                       
   ����                           ����            	      
             conn_count              conns               node_paths              editable_instances              version             RSRCn�x]Ё���[remap]

path="res://.godot/exported/133200997/export-13b34b254d6bcc6d79c8a712518e6aca-Country.scn"
�񵨆�3�e[remap]

path="res://.godot/exported/133200997/export-d5d70f145d23cf8622885027cca8444b-hexagon.scn"
E)��f�{�����[remap]

path="res://.godot/exported/133200997/export-292ca7c583a5a67a75e6f4bd048dfd19-hex_grid.scn"
l�"�p�n	��[remap]

path="res://.godot/exported/133200997/export-ba7a3e54b58df59e6a48050ba30edfef-unit.scn"
�o�-�O34\:��k[remap]

path="res://.godot/exported/133200997/export-a83cf8f48b1cf9ea574e7f03773d7d43-board.scn"
,�Di�p��p��[remap]

path="res://.godot/exported/133200997/export-52da0abab86e6d1a7311a08b23751124-main_game.scn"
U��3镮9list=Array[Dictionary]([{
"base": &"Object",
"class": &"SignalConnection",
"icon": "",
"language": &"GDScript",
"path": "res://addons/SignalVisualizer/signal_connection.gd"
}, {
"base": &"Object",
"class": &"SignalDescription",
"icon": "",
"language": &"GDScript",
"path": "res://addons/SignalVisualizer/signal_description.gd"
}, {
"base": &"Object",
"class": &"SignalGraph",
"icon": "",
"language": &"GDScript",
"path": "res://addons/SignalVisualizer/signal_graph.gd"
}, {
"base": &"GraphNode",
"class": &"SignalGraphNode",
"icon": "",
"language": &"GDScript",
"path": "res://addons/SignalVisualizer/signal_graph_node.gd"
}])
6�}~_���o�4E<svg height="128" width="128" xmlns="http://www.w3.org/2000/svg"><rect x="2" y="2" width="124" height="124" rx="14" fill="#363d52" stroke="#212532" stroke-width="4"/><g transform="scale(.101) translate(122 122)"><g fill="#fff"><path d="M105 673v33q407 354 814 0v-33z"/><path fill="#478cbf" d="m105 673 152 14q12 1 15 14l4 67 132 10 8-61q2-11 15-15h162q13 4 15 15l8 61 132-10 4-67q3-13 15-14l152-14V427q30-39 56-81-35-59-83-108-43 20-82 47-40-37-88-64 7-51 8-102-59-28-123-42-26 43-46 89-49-7-98 0-20-46-46-89-64 14-123 42 1 51 8 102-48 27-88 64-39-27-82-47-48 49-83 108 26 42 56 81zm0 33v39c0 276 813 276 813 0v-39l-134 12-5 69q-2 10-14 13l-162 11q-12 0-16-11l-10-65H447l-10 65q-4 11-16 11l-162-11q-12-3-14-13l-5-69z"/><path d="M483 600c3 34 55 34 58 0v-86c-3-34-55-34-58 0z"/><circle cx="725" cy="526" r="90"/><circle cx="299" cy="526" r="90"/></g><g fill="#414042"><circle cx="307" cy="532" r="60"/><circle cx="717" cy="532" r="60"/></g></g></svg>
]s�\k�2�6   ��L��F#   res://images/icons/capital_blue.png���y�f�/$   res://images/icons/capital_green.pngi�Ty�m�A"   res://images/icons/capital_red.png�[� �Ji%   res://images/icons/capital_violet.png�[�M��    res://images/icons/city.pngJjs��   res://images/icons/port.pngP��F�2   res://images/land/ld_1.png��	^Өq   res://images/land/ld_2.png�S�ΆU�_   res://images/land/ld_3.png�Ɩ&;&p   res://images/land/ld_4.png/x�d�o   res://images/land/ld_5.png���Ǐs+   res://images/land/ld_6.png��N�N;\   res://images/land/l_1.png��mK��H   res://images/land/l_2.png8վ��z   res://images/land/l_3.pngG��4�5v   res://images/land/l_4.png�����   res://images/land/l_5.pngҀ���8_   res://images/land/l_6.png^̞Oߛ�_<   res://images/units/kop/kop2/alitrery — kopia — kopia.png�Lxc�;F   res://images/units/alitrery.png^�gq��   res://images/units/ship.png�%�8H��Z   res://images/units/solder.png5p�KY��u   res://images/units/tank.pngd6�{�-#   res://images/units/kop/alitrery.png,�oJ��t   res://images/urban/cd_1.pngY7�Vs-u   res://images/urban/cd_2.png望���V   res://images/urban/cd_3.pngq͐
�r@   res://images/urban/cd_4.png���^�@   res://images/urban/cd_5.png7\�Nu�   res://images/urban/cd_6.png!�U�	�:   res://images/urban/c_1.pngU���}j4   res://images/urban/c_2.png�o}��:
   res://images/urban/c_3.png���.]7   res://images/urban/c_4.png�qr�g�b   res://images/urban/c_5.png��ġo�X1   res://images/urban/c_6.png�9
�7t�J   res://images/water/m_1.pngZ���,   res://images/water/m_2.pngģ��ţ�0   res://images/water/m_3.pngt|H{���F   res://images/water/m_4.png�[a�J?"u   res://images/water/m_5.png(���5Q�L   res://images/water/m_6.png��_��C   res://images/water/m_p1.pngm����O   res://images/water/m_p2.png����J�A#   res://utils/countiries/Country.tscnɪ�[�!   res://utils/hexagons/hexagon.tscn��W���X"   res://utils/hexagons/hex_grid.tscn���Q��8   res://utils/unit/unit.tscna�ϗ#   res://board.tscn��O��{19   res://icon.svg�����   res://main_game.tscn�6[�tD70   res://addons/SignalVisualizer/icons8-play-50.pngq��?�q�R4   res://addons/SignalVisualizer/signal_graph_node.tscn��mPfr9   res://addons/SignalVisualizer/signal_visualizer_dock.tscn��aʈ�Ǆ}}i�2ECFG      application/config/name      	   hexEmpire      application/run/main_scene         res://main_game.tscn   application/config/features   "         4.1    Mobile     application/config/icon         res://icon.svg  "   display/window/size/viewport_width      �  #   display/window/size/viewport_height      8     display/window/stretch/mode         viewport#   display/window/handheld/orientation         /   input_devices/pointing/emulate_touch_from_mouse         #   rendering/renderer/rendering_method         mobile  4   rendering/textures/vram_compression/import_etc2_astc         �R�)O