import can
import cantools
import yaml

"""
with open(r'./dashboard_can.yml') as yamldash:
    
    canYaml= yaml.load(yamldash, Loader=yaml.FullLoader)

subsribe = (list(canYaml.values()))

canIds = []

print(canYaml)
for i in subsribe:
    for j in i:
        canIds.append(j['canId'])
print(canIds)

canIds = []
msg={'OXD': [0, 0, 0, 0, 0, 0, 0, 0], '0XF': 20} # 0XD - error messages , 0Xf - speed
"""

db = cantools.database.load_file("../bazel-bin/vehicle/mkv/mkv.dbc")
can_bus = can.interface.Bus(bustype="slcan", channel="/dev/ttyACM1", bitrate=500000)
msg = can_bus.recv()
print(msg)
temp_msg = db.decode_message(msg.arbitration_id, msg.data)
print(temp_msg)

"""
for i in canIds:
    if msg.arbitration_id ==i:
        msg[i]=temp_msg

dec_msg = 2 #test dec_msg
for i in canIds:
    if i == dec_msg:
        receivedMsg = i
 
for i in subsribe:
    for j in i:
        if j['canId']==receivedMsg:
            dashMsg = j['name']

print(dashMsg)"""
