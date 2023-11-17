###Ted Yee 8-23-2023 for AirWorks Inc.
###Files must be loaded as Layer 0=KML, 1=Pointcloud, (if buildings or water exist, they can be 2 or 3), no other layers
###For tiled pointclouds, put all tiles on one layer
#import tkinter as tk
from pickle import TRUE
import globalmapper as gm
from os import listdir
# from tkinter import Tk
# from tkinter import *
# from tkinter import filedialog
# from tkinter.filedialog import askdirectory

#region: Function Definitions
def close_all_layers():
    A = gm.GetLoadedLayerList()                           #                                                                   A = self-explanatory
    if A:                                                 #                                                                   makes an array of open layers
        arr_ptr, arr_size = A                             #
        initial_layers = gm.GM_LayerHandle_array_frompointer(arr_ptr)   #                                                                   assigns the layers ptr's (ID numbers, starting at 0)
        for i in range(arr_size):                                       #                                                                   iterates through and closes layers
            gm.CloseLayer(initial_layers[i]) 
# def single_file ():
#     fileee = filedialog.askopenfilename(initialdir = "/",
#                                         title = "Select a File",
#                                         filetypes = (("All files",
#                                                      "*.*"),
#                                                      ("Python Files",
#                                                       "*.py*")))
#     print (fileee)
# def whole_folder ():
#     path = "C:\\Users\\AirWorksProcessing\\Documents\\toposcript\\"		## path = askdirectory(title='Select Folder') # shows dialog box and return the path
#     dir_files = listdir(path)											#
#     filenames = []														## filenames= array ofall files in the directory with the desired extension(s)###########################################################
#     for f in dir_files:													#
#         file = f.lower()												#
#         if file.endswith(".laz") or file.endswith(".las"):
#             filenames.append(file)										#
#             print("B: New File Found")###################################
#     for filename in filenames:                                          #
#         err, arr_ptr, arr_size = gm.LoadLayerList(path + filename, gm.GM_LoadFlags_UseDefaultLoadOpts)
#         layer_arr = gm.GM_LayerHandle_array_frompointer(arr_ptr)        #
#         print("C: New File Loaded")######################################

def grid_combine (lay1, lay2, operation):
    arr_ptr, arr_size = gm.GetLoadedLayerList()                                     #makes new array of layers
    E = gm.GM_LayerHandle_array_frompointer(arr_ptr)   
    cs = gm.GM_GridCombineSetup_t ()
    cs.mCombineOp = operation
    cs.mLayer1 = E[lay1]
    cs.mLayer2 = E[lay2]
    NEW_GRID = gm.CombineTerrainLayers(cs, 0x0)
    print ("Combined/Subtracted Grid Info",NEW_GRID)
def gen_contours (laynum,minr,majr):
    arr_ptr, arr_size = gm.GetLoadedLayerList()                         #                                                                   makes new array of layers (after creation of the grids)
    C = gm.GM_LayerHandle_array_frompointer(arr_ptr)           #                                                                   contour settings
    contour_params = gm.GM_ContourParams_t()                            #
    contour_params.mIntervalInFeet = 50                                 #
    contour_params.mShowProgress = False                                #
    err, contour_layer = gm.GenerateContours(C[2], contour_params)#                                                                makes contours out ot the layer assigned to ptr=2/3rd layer (the grid)
    print("New Contours Created for Layer",laynum)
def export_contours (laynum, outputfolder):
    arr_ptr, arr_size = gm.GetLoadedLayerList()                         #                                                                   makes new array of layers
    D = gm.GM_LayerHandle_array_frompointer(arr_ptr)           #
    print("Contours Exported to output", outputpath) 
#endregion

#region 0: Deprecated/Incompete: load in individual files or whole folders
#if- user choice
    #single_file
#else
    #whole_folder
#endregion

#region 1: Dialog box confirming that Pointcloud is QC'ed and layers are set up correctly
# r = tk.Tk()
# r.title("This Only Works if You've Already QC'ed the Pointcloud")
# button = tk.Button(r, text="I have QC'ed the Pointcloud", width=30, command=r.destroy)
# button.pack()
# info = tk.Message(r, text="Files must be loaded as:\n*Layer 0=KML\n*1=Pointclouds \n*If buildings and/or water exist, they can be 2 or 3 \n*No other layers")
# info.pack()
# Cancel = tk.Button(r, text="Cancel", width=50, command=r.destroy)
# Cancel.pack()
# w = tk.Canvas(r, width=500, height=60)
# w.pack()
# canvas_height=60
# canvas_width=250
# y = int(canvas_height / 2)
# w.create_line(100, y, 400, y+15)
# r.mainloop()
#????????????does user want all layers close when done?
#is only ground class visible?
#????# if so cl=1
#endregion

