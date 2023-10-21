extends Node2D

var GameData_ref;
var Drawer_ref;

var Country_name = "";
var Country_id   = 0;
var Country_color= null;

var cities = [];
var units  = [];
var morale = 10;
var moves  = 0 : set = updateMovesLeft;

signal MoveISDone;

var unitScene = load("res://utils/unit/unit.tscn")

enum MERGE_TYPE {JOIN, END_OF_ROUND};

var rng = RandomNumberGenerator.new()

var iknowItsMyTour = false;

var CountryManPower = 0 : set = minimumMoraleAssure;
enum TARGETS {CITY, CAPITAL, UNIT, REINFORCMENT};

func updateMovesLeft(set):
	moves = set;
	GameData_ref.MainGame_ref.Interface.setMovesLeft(moves);

func minimumMoraleAssure(set):
	CountryManPower = set;
	var minimalMorale = CountryManPower/50;
	for u in units:
		if (u.morale < minimalMorale):
			u.morale = minimalMorale;

func getCountryManpowerToUnit():
	var LimitToManpower = int(CountryManPower / 350)
	if (LimitToManpower > 6):
		LimitToManpower = 6;
	return GameData_ref.getRandomNumber(12-LimitToManpower,20-LimitToManpower)

func addToUnit(cordsTo : Vector2i):
	units[getUnitInCountry(cordsTo)].manpower += getCountryManpowerToUnit();

func getUnitInCountryAsUnit(cords : Vector2i):
	return units[getUnitInCountry(cords)]

func getUnitInCountry(cords : Vector2i):
	var c = 0;
	for u in units:
		c+=1;
		if (u.cords.x == cords.x && u.cords.y == cords.y):
			return c-1;
	return 0;

func captureCity(cords : Vector2i, whoLost):
	print("capture city");
	cities.push_back(cords);
	if (whoLost != null):
		GameData_ref.COUNTRIES[whoLost].weLost(cords)
	

func lockUnitFromMovement(unit):
	unit.lockedForMovement = true;

func isMovePossible():
	for u in units:
		if !u.lockedForMovement:
			return true;
	return false;

func deleteUnit(unitID: int): 
	units[unitID].unitBoardRef.queue_free()
	CountryManPower -= units[unitID].manpower;
	Drawer_ref.comebackIconFromCorner(units[unitID].cords)
	units.pop_at(unitID)

func moveToLandWithoutUnit(fromUnit, destUnit, to, from):
	weCaptured(GameData_ref.BOARD[to.x][to.y], units[fromUnit], to, Drawer_ref.LAND_CLAIM[to.x][to.y]);
		
	Drawer_ref.comebackIconFromCorner(units[fromUnit].cords)
	units[fromUnit].cords = to;
	Drawer_ref.moveUnit(units[fromUnit]);
	Drawer_ref.moveIconToCorner(units[fromUnit].cords)
	lockUnitFromMovement(units[fromUnit])

func moveToLandWithFrendlyUnit(fromUnit, destUnit, to, from):
		var manpowerBefore = destUnit.manpower;
		destUnit.manpower += units[fromUnit].manpower;
		if ((manpowerBefore + units[fromUnit].manpower) <= 99):
			deleteUnit(fromUnit);
		else:
			units[fromUnit].manpower -= (99 - manpowerBefore)
		lockUnitFromMovement(destUnit)

func moveToLandWithEnemyUnit(fromUnit, destUnit, to, from):
		var battlePowerFrom = units[fromUnit].get_battle_power();
		var battlePowerTo   = destUnit.get_battle_power();
		Drawer_ref.EXPLOSION_AT(to)
		if (battlePowerTo < battlePowerFrom):
			var dmg = destUnit.manpower/2 + destUnit.morale/4;
			
			unitsLost(dmg, true);
			unitsKilled(destUnit.manpower);	
			
			weCaptured(GameData_ref.BOARD[to.x][to.y], units[fromUnit], to, destUnit.Country);
			
			GameData_ref.COUNTRIES[destUnit.Country].myUnitHasBeenDefeted(destUnit,dmg);
			units[fromUnit].manpower -= dmg;
			
			Drawer_ref.comebackIconFromCorner(units[fromUnit].cords)
			units[fromUnit].cords = to;
			Drawer_ref.moveUnit(units[fromUnit]);
			Drawer_ref.moveIconToCorner(units[fromUnit].cords)
			lockUnitFromMovement(units[fromUnit])
		
			GameData_ref.COUNTRIES[destUnit.Country].weLost(to)
			return 1;
		else:
			var dmg = units[fromUnit].manpower/2 + units[fromUnit].morale/4;
			
			unitsLost(units[fromUnit].manpower, false);
			unitsKilled(dmg);			
			GameData_ref.COUNTRIES[destUnit.Country].weDefendetOurselfs(dmg,units[fromUnit].manpower)
			
			destUnit.manpower -= dmg;
			deleteUnit(fromUnit);
			return -1;

