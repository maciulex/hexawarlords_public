extends Node2D

var unit_id;
var Country = 0;
var morale  = 0 : set = _morale_setter;
var manpower= 0 : set = _manpower_setter;
var cords: Vector2i;
var color: Color;
var type = false;

var lockedForMovement = false;

var drawerRef = null;
var unitBoardRef;
var CountryRef = null

var firstSetter = true;

var unitAtMove = false;

var moveSpeed;
var from : Vector2;
var to : Vector2;
var interpolationProggress = 0;

signal moveDone;


	
func moveUnitSmooth(posFrom : Vector2i, posTo: Vector2i, speed : float = 2):
	interpolationProggress = 0;
	moveSpeed = speed;
	from = posFrom;
	to = posTo
	unitAtMove = true;
	

func get_battle_power():
	return manpower + morale;

func _manpower_setter(val):
	var menpowerBefore = CountryRef.CountryManPower - manpower;
	manpower = val;
	
	if (manpower) > 99:
		manpower = 99;
	if (manpower <= 0):
		manpower = 1;
	$poly2/manpower.text = str(manpower)
	if (!firstSetter):
		drawerRef.assureUnitCorrectType(self)
	CountryRef.CountryManPower = menpowerBefore + manpower;
	firstSetter = false;
	_morale_setter(morale)

func _morale_setter(val):
	morale = val;
	if (morale > manpower):
		morale = manpower;
	if morale <= 0:
		morale = 1;
	$poly2/morale.text = str(morale)

func _physics_process(delta):
	if (interpolationProggress >= 1):
		unitAtMove = false;
		interpolationProggress = 0;
		emit_signal("moveDone",self)
		print("move done")
	if (unitAtMove):
		interpolationProggress += delta * moveSpeed
		unitBoardRef.position = Vector2(from).lerp(Vector2(to), interpolationProggress)