#2: User Selects Output Folder
# outputpath = filedialog.askdirectory(initialdir = "/", title = "Please Select the Output Folder for Your Contours")
# print ("Output Filepath Set To:",outputpath)

#3: Creating Elevation Grids for Layers 0,1,2,3 (KML, GROUND, BUILDINGS, WATER)
arr_ptr, arr_size = gm.GetLoadedLayerList()                                     #makes new array of layers
B = gm.GM_LayerHandle_array_frompointer(arr_ptr)
grid_setup = gm.GM_GridGenSetup_t()                                 #mDatum=108...ETRS89 (Europe)
grid_setup.mGridAlg = gm.GM_GridAlg_BinAverage                      #mUnit=0......???? Is there even a 0?
grid_setup.mXRes = 0x1                                              #mUnit=1......feet
grid_setup.mYRes = 0x1
grid_setup.tightness = 0
if gm.GetLayerInfo(B[1]).mNativeProj.mUnit == 1:            #mUnit=3......there's gotta be a 3, but idk what                     sets elevation units of grid to match that of projection
    grid_setup.mElevUnits = gm.GM_ElevUnit_Feet                     #mUnit=4......arc degrees
elif gm.GetLayerInfo(B[1]).mNativeProj.mUnit == 2:          #Global Mapper accepts 30 Projection Units https://www.bluemarblegeo.com/knowledgebase/global-mapper-python-24-1/_modules/globalmapper.html#GM_Projection_t
    grid_setup.mElevUnits = gm.GM_ElevUnit_Meters                   #
else:                                                               #
    print("!!!!!!!!!!Detected Projection Units are not feet or meters. Reproject it Bozo.")

err, KML_GRID = gm.GenerateElevationGrid2([B[0]], None)                     #makes a grid out of the layer assigned to ptr=0 (the kml) with default grid settings. It only runs on default, idk how to fix it
print("Elevation Grid Created for Layer 0 with handle",KML_GRID)
err, TIGHT_GROUND_GRID= gm.GenerateElevationGrid2([B[1]], grid_setup)       #makes a grid out of the layer assigned to ptr=1 (the ground points) with settings specified above
print("Elevation Grid Created for Layer 1 with handle",TIGHT_GROUND_GRID)
err, B_GRID = gm.GenerateElevationGrid2([B[2]], None)                       #makes a grid out of the layer assigned to ptr=2 (the buildings) with default settings
print("Elevation Grid Created for Layer 2 with handle",B_GRID)
err, W_GRID = gm.GenerateElevationGrid2([B[3]], None)                       #makes a grid out of the layer assigned to ptr=3 (the water) with defualt settings
print("Elevation Grid Created for Layer 3 with handle",W_GRID)

# if len (B) == 3:
#     B_GRID=gen_grid(2,0)
# elif len (B) == 4:
#     W_GRID=gen_grid(3,0)
#BW_GRID=(2,3,0)?????????????????????????????????????


#4: Creating Obstruction Layer
# if arr_size == 3:
# 	Z=grid_combine (TIGHT_GROUND_GRID, B_GRID, 0)     #adds ground+Buildings
# elif arr_size == 4:
# 	Z=grid_combine (Z,W_GRID,0)                         #adds Z+Water (Y is now Ground+water+buildings)
# 	X=grid_combine (KML_GRID, Z, 2)                     #cuts Y out of the KML GRID
#boundingbox(X, FALSE)????????????????????????????????? GENERATE_LAYER_BOUNDS GM_Rectangle_t
#OBSTRUCTION_LAYER=areatopolygon?????????????????????????????????????????
#remove small islands?????????????????????
#simplify??????????????????????????????????????


#5: Generating another elevation grid for contours, loose so that we get contours for as much area as possible
# LOOSE_GROUND_GRID = gen_grid(1,0)

# #6: Generating Contours
# #???????????????????????????    #User Selects major and minor contour intervals
# #minr=
# #majr=
# contourlayer= gen_contours(LOOSE_GROUND_GRID,minr,majr)

#7: Clip contours to KML and to obstruction polygons
#???????????????????????????????/

#8: Exporting Contours
# gm.ExportVector(outputpath, gm.GM_Export_DXF, contourlayer, None, gm.GM_VectorExportFlags_HideProgress, 0x0)

#9: If User has Selected, all open layers will be closed via subfunction close_all_layers
#if cl ==1
    #close_all_layers()