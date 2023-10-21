extends Node2D


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
