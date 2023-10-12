import subprocess
from pickle import TRUE
from os import listdir

import tkinter as tk
from tkinter import *
from tkinter import filedialog

import time

#Might use this at some point. Makes a dialog box for GUI's
# from tkinter import *
# master = Tk()
# w = Spinbox(master, from_ = 0, to = 10)
# w.pack()
# mainloop()
# print (w)



r = tk.Tk()
r.title("Global Mapper is running in the background to make the contours...")
button = tk.Button(r, text="Stop the Script", width=15, command=r.destroy)
button.pack()
w = tk.Canvas(r, width=40, height=60)
w.pack()
canvas_height=20
canvas_width=200
y = int(canvas_height / 2)
w.create_line(0, y, canvas_width, y )
w = tk.Spinbox(r, from_ = 1, to = 10000)
print (w)
r.mainloop()

#region : prompts script & output_location, then runs the script 
script = filedialog.askopenfilename(initialdir = "/",
                                      title = "Please Select the Contour-Maker Script you want to run",
                                      filetypes = (("All files",
                                                     "*.*"),
                                                   ("Python Files",
                                                    "*.py*")))
print (script)

time.sleep(1) # Sleep for 1sec

output_location = filedialog.askdirectory(initialdir = "/", title = "Please Select the Output Folder for your contours")
print (output_location)

def export_contours_to_dxf(output_location):
    #Input filepaths here
    global_mapper_exe = "C:\\Program Files\\GlobalMapper23.1_64bit\\global_mapper.exe"

    #Need to somehow pass the output_location to the script to it knows where to put the contours
    #blah blah blah

    #Uses Command Line to run Global Mapper, then the script you wrote
    cmd = f'"{global_mapper_exe}" "{script}" '

    # Run the Global Mapper command using subprocess
    subprocess.run(cmd, shell=True)

export_contours_to_dxf(output_location)
#endregion