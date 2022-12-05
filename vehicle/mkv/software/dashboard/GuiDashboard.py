from tkinter import *
# from mkv.software.dashboard.dashboardCAN import msg
import json

dash_read = open('./dashboard.json', 'r') # read dashboard json

data = json.load(dash_read)

errors=[ ]
errorId = [1,2,7,9]

for i in data['Can-Ids']:
    if i['id'] in errorId :
      if i['value'] != 0:
            print(i['name'])




root = Tk()
root.geometry("640x480")
canvas = Canvas(root, width=640, height=480, bg="white")
canvas.pack(pady=20)
canvas.create_oval(60,60,180,180,outline = "black", fill = "red",width = 0.1)

dash_read.close()
root.mainloop()
