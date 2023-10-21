extends Node2D

@onready
var tours =  $AfterStart/DEBUG/TourNumber;
@onready
var movesLeft = $AfterStart/DEBUG/MovesLeft;
@onready
var who = $AfterStart/DEBUG/Who;
@onready
var unitSpeed = $AfterStart/Control/ToggleFastMoving/speedValue;
@onready
var countriesShild = $CountryIcon;
@onready
var movesLeftValue = $AfterStart/Data/MovesLeft/Val
@onready
var seedValue =    $BeforeStart/seed/seedValue
@onready
var aiSelect = $BeforeStart/AI/MenuButton
@onready
var mainBacgroundMusic = $"../AudioStreamPlayer";
@onready
var settingsWindow     = $Settings

var GameDataRef = null;
var MainGameRef = null;
var isUnitDataVisible = true;


func setSeedValue(val):
	$BeforeStart/seed/seedValue.value = val;


func prepareInterface():
	#var shildInstance = 
	#countriesShild.add_child()
	for cColor in range(1, GameDataRef.CountriesColors.size()+1):
		countriesShild.get_node("shild"+str(cColor)).setColor(GameDataRef.CountriesColors[cColor-1])
	for ai in GameDataRef.ai_models_display_name:
		aiSelect.get_popup().add_item(ai)
	aiSelect.get_popup().connect("id_pressed",ai_selected)
	$BeforeStart/AI/active_ai_val_display.text = "[center]"+GameDataRef.ai_models_display_name[GameDataRef.activeAI_model]+"[/center]";
	pass;

func ai_selected(id):
	GameDataRef.activeAI_model = id
	$BeforeStart/AI/active_ai_val_display.text = "[center]"+GameDataRef.ai_models_display_name[id]+"[/center]";

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (GameDataRef == null):
		return;
	$AfterStart/DEBUG/FPS.text = str(Engine.get_frames_per_second()   );

	pass
func setMovesLeft(moves):
	movesLeft.text  = "ruchy "+str(moves);
	movesLeftValue.text = str(moves);
	

func updateInterfaceNewPlayerHaveTour(playerBefore = null):
	who.text 		= "kto "+str(GameDataRef.PlayerTour);
	tours.text 		= "Tura "+str(GameDataRef.tour);	
	$AfterStart/DEBUG/CountryManPower.text= "Siła państwa: "+str(GameDataRef.COUNTRIES[GameDataRef.PlayerTour].CountryManPower)
	if (playerBefore != null):
		countriesShild.get_node("shild"+str(playerBefore+1)).deactivate(GameDataRef.UNIT_SPEED);
	countriesShild.get_node("shild"+str(GameDataRef.PlayerTour+1)).activate(GameDataRef.UNIT_SPEED)
	

var buttonCoolDown = false;
func _on_button_pressed():
	
	if (GameDataRef.Players[GameDataRef.PlayerTour] == GameDataRef.playerType.PLAYER):
		#buttonCoolDown = true;
		GameDataRef.COUNTRIES[GameDataRef.PlayerTour].end_tour();
		#await get_tree().create_timer(1).timeout
		#buttonCoolDown = false;
		pass;


func _on_toggle_morale_vis_pressed():

	#buttonCoolDown = true;
	isUnitDataVisible = !isUnitDataVisible;
	for c in GameDataRef.COUNTRIES:
		for u in c.units:
			u.unitBoardRef.get_node("poly2").visible = isUnitDataVisible
	#await get_tree().create_timer(.5).timeout
	#buttonCoolDown = false;


func _on_toggle_fast_moving_pressed():
	#if (buttonCoolDown || GameDataRef.BlockMovement):
	#	return;
	#buttonCoolDown = true;
	match (GameDataRef.UNIT_SPEED):
		GameDataRef.UNIT_SPEED_VALUE.SLOW:
			GameDataRef.UNIT_SPEED = GameDataRef.UNIT_SPEED_VALUE.NORMAL
			unitSpeed.text = "[center]NORMAL SPEED[/center]";
		GameDataRef.UNIT_SPEED_VALUE.NORMAL:
			GameDataRef.UNIT_SPEED = GameDataRef.UNIT_SPEED_VALUE.FAST
			unitSpeed.text = "[center]FAST SPEED[/center]";			
		GameDataRef.UNIT_SPEED_VALUE.FAST:
			GameDataRef.UNIT_SPEED = GameDataRef.UNIT_SPEED_VALUE.ULTRA
			unitSpeed.text = "[center]ULTRA SPEED[/center]";			
		GameDataRef.UNIT_SPEED_VALUE.ULTRA:
			GameDataRef.UNIT_SPEED = GameDataRef.UNIT_SPEED_VALUE.SLOW
			unitSpeed.text = "[center]SLOW SPEED[/center]";			
	#await get_tree().create_timer(.5).timeout
	#buttonCoolDown = false;




func _on_button_pressed_set_seed():
	print (seedValue.value);
	MainGameRef.changeSeed(seedValue.value)


func _on_button_random_seed():
	MainGameRef.changeSeed(MainGameRef.globalVar.globalRNG.randi_range(1,999999))

func GameEnd(isPlayerVictory):
	if (isPlayerVictory):
		$GameEnd/Title_win.visible = true;
		$GameEnd/Title_lost.visible = false;
		$GameEnd/desc_lost.visible = false;
		$GameEnd/desc_win.visible = true;
	else:
		$GameEnd/Title_win.visible = false;
		$GameEnd/Title_lost.visible = true;
		$GameEnd/desc_lost.visible = true;
		$GameEnd/desc_win.visible = false;
	$GameEnd/seedValue.text = str(GameDataRef.MainGame_ref.SeedValue);
	$GameEnd.visible = true;

func on_c_1_choose_pressed():
	print("selected 0")
	MainGameRef.gameBegin(0)

func _on_c_2_choose_pressed():
	print("selected 1")
	MainGameRef.gameBegin(1)
	
func _on_c_3_choose_pressed():
	print("selected 2")
	MainGameRef.gameBegin(2)

func on_c_4_choose_pressed():
	print("selected 3")
	MainGameRef.gameBegin(3)

func cancelAnyPossibleMovement():
	MainGameRef.cancelAnyPossibleMovement()

func _on_speaker_pressed():
	MainGameRef.globalVar.sesActive = !MainGameRef.globalVar.sesActive;
	cancelAnyPossibleMovement();
	

func _on_explosion_pressed():
	MainGameRef.globalVar.ExplosionAnimation = !MainGameRef.globalVar.ExplosionAnimation;
	cancelAnyPossibleMovement()

func _on_flute_pressed():
	MainGameRef.globalVar.backgroundMusic = !MainGameRef.globalVar.backgroundMusic
	mainBacgroundMusic.autoplay = MainGameRef.globalVar.backgroundMusic;
	mainBacgroundMusic.playing  = MainGameRef.globalVar.backgroundMusic;
	cancelAnyPossibleMovement()
	pass # Replace with function body.


func _on_settings_button_pressed():
	settingsWindow.visible = !settingsWindow.visible;
	cancelAnyPossibleMovement()




func _on_zoom_control_pressed():
	MainGameRef.globalVar.zoomControlActive = !MainGameRef.globalVar.zoomControlActive;
	MainGameRef.setZoomControlVisibilityToGlobalVar()
	cancelAnyPossibleMovement()
