extends Node2D


@onready var node_Output = get_node("Device Output")
@onready var node_Speed = get_node("Device Speed")
@onready var node_OutputWanted = get_node("OutputWanted")
@onready var node_DevicesNeeded = get_node("Devices Needed")
@onready var node_Options = get_node("OptionButton")

@onready var node_ItemsIn = get_node("Items In")
@onready var Label_ItemsInNeeded = get_node("ItemsInNeeded")


func _on_button_pressed():
	Calculate(node_Output.get_text(), node_Speed.get_text(), node_OutputWanted.get_text(), node_DevicesNeeded.get_text())
	
	
func Lock():
	node_Output.set_editable(false)
	node_Speed.set_editable(false)
	node_OutputWanted.set_editable(false)
	node_DevicesNeeded.set_editable(false)
	node_Output.set_text("")
	node_Speed.set_text("")
	node_OutputWanted.set_text("")
	node_DevicesNeeded.set_text("")
	match node_Options.get_selected():
		0:
			node_OutputWanted.set_editable(true)
			node_DevicesNeeded.set_editable(true)
			node_Speed.set_editable(true)
		1:
			node_Output.set_editable(true)
			node_OutputWanted.set_editable(true)
			node_DevicesNeeded.set_editable(true)
		2:
			node_Output.set_editable(true)
			node_OutputWanted.set_editable(true)
			node_Speed.set_editable(true)
		3:
			node_Output.set_editable(true)
			node_Speed.set_editable(true)
			node_DevicesNeeded.set_editable(true)
func Calculate(OutputRate, Speed, OutputWanted, DevicesNeeded):
	match node_Options.get_selected():
		0:
			node_Output.set_text(str(float(OutputWanted) / float(DevicesNeeded) / float(Speed)))
			Label_ItemsInNeeded.set_text("Items in per/second - " + str(float(node_ItemsIn.get_text()) * float(Speed) * float(DevicesNeeded)))
		1:
			if OutputRate: node_Speed.set_text(str(float(OutputWanted) / (float(OutputRate) * float(DevicesNeeded))))
			else: node_Speed.set_text(str(float(OutputWanted) / float(DevicesNeeded)))
			Label_ItemsInNeeded.set_text("Items in per/second - " + str(float(node_ItemsIn.get_text()) * (float(OutputWanted) / (float(OutputRate) * float(DevicesNeeded))) * float(DevicesNeeded)))
		2:
			if OutputRate: node_DevicesNeeded.set_text(str(float(OutputWanted) / (float(OutputRate) * float(Speed))))
			else: node_DevicesNeeded.set_text(str(float(OutputWanted) / (1 * float(Speed))))
			Label_ItemsInNeeded.set_text("Items in per/second - " + str(float(node_ItemsIn.get_text()) * float(Speed) * (float(OutputWanted) / (float(OutputRate) * float(Speed)))))
		3:
			if OutputRate: node_OutputWanted.set_text(str(float(Speed) * float(DevicesNeeded) * float(OutputRate)))
			else: node_OutputWanted.set_text(str(float(Speed) * float(DevicesNeeded) * 1))
			Label_ItemsInNeeded.set_text("Items in per/second - " + str(float(node_ItemsIn.get_text()) * float(Speed) * (float(OutputWanted) / (float(OutputRate) * float(Speed)))))
func _on_option_button_item_selected(index):
	Lock()
