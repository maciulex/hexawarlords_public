extends Camera2D


var zoomChange = 0.25
var zoomInLimit = Vector2(2,2)
var zoomOutLimit = Vector2(1,1);

var speedOfZoom = 20;
var streghtOfWallKnockback = 4;
var lastCameraCenter = Vector2(-20,-20)
var MainGame = null
var center = Vector2(960, 540);

func _on_zoom_in_pressed():
	var currentZoom = zoom;
	currentZoom.x += zoomChange;
	currentZoom.y += zoomChange;
	
	if (currentZoom.x > zoomInLimit.x):
		currentZoom = zoomInLimit

		
	zoom = currentZoom;
	MainGame.cancelAnyPossibleMovement()
	
func _on_zoom_out_pressed():
	var currentZoom = zoom;
	currentZoom.x -= zoomChange;
	currentZoom.y -= zoomChange;
	
	if (currentZoom.x < zoomOutLimit.x):
		currentZoom = zoomOutLimit

	zoom = currentZoom;
	MainGame.cancelAnyPossibleMovement()

func cameraInsideTest(direction):
	var centerNow = get_screen_center_position();
	print(position);

	if (centerNow == lastCameraCenter):
		return false;
	lastCameraCenter = centerNow;
	return true;

func getBack():
	var direction = Vector2((center.x-position.x),(center.y-position.y));
	print(direction);
	direction.x /= 5
	direction.y /= 2
	position.x += direction.x
	position.y += direction.y

func _on_right_pressed():
	MainGame.cancelAnyPossibleMovement()
	if zoom == zoomOutLimit:
		return
	
	position.x += speedOfZoom;
	
	if !cameraInsideTest(Vector2(-speedOfZoom, 0)):
		getBack();
	
func _on_left_pressed():
	MainGame.cancelAnyPossibleMovement()
	if zoom == zoomOutLimit:
		return
		
	position.x -= speedOfZoom;
	
	if !cameraInsideTest(Vector2(speedOfZoom, 0)):
		getBack();
	
func _on_top_pressed():
	MainGame.cancelAnyPossibleMovement()
	if zoom == zoomOutLimit:
		return
	
	position.y -= speedOfZoom;
	
	if !cameraInsideTest(Vector2(0, speedOfZoom)):
		getBack();


func _on_down_pressed():
	MainGame.cancelAnyPossibleMovement()
	if zoom == zoomOutLimit:
		return
	
	position.y += speedOfZoom;
	
	if !cameraInsideTest(Vector2(0, -speedOfZoom)):
		getBack();



