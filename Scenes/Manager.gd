extends Control


@onready var node_Output = get_node("HBoxContainer/VBoxContainerLeft/Device Output")
@onready var node_Speed = get_node("HBoxContainer/VBoxContainerLeft/Device Speed")
@onready var node_OutputWanted = get_node("HBoxContainer/VBoxContainerRight/OutputWanted")
@onready var node_DevicesNeeded = get_node("HBoxContainer/VBoxContainerMid/Devices Needed")
@onready var node_Options = get_node("HBoxContainer/VBoxContainerMid/OptionButton")

@onready var node_ItemsIn = get_node("HBoxContainer/VBoxContainerLeft/Items In")
@onready var Label_ItemsInNeeded = get_node("HBoxContainer/VBoxContainerRight/ItemsInNeeded")
var Checked = false
var fontSize = 8
var Defaultclr = Color(0.098, 0.196, 0.22, 1)
var ColorPickerSettings = {
	"BG_CLR": [Color(0.098, 0.196, 0.22, 1)],
	"BG_CLR_SWATCHES": [Color(0.098, 0.196, 0.22, 1)],
}


func _ready():
	Load()

func _on_btn_ready_pressed():
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


func _on_check_button_pressed():
	Checked = !Checked
	if(Checked):
		$AcceptDialog.visible = true
	else: load("res://Other/TextBoxTheme.tres").set_default_font_size(15)
	RenderingServer.set_default_clear_color(Defaultclr)
	Save()


func _on_accept_dialog_confirmed():
		fontSize = $"AcceptDialog/vbox Main/Vbox Font size/Slr_MiniFontSize".get_value()
		load("res://Other/TextBoxTheme.tres").set_default_font_size(fontSize)
		$AcceptDialog.visible = false
		RenderingServer.set_default_clear_color($"AcceptDialog/vbox Main/ColorPicker".get_pick_color())
		Save()

func _on_accept_dialog_canceled():
	$HBoxContainer/VBoxContainerMid/Cb_MiniMode.set_pressed(false)
	RenderingServer.set_default_clear_color(Defaultclr)
var saveLocation = "user://saves.cfg"
func Save():
	var config = ConfigFile.new()
	var configFile = config.load(saveLocation)
	config.set_value("Save", "Checked", Checked)
	config.set_value("Save", "FontSize", fontSize)
	config.set_value("Save", "ColorSettings", ColorPickerSettings)
	config.save(saveLocation)
func Load():
	var config = ConfigFile.new()
	var configFile = config.load(saveLocation)
	if configFile != OK:
		pass
	else:
		Checked = config.get_value("Save", "Checked")
		fontSize = config.get_value("Save", "FontSize")
		$"AcceptDialog/vbox Main/Vbox Font size/Slr_MiniFontSize".set_value(fontSize)
		ColorPickerSettings = config.get_value("Save", "ColorSettings")
		$"AcceptDialog/vbox Main/ColorPicker".set_pick_color(ColorPickerSettings["BG_CLR"])
		RenderingServer.set_default_clear_color(ColorPickerSettings["BG_CLR"])
		for clr in ColorPickerSettings["BG_CLR_SWATCHES"]:
			$"AcceptDialog/vbox Main/ColorPicker".add_preset(clr)
	if(Checked):
		$HBoxContainer/VBoxContainerMid/Cb_MiniMode.set_pressed(true)
		load("res://Other/TextBoxTheme.tres").set_default_font_size(fontSize)





func _on_color_picker_preset_added(color):
	ColorPickerSettings["BG_CLR_SWATCHES"].append(color)
	ColorPickerSettings["BG_CLR"] = color

func _on_color_picker_preset_removed(color):
	ColorPickerSettings["BG_CLR_SWATCHES"].erase(color)


func _on_color_picker_color_changed(color):
	RenderingServer.set_default_clear_color(color)
	ColorPickerSettings["BG_CLR"] = color
	
