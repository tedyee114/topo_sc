from pickle import TRUE
from os import listdir
import tkinter as tk
from tkinter import Tk
from tkinter import *
from tkinter import filedialog
from tkinter.filedialog import askdirectory
  
# # Function for opening the file explorer window
# fileeeee = filedialog.askopenfilename(initialdir = "/",
#                                       title = "Select a File",
#                                       filetypes = (("All files",
#                                                      "*.*"),
#                                                    ("Python Files",
#                                                     "*.py*")))
# print (fileeeee)

# folder = filedialog.askdirectory(initialdir="/",
#                                  mustexist= TRUE)
# print (folder)
def get_value():
    e_text=button.get()


#Dialog box confirming that Pointcloud is QC'ed
r = tk.Tk()
r.title("This Only Works if You've Already QC'ed the Pointcloud")
button = tk.Button(r, text="I have QC'ed the Pointcloud", width=30, command=get_value)
button.pack()
info = tk.Message(r, text="Files must be loaded as:\n*Layer 0=KML\n*1=Pointclouds \n*If buildings and/or water exist, they can be 2 or 3 \n*No other layers")
info.pack()
Cancel = tk.Button(r, text="Cancel", width=50, command=r.destroy)
Cancel.pack()
w = tk.Canvas(r, width=500, height=60)
w.pack()
canvas_height=60
canvas_width=250
y = int(canvas_height / 2)
w.create_line(100, y, 400, y+15)
r.mainloop()