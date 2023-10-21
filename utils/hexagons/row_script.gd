extends Node2D

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
