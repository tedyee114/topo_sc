from pickle import TRUE
import globalmapper as gm
from os import listdir
#from tkinter import Tk
#from tkinter.filedialog import askdirectory

# #region 0:close all layers that may be open
# layers_are_open = gm.GetLoadedLayerList()                           #                                                                   layers_are_open = self-explanatory
# if layers_are_open:                                                 #                                                                   makes an array of open layers
#     arr_ptr, arr_size = layers_are_open                             #
#     initial_layers = gm.GM_LayerHandle_array_frompointer(arr_ptr)   #                                                                   assigns the layers ptr's (ID numbers, starting at 0)
#     for i in range(arr_size):                                       #                                                                   iterates through and closes layers
#         gm.CloseLayer(initial_layers[i])                            #
# print("A: All Files Unloaded")                                      #
# #endregion

# # #region 0: find, then load in all files in the directory with the desired extension(s)
# # path = askdirectory(title='Select Folder') # shows dialog box and return the path
# path = "C:\\Users\\AirWorksProcessing\\Documents\\toposcript\\"		#
# dir_files = listdir(path)											#
# filenames = []														#
# for f in dir_files:													#
#     file = f.lower()												#
#     if file.endswith(".laz") or file.endswith(".las"):              #
#         filenames.append(file)										#
#         print("B: New File Found")                                  #
# for filename in filenames:                                          #
#     err, arr_ptr, arr_size = gm.LoadLayerList(path + filename, gm.GM_LoadFlags_UseDefaultLoadOpts)
#     layer_arr = gm.GM_LayerHandle_array_frompointer(arr_ptr)        #
#     print("C: New File Loaded")                                     #
# #endregion

#region 1: Create LOOSE_GROUND_GRID from (layerlist[0])
arr_ptr, arr_size = gm.GetLoadedLayerList()                         #mDatum=14....NAD83                                                makes new array of layers
layerlist = gm.GM_LayerHandle_array_frompointer(arr_ptr)            #mDatum=23....WGS84
grid_setup = gm.GM_GridGenSetup_t()                                 #mDatum=108...ETRS89 (Europe)
grid_setup.mGridAlg = gm.GM_GridAlg_BinAverage                      #mUnit=0......radians
grid_setup.mXRes = 0x1                                              #mUnit=1......feet
grid_setup.mYRes = 0x1                                              #mUnit=2......meters
if gm.GetLayerInfo(layerlist[0]).mNativeProj.mUnit == 1:            #mUnit=3......arc seconds                    sets elevation units of grid to match that of projection
    grid_setup.mElevUnits = gm.GM_ElevUnit_Feet                     #mUnit=4......arc degrees
elif gm.GetLayerInfo(layerlist[0]).mNativeProj.mUnit == 2:          #Global Mapper accepts 30 Projection Units, liested in order starting at 0 here: https://www.bluemarblegeo.com/knowledgebase/global-mapper-python-24-1/_modules/globalmapper.html#GM_Projection_t
    grid_setup.mElevUnits = gm.GM_ElevUnit_Meters                   #
else:                                                               #
    print("!!!!!!!!!!Detected Projection Units are not feet or meters. Reproject it Bozo.")
err, LOOSE_GROUND_GRID = gm.GenerateElevationGrid2([layerlist[0]], grid_setup)#makes a grid out of the layer assigned to ptr=0 (the pointcloud)
print("D: Grid Created for Layer 0")
#endregion

#region 2: Create KML_GRID from  (layerlist[1])
arr_ptr, arr_size = gm.GetLoadedLayerList()                         #mDatum=14....NAD83                                                makes new array of layers
layerlist = gm.GM_LayerHandle_array_frompointer(arr_ptr)            #mDatum=23....WGS84
grid_setup = gm.GM_GridGenSetup_t()                                 #mDatum=108...ETRS89 (Europe)
grid_setup.mGridAlg = gm.GM_GridAlg_BinAverage                      #mUnit=0......radians
grid_setup.mXRes = 0x1                                              #mUnit=1......feet
grid_setup.mYRes = 0x1                                              #mUnit=2......meters
if gm.GetLayerInfo(layerlist[0]).mNativeProj.mUnit == 1:            #mUnit=3......arc seconds                    sets elevation units of grid to match that of projection
    grid_setup.mElevUnits = gm.GM_ElevUnit_Feet                     #mUnit=4......arc degrees
