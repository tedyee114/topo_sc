from pickle import TRUE
import globalmapper as gm
from os import listdir

# close all layers that may be open#####################################################################################################
layers_are_open = gm.GetLoadedLayerList()                           #                                                                   layers_are_open = self-explanatory
if layers_are_open:                                                 #                                                                   makes an array of open layers
    arr_ptr, arr_size = layers_are_open                             #
    initial_layers = gm.GM_LayerHandle_array_frompointer(arr_ptr)   #                                                                   assigns the layers ptr's (ID numbers, starting at 0)
    for i in range(arr_size):                                       #                                                                   iterates through and closes layers
        gm.CloseLayer(initial_layers[i])                            #
print("A: All Files Unloaded")#######################################


# filenames= array ofall files in the directory with the desired extension(s)###########################################################
path = "C:\\Users\\AirWorksProcessing\\Documents\\toposcript\\"		#
dir_files = listdir(path)											#
filenames = []														#
for f in dir_files:													#
    file = f.lower()												#
    if file.endswith(".laz") or file.endswith(".las"): # or file.endswith(".tar") or file.endswith(".gz"):
        filenames.append(file)										#
        print("B: New File Found")###################################


# loop over and load in all the found files############################################################################################
for filename in filenames:                                          #
    err, arr_ptr, arr_size = gm.LoadLayerList(path + filename, gm.GM_LoadFlags_UseDefaultLoadOpts)
    layer_arr = gm.GM_LayerHandle_array_frompointer(arr_ptr)        #
    print("C: New File Loaded")######################################

# generate an elevation grid for layer 0   ############################################################################################
arr_ptr, arr_size = gm.GetLoadedLayerList()                         #                                                                   makes new array of layers
layer_list = gm.GM_LayerHandle_array_frompointer(arr_ptr)           #
grid_setup = gm.GM_GridGenSetup_t()                                 #
grid_setup.mGridAlg = gm.GM_GridAlg_BinAverage                      #
grid_setup.mElevUnits = gm.GM_ElevUnit_Meters                       #
err, grid_layer = gm.GenerateElevationGrid2([layer_list[0]], grid_setup)#                                                               makes a grid out of the layer assigned to ptr=0 (the pointcloud)
print("D: Grid Created for Layer 0")#################################

# generate the contour lines from layer 2 (3rd)########################################################################################
arr_ptr, arr_size = gm.GetLoadedLayerList()                         #                                                                   makes new array of layers (after creation of the grids)
layer_list = gm.GM_LayerHandle_array_frompointer(arr_ptr)           #                                                                   contour settings
contour_params = gm.GM_ContourParams_t()                            #
contour_params.mIntervalInFeet = 50                                 #
contour_params.mShowProgress = False                                #
err, contour_layer = gm.GenerateContours(layer_list[2], contour_params)#                                                                makes contours out ot the layer assigned to ptr=2/3rd layer (the grid)
print("E: New Contours Created for Layer 0")#########################

# export the contours##################################################################################################################
arr_ptr, arr_size = gm.GetLoadedLayerList()                         #                                                                   makes new array of layers
layer_list = gm.GM_LayerHandle_array_frompointer(arr_ptr)           #
gm.ExportVector("C:\\Users\\AirWorksProcessing\\Documents\\toposcript\\output\\contours.dxf", gm.GM_Export_DXF, layer_list[3], None, gm.GM_VectorExportFlags_HideProgress, 0x0)
print("F: Contours Exported to output folder")                      #
