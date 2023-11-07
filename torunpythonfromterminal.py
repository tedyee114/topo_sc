#region 1: Import add-ons and libraries
from datetime import datetime
now = datetime.now().strftime("%H:%M:%S")
print('Step 00: Process Started at ', now)
import sys                                                  #idk what this does but something to download ezdxf
import subprocess                                           #gives access to the windows commandline
import pkg_resources                                        #for downloading ezdxf

# required = {'ezdxf'}                                        #checks if ezdxf is already on computer
# installed = {pkg.key for pkg in pkg_resources.working_set}
# missing = required - installed
# if missing:                                                 #if not already, installs exdxf (.dxf file manamgent library)
#     python = sys.executable
#     subprocess.check_call([python, '-m', 'pip', 'install', *missing], stdout=subprocess.DEVNULL)

import ezdxf                                                #imports library for use within the script
from ezdxf.addons import Importer                           #imports the importer (inception, lol)
print('Step 0 Complete: Add-ons prepared,                        **Now setting filepaths and reading files')
#endregion


#region 2: Input filepaths here or set up a prompt;
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

global_mapper_exe=     "C:\\Program Files\\GlobalMapper23.1_64bit\\global_mapper.exe"
script=                "C:Documents\\Scripts\\topo_sc\\GMS\\Topo_Script1.gms"
startfile=             "C:Documents\\Scripts\\startfile.gmw"
base_dxf=              ezdxf.readfile("Documents\\Scripts\\v0_SCE_-_1597246_MERLIN_2023-07-27.dxf")
contour_dxf=           ezdxf.readfile("Documents\\Scripts\\contour.dxf")
contour_stylized_dxf= 'Documents\\Scripts\\contours_stylized.dxf'
final_location=       'Documents\\Scripts\\merged.dxf'
print('Step 1 Complete: Filepaths Set,                           **Now opening startfile in GM and running toposcript...(this is the longest step and will take a few minutes)')
#endregion


#region 3: Uses Command Line to run Global Mapper, then the script you wrote
# #Need to somehow pass the contour_output and other file locations to the script to it knows where to put the contours
# cmd = f'"{global_mapper_exe}" "{script}" '
# subprocess.run(cmd, shell=True)
print('Step 2 Complete: Toposcript complete, output in folder,   **Now stylizing contour_dxf')
#endregion


#region 4: change layer names and colors
doc = ezdxf.new(setup=True)                                                 #tbh, idk what this means, but its used below, "setup required line types"
msp = doc.modelspace()


obs_layer = contour_dxf.layers.get("Unknown_Line_Type")
obs_layer.rename("A-OBSTRUCTION")
obs_layer.dxf.linetype = "Continuous"
obs_layer.color = 1                                                         #AutoCAD Color Index ACI Color System 1=red, 8=dark gray, 9=light gray

minr_layer = contour_dxf.layers.get("Contour_Line_Intermediate")
minr_layer.rename("G-TOPO-MINR")
minr_layer.dxf.linetype = "Continuous"
minr_layer.color = 8

majr_layer = contour_dxf.layers.get("Contour_Line_Major")
majr_layer.rename("G-TOPO-MAJR")
majr_layer.dxf.linetype = "Continuous"
majr_layer.color = 9

everything = contour_dxf.query('*')                                         #select all entities in DXF
everything.color = 256                                                      #change entities' color to 256, which means "ByLayer"

contour_dxf.saveas(contour_stylized_dxf)             #save as a new file

print('Step 3 Complete: All processes complete,                  **Now merging back into base_dxf')
#endregion


#region 5: merge generated contours to the base_file
def merge(contour_stylized_dxf, base_dxf):
    importer = Importer(contour_stylized_dxf, base_dxf)
    # import all entities from source modelspace into target modelspace
    importer.import_modelspace()
    # import all required resources and dependencies
    importer.finalize()

merge(contour_stylized_dxf, base_dxf)                                           #runs the merge function defined above
base_dxf.saveas(final_location)      #saves the new file   #base_dxf.save()   # to save as original filename
now = datetime.now().strftime("%H:%M:%S")
print('All Processes Complete at '+now+'. base_dxf ready to open!')
#endregion


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