func moveUnit(from, to):
	if (GameData_ref.BlockMovement):
		print("move is blocked")
		return;
	Drawer_ref.unDrawPossibleMovement();
	GameData_ref.BlockMovement = true;
	var destUnit = GameData_ref.MainGame_ref.getUnitOnCell(to);
	var fromUnit = getUnitInCountry(from);
	Drawer_ref.undrawColorMask(units[fromUnit].cords);
	
	if (destUnit == null):
		moveToLandWithoutUnit(fromUnit,destUnit,to,from);
		await MoveISDone;
	elif (destUnit.Country == Country_id):
		moveToLandWithFrendlyUnit(fromUnit,destUnit,to,from);
	elif (destUnit.Country != Country_id):
		if moveToLandWithEnemyUnit(fromUnit,destUnit,to,from) == 1:
			await MoveISDone;
		
	moves -= 1;
	GameData_ref.BlockMovement = false;
	
	if (!isMovePossible() || moves == 0 || GameData_ref.GameComeToEnd):
		print("Wtf")
		unHighLightUnits()
		end_tour()
		return -1;
	if (GameData_ref.Players[Country_id] == GameData_ref.playerType.PLAYER):
		unHighLightUnits()		
		Drawer_ref.hightLightUnits(units);

func countryConquered(cId):
	GameData_ref.PlayersStatus[cId] = GameData_ref.playerStatus.DEAD;
	GameData_ref.MainGame_ref.checkForGameEnd();
	while (GameData_ref.COUNTRIES[cId].units.size() != 0):
		GameData_ref.COUNTRIES[cId].deleteUnit(0);
	while (GameData_ref.COUNTRIES[cId].cities.size() != 0):
		captureCity(GameData_ref.COUNTRIES[cId].cities[0], cId);
	Drawer_ref.conquareEvent(Country_id, cId);

func getCapitalIdFromCords(cords : Vector2i):
	var counter = 0;
	for c in GameData_ref.Capitals:
		if (cords.x == c.x && cords.y == c.y):
			return counter;
		counter += 1;
	return null;

func weCaptured(what, who, cDest, whoLost):
	if (Drawer_ref.LAND_CLAIM[cDest.x][cDest.y] == Country_id):
		return;
	match what:
		GameData_ref.cellType.CAPITAL:
			captureCity(cDest, whoLost)
			print("we won capital");
			for u in units:
				u.morale += 30;
			who.morale += 20;
			if (GameData_ref.PlayersStatus[getCapitalIdFromCords(cDest)] == GameData_ref.playerStatus.ALIVE):
				print("conquare")
				countryConquered(whoLost);
		GameData_ref.cellType.CITY:
			captureCity(cDest, whoLost)
			print("we won city");
			for u in units:
				u.morale += 10;
			who.morale += 10;
		GameData_ref.cellType.PORT:
			print("we won port");
			for u in units:
				u.morale += 5;
			who.morale += 5;
				
		
	
func weLost(cords):
	var what = GameData_ref.BOARD[cords.x][cords.y];
	match what:
		GameData_ref.cellType.CAPITAL:
			print("we lost capital");
			for u in units:
				u.morale -= 30;
			var c = cities.find(cords);
			if (c == -1):
				return;
			cities.remove_at(c);
		GameData_ref.cellType.CITY:
			print("we lost city");
			for u in units:
				u.morale -= 10;
			var c = cities.find(cords);
			if (c == -1):
				return;
			cities.remove_at(c);
		GameData_ref.cellType.PORT:
			print("we lost port");
			for u in units:
				u.morale -= 5;