elif gm.GetLayerInfo(layerlist[0]).mNativeProj.mUnit == 2:          #Global Mapper accepts 30 Projection Units, liested in order starting at 0 here: https://www.bluemarblegeo.com/knowledgebase/global-mapper-python-24-1/_modules/globalmapper.html#GM_Projection_t
    grid_setup.mElevUnits = gm.GM_ElevUnit_Meters                   #
else:                                                               #
    print("!!!!!!!!!!Detected Projection Units are not feet or meters. Reproject it Bozo.")
err, LOOSE_GROUND_GRID = gm.GenerateElevationGrid2([layerlist[1]], grid_setup)#makes a grid out of the layer assigned to ptr=0 (the pointcloud)
print("D: Grid Created for Layer 1")
#endregion

#split the dxf into layers

#region 3: Create BW_GRID from  (layerlist[2])
arr_ptr, arr_size = gm.GetLoadedLayerList()                         #mDatum=14....NAD83                                                makes new array of layers
layerlist = gm.GM_LayerHandle_array_frompointer(arr_ptr)            #mDatum=23....WGS84
grid_setup = gm.GM_GridGenSetup_t()                                 #mDatum=108...ETRS89 (Europe)
grid_setup.mGridAlg = gm.GM_GridAlg_BinAverage                      #mUnit=0......radians
grid_setup.mXRes = 0x1                                              #mUnit=1......feet
grid_setup.mYRes = 0x1                                              #mUnit=2......meters
if gm.GetLayerInfo(layerlist[0]).mNativeProj.mUnit == 1:            #mUnit=3......arc seconds                    sets elevation units of grid to match that of projection
    grid_setup.mElevUnits = gm.GM_ElevUnit_Feet                     #mUnit=4......arc degrees
elif gm.GetLayerInfo(layerlist[0]).mNativeProj.mUnit == 2:          #Global Mapper accepts 30 Projection Units, liested in order starting at 0 here: https://www.bluemarblegeo.com/knowledgebase/global-mapper-python-24-1/_modules/globalmapper.html#GM_Projection_t
    grid_setup.mElevUnits = gm.GM_ElevUnit_Meters                   #
else:                                                               #
    print("!!!!!!!!!!Detected Projection Units are not feet or meters. Reproject it Bozo.")
err, LOOSE_GROUND_GRID = gm.GenerateElevationGrid2([layerlist[1]], grid_setup)#makes a grid out of the layer assigned to ptr=0 (the pointcloud)
print("D: Grid Created for Layer 2")
#endregion

#4: MERGED_GRID=LOOSE_GROUND_GRID+BW_GRID

#5: KML_GRID-MERGED_GRID=OBSTRUCTION GRID

#6: OBSTRUCTION_GRID>areas>lines>simplify

#7:Create TIGHT_GROUND_GRID from layer 0

#region 8: Generate CONTOUR_LAYER from TIGHT_GROUND_GRID (layerlist[3])
arr_ptr, arr_size = gm.GetLoadedLayerList()                         #                                                                   makes new array of layers (after creation of the grids)
layer_list = gm.GM_LayerHandle_array_frompointer(arr_ptr)           #                                                                   contour settings
contour_params = gm.GM_ContourParams_t()                            #
contour_params.mIntervalInFeet = 50                                 #
contour_params.mShowProgress = False                                #
err, contour_layer = gm.GenerateContours(layer_list[2], contour_params)#                                                                makes contours out ot the layer assigned to ptr=2/3rd layer (the grid)
print("E: New Contours Created for Layer 0")
#endregion

#9: Clip CONTOUR LAYER to KML and OBSTRUCTION_AREAS

#region 10: Export OBSTRUCTION_LINES&CONTOUR_LAYER to dxf
# arr_ptr, arr_size = gm.GetLoadedLayerList()                         #                                                                   makes new array of layers
# layerlist = gm.GM_LayerHandle_array_frompointer(arr_ptr)           #
# gm.ExportVector("C:\\Users\\AirWorksProcessing\\Documents\\toposcript\\output\\contours.dxf", gm.GM_Export_DXF, layerlist[3], None, gm.GM_VectorExportFlags_HideProgress, 0x0)
# print("F: Contours Exported to output folder")                      #
#endregion