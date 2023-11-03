import sys                                                  #idk what this does but something to download ezdxf
import subprocess                                           #gives access to the windows commandline
import pkg_resources                                        #for downloading ezdxf

required = {'ezdxf'}                                        #checks if ezdxf is already on computer
installed = {pkg.key for pkg in pkg_resources.working_set}
missing = required - installed

if missing:                                                 #if not already, installs exdxf (.dxf file manamgent library)
    python = sys.executable
    subprocess.check_call([python, '-m', 'pip', 'install', *missing], stdout=subprocess.DEVNULL)

import ezdxf                                                #imports library for use within the script
from ezdxf.addons import Importer                           #imports the importer (inception, lol)

# #region: Prompts script & output_location, then runs the script ;
# from pickle import TRUE
# from os import listdir
# import time
# script = filedialog.askopenfilename(initialdir = "\\",
#                                       title = "Please Select the Script you want to run",
#                                       filetypes = (("All files",
#                                                      "*.*"),
#                                                    ("Python Files",
#                                                     "*.py*")))
# print (script)

# =============================================================================
# time.sleep(1) # Sleep for 1sec

# output_location = filedialog.askdirectory(initialdir = "\\", title = "Please Select the Output Folder for your contours")
# print (output_location)
# #endregion

#Input filepaths here
global_mapper_exe=  "C:\\Program Files\\GlobalMapper23.1_64bit\\global_mapper.exe"
script=             "C:\\Users\\AirWorksProcessing\\Documents\\Scripts\\topo_sc\\GMS\\Topo_Script1.gms"
startfile=          "C:\\Users\\AirWorksProcessing\\Documents\\Scripts\\startfile.gmw"
base_dxf=           ezdxf.readfile("C:\\Users\\ted_airworks.io\\Documents\\Scripts\\v0_SCE_-_1597246_MERLIN_2023-07-27.dxf")
contour_output_dxf= ezdxf.readfile("C:\\Users\\AirWorksProcessing\\Documents\\Scripts\\contour.dxf")
final_location=     "C:\\Users\\AirWorksProcessing\\Documents\\Scripts\\merged.dxf"

# #Need to somehow pass the contour_output and other file locations to the script to it knows where to put the contours
# #blah blah blah

#Uses Command Line to run Global Mapper, then the script you wrote
cmd = f'"{global_mapper_exe}" "{startfile}" "{script}" '
subprocess.run(cmd, shell=True)

#adding the generated contours to the base_file
def merge(contour_output_dxf, base_dxf):
    importer = Importer(contour_output_dxf, base_dxf)
    # import all entities from source modelspace into target modelspace
    importer.import_modelspace()
    # import all required resources and dependencies
    importer.finalize()

merge(contour_output_dxf, base_dxf)                                           #runs the merge function defined above

base_dxf.saveas(final_location)      #saves the new file   #base_dxf.save()   # to save as original filename



# #=============================================================================
# #Might use this at some point. Makes a dialog box for GUI's
# import tkinter as tk
# from tkinter import *
# from tkinter import filedialog
# r = tk.Tk()
# r.title("Global Mapper is running in the background to make the contours...")
# button = tk.Button(r, text="Stop the Script", width=15, command=r.destroy)
# button.pack()
# w = tk.Canvas(, width=40, height=60)
# w.pack()
# canvas_height=20
# canvas_width=200
# y = int(canvas_height \\ 2)
# w.create_line(0, y, canvas_width, y )
# r.mainloop()