func myUnitHasBeenDefeted(unit, killed):
	unitsLost(unit.manpower, false);
	unitsKilled(killed);
	var u = units.find(unit);
	if (u == -1):
		return;
	deleteUnit(u);
	
func weDefendetOurselfs(lost, killed):
	unitsLost(lost, true);
	unitsKilled(killed);
	
func unitsLost(amount, battleWon):
	if battleWon:
		return;
	var moraleDrop = int(amount / 10)
	for u in units:
		u.morale -= moraleDrop;
func unitsKilled(amount):
	pass;

func createUnit(pos : Vector2i):
	var unit = unitScene.instantiate();
	
	unit.drawerRef= Drawer_ref	
	unit.unit_id  = GameData_ref.getUnitUniqueId();
	unit.CountryRef= self;
	unit.Country  = Country_id;
	unit.cords    = pos;
	unit.color    = Country_color;
	unit.manpower = getCountryManpowerToUnit();
	unit.morale   = morale;
	
	Drawer_ref.newUnit(unit);
	units.push_back(unit);
	
func isUnitOn(pos : Vector2i):
	for i in units:
		if (i.cords.x == pos.x && i.cords.y == pos.y):
			return true;
	return false;

func unHighLightUnits():
	for u in units:
		Drawer_ref.undrawColorMask(u.cords);

func end_tour():
	for u in units:
		u.lockedForMovement = false;
	Drawer_ref.unDrawPossibleMovement();
	GameData_ref.MainGame_ref.iRegistEndOfTour = Country_id;

func before_next_tour():
	for citi in cities:
		if (isUnitOn(citi)):
			addToUnit(citi);
		else:
			createUnit(citi)

func MoveDoneF():
	emit_signal("MoveISDone")

func prepareToGame():
	for citi in cities:
		createUnit(citi);
		Drawer_ref.claimLand(units[0], true);	
	Drawer_ref.connect("MoveDone", MoveDoneF)	

func myTour():
	moves = GameData_ref.movesPerTour;
	if (GameData_ref.isPlayerTour()):
		Drawer_ref.hightLightUnits(units);
		print("Dupa")#:D
		return;
	else:
		print("Dupa2")#:D
		if (GameData_ref.PlayerTour == Country_id):
			await AI();
		if (GameData_ref.PlayerTour == Country_id):
			end_tour();
		return;

var movesDividerRes0 = [Vector2i(0, -1),Vector2i(+1, -1),Vector2i(+1, +0),
						Vector2i(0, +1),Vector2i(-1, 0),Vector2i(-1, -1)];
var movesDividerRes1 = [Vector2i(0, -1),Vector2i(+1, 0),Vector2i(+1, +1),
						Vector2i(0, +1),Vector2i(-1, +1),Vector2i(-1, 0)];

func pathFinding(from, to):
	print(from, to)
	var controlVar = 0;
	var begiPositionInPx = Drawer_ref.getHexPositionInPX(from)
	var goalPositionInPx = Drawer_ref.getHexPositionInPX(to)
	
	var openNodes   = [[from, 0, null]];
	var closedNodes = [];
	
	while !openNodes.is_empty():
		var currentNode = openNodes[0];
		var currentNodeIndex = 0;

		for o in range(openNodes.size()):
			if (currentNode[1] > openNodes[o][1]):
				currentNode = openNodes[o];
				currentNodeIndex = o;
		
		closedNodes.push_back(currentNode);
		openNodes.remove_at(currentNodeIndex);
		
		if to.x == currentNode[0].x && to.y == currentNode[0].y:
			print("solutionFound")
			var tmp = currentNode;
			var result = [];
			while tmp[2] != null:
				result.push_back(tmp[0]);
				tmp = tmp[2];
			if (result.size() == 0):
				return [null]
			return result;
		
		
		var children = [];
		var setOfDirections = movesDividerRes1 if currentNode[0].x % 2 != 0 else movesDividerRes0;
		
		for d in setOfDirections:
			var childPos = Vector2i(currentNode[0].x + d.x, currentNode[0].y + d.y)
					
			var breakCondition = false;	
			for node in closedNodes:
				if (node[0].x == childPos.x && node[0].y == childPos.y):
					breakCondition = true;
					break;
			if (breakCondition):
				continue;
					
			if (!Drawer_ref.possibleMovement(currentNode[0], d, false)):
				continue;
				
			var childpx = Drawer_ref.getHexPositionInPX(childPos)
			var score = (goalPositionInPx.distance_squared_to(childpx) +
						 begiPositionInPx.distance_squared_to(childpx))
			var child = [childPos, score, currentNode];
			children.push_back(child)
			
			var isBetter = true;
			for node in openNodes:
				if (node[0].x == childPos.x && childPos.y == child[0].y):
					if node[1] <= score:
						isBetter = false;
						break;
			if (isBetter):
				openNodes.push_back(child)
		
		controlVar += 1;
		if (controlVar > 500):
			return [null];
	return [null];

