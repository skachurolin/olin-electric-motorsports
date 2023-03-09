from tkinter import *
# from mkv.software.dashboard.dashboardCAN import msg
import json
from random import randint


dash_read = open('./dashboard.json', 'r') # read dashboard json

data = json.load(dash_read)


errorId = [1,2,7,9]

id = []
ername = []
value = []
errors=[id,ername,value]

for i in data['Can-Ids']:
  id.append(i['id'])
  ername.append(i['name'])
  value.append(i['value'])



for i in data['Can-Ids']:
    if i['id'] in errorId :
      if i['value'] != 0:
            print(i['name'])
           
print(i)
print(errors)


root = Tk()
root.geometry("640x480")
canvas = Canvas(root, width=640, height=480, bg="grey")




def update():
  canvas.delete('all')
  canvas.pack(pady=20)
  canvas.create_oval(60,60,180,180)
  randval = randint(0,1000)
  canvas.create_text(300, 50, text=randval, fill="black", font=('Helvetica 40 bold'))
  root.after(1000, update) # run itself again after 1000 ms

# run first time
update()

dash_read.close()
root.mainloop()
