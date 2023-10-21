extends Node2D

enum playerType {PLAYER, AI};
enum playerStatus{ALIVE, DEAD}
enum ai_models {PRIMITIVE, MODERATE};
enum UNIT_SPEED_VALUE {SLOW = 1, NORMAL = 2, FAST = 3, ULTRA = 4}

var MainGame_ref;
var Interface_ref;

var activeAI_model : ai_models = ai_models.PRIMITIVE
var ai_models_display_name = ["PRIMITIVE"]
var PlayersAmount : int = 4;
var CountriesNames = ["Redrosia", "Blugeria", "Purplestan", "Greendom"];
var CountriesColors =[Color(255,0,0), Color(0,0,255), Color(128,0,128), Color(0,255,0)];

var ManpowerMax : int = 99;
var UNIT_SPEED : UNIT_SPEED_VALUE = UNIT_SPEED_VALUE.FAST;

var GameComeToEnd = false;
var tour = 0;
var PlayerTour = 0;
var movesPerTour = 5;
var BlockMovement = false;
var Players : Array = [playerType.AI, playerType.AI,
					   playerType.AI, playerType.AI];
			
var PlayersStatus : Array = [playerStatus.ALIVE,playerStatus.ALIVE,
							 playerStatus.ALIVE,playerStatus.ALIVE];

var unitCounter = 0;
#capital, city, port is allways placed on earth
enum cellType {EARTH, WATER, CAPITAL, CITY, PORT}

var BOARD_SIZE : Vector2i = Vector2i(23, 12);
var BOARD : Array = [];
var SET_OF_CITIES : Array = [];

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

var explosion = load("res://utils/explosion/explosion.tscn")


@export
var waterSourcesTries      : int = 20;
@export
var MinWaterSourcesTries   : int = 7;
@export
var makxWaterSourceSize    : int = 50;
@export
var MinmakxWaterSourceSize : int = 7;

func getRandomNumber(R1, R2):
	return MainGame_ref.globalVar.globalRNG.randi_range(R1,R2);

func isPlayerTour():
	if(Players[PlayerTour] == playerType.PLAYER):
		return true;
	return false;

func getUnitUniqueId():
	unitCounter += 1;
	return unitCounter-1;

func _ready():
	SET_OF_CITIES += Capitals;	
	for x in range(BOARD_SIZE.x):
		var yRow : Array = [];
		var yRow2 : Array = [];
		for y in range(BOARD_SIZE.y):
			yRow.push_back(null);
			yRow2.push_back(null);
			
		BOARD.push_back(yRow)
		UnitsOnBoard.push_back(yRow2)