func getBestMoves(unit):
	Drawer_ref.getPossibleMovement(unit.cords);
	
	var moves = [];
	
	for cell in Drawer_ref.possibleMovementData:
		pass;
	
	Drawer_ref.clearPossibleMovement();
	
func getUnitStreightDistanceToTarget(u, target, ignoreFrendly = true, ignoreLockedUnit = true):
	var result = [null, null];
	if ignoreLockedUnit && u.lockedForMovement:
		return result;
	var setOfTarget;
	match target:
		TARGETS.CITY:
			setOfTarget = GameData_ref.SET_OF_CITIES;

	for t in setOfTarget: 
		if (ignoreFrendly && Drawer_ref.LAND_CLAIM[t.x][t.y] == u.Country):
			continue;
		var dst = Vector2(u.cords).distance_squared_to(Vector2(t));
		if result[0] != null && dst >= result[1]:
			continue;
		result[0] = t;
		result[1] = dst;
	return result;
	
func getClosestUnitsToTarget(target):
	var resultAmount = 0;
	var result = [null];
	
	for u in units:
		if u.lockedForMovement:
			continue;
		var dst = getUnitStreightDistanceToTarget(u, target);
		if (dst[0] != null && (result[0] == null || result[1] > dst)):
			result = [u, dst];
	
	return result;

func primitiveAi(target, doPathFinding = false, pathFindingLimitPerArmy = 3):
	print("UNITS MOVE ",Country_name)
	
	while true:
		var closestUnit = getClosestUnitsToTarget(target);
		if (closestUnit[0] == null):
			return;
		Drawer_ref.getPossibleMovement(closestUnit[0].cords)
		if (GameData_ref.MainGame_ref.isInPossibleMovement(closestUnit[1][0])):
			if await moveUnit(closestUnit[0].cords, closestUnit[1][0]) == -1:
				return;
			print("move done")
		else:
			var path = pathFinding(closestUnit[0].cords, closestUnit[1][0]);
			print(path);
			if path[0] == null:
				closestUnit[0].lockedForMovement = true
				continue;
			path.reverse()
			var best = 3 if path.size() >= 3 else path.size()-1;
			
			print(Country_name,path, best)
			
			for i in range(best-1, -1, -1):
				if GameData_ref.MainGame_ref.isInPossibleMovement(path[i]):
					Drawer_ref.clearPossibleMovement();
					if await moveUnit(closestUnit[0].cords, path[i]) == -1:
						return
					print("move done")
					break;
				else:
					print(Country_name," ",path," ",i," MoveImposible")
					
			closestUnit[0].lockedForMovement = true;
		Drawer_ref.clearPossibleMovement();
		pass;

func AI():
	# ["score", unitFromCord, unitToCord];,
	match GameData_ref.activeAI_model:
		GameData_ref.ai_models.PRIMITIVE:
			await primitiveAi(TARGETS.CITY);
	
	return;
	for u in units:
		
		Drawer_ref.getPossibleMovement(u.cords);
		if (Drawer_ref.possibleMovementData.size() > 0):
			print("AI_MOVE")
			var move = rng.randi_range(0, Drawer_ref.possibleMovementData.size()-1);
			move = Drawer_ref.possibleMovementData[move];
			Drawer_ref.clearPossibleMovement();
			if await moveUnit(u.cords, move) == -1:
				return;
