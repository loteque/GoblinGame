extends Node

var apower_xbox_guid: String = "03000000d62000003520000067010000"
var dev_0_guid: String
var dev_0_name: String

func set_mapping_str(joy_guid, joy_name, mapping_str):
    var mapping = '%s,%s,%s' % [joy_guid, joy_name, mapping_str]
    Input.add_joy_mapping(mapping, true)
    push_warning("input for " + joy_name + " was remapped.")


func _ready():
    dev_0_guid = Input.get_joy_guid(0)
    dev_0_name = Input.get_joy_name(0)
    match dev_0_guid:
        # web
        apower_xbox_guid:
            print("we have a match!")
            if OS.get_name() == "Web":
                set_mapping_str(
                    dev_0_guid, 
                    dev_0_name,
                    'leftx:a0,lefty:a1,rightx:a2,righty:a3,lefttrigger:a4,righttrigger:a5,a:b0,b:b1,x:b3,y:b2,leftshoulder:b4,rightshoulder:b5,back:b8,start:b9,leftstick:b10,rightstick:b11,dpup:b12,dpdown:b13,dpleft:b14,dpright:b15,guide:b16,leftstick:b10,rightstick:b11,platform:Javascript'
                )
        # linux
            if OS.get_name() == "Linux":
                set_mapping_str(
                    dev_0_guid, 
                    dev_0_name,
                    'leftx:a0,lefty:a1,rightx:a3,righty:a4,lefttrigger:a2,righttrigger:a5,a:b0,b:b1,x:b2,y:b3,leftshoulder:b4,rightshoulder:b5,back:b6,start:b7,leftstick:b9,rightstick:b10,dpup:b11,dpdown:b12,dpleft:b13,dpright:b14,guide:b8,leftstick:b9,rightstick:b10,platform:Linux'
                )