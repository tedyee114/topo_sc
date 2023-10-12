from pickle import TRUE
import globalmapper as gm
from os import listdir

# close all layers that may be open####################################################################################################
layers_are_open = gm.GetLoadedLayerList()                           #
if layers_are_open:                                                 #
    arr_ptr, arr_size = layers_are_open                             #
    initial_layers = gm.GM_LayerHandle_array_frompointer(arr_ptr)   #
    for i in range(arr_size):                                       #
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

# loop over and load in all the found files, then assign them a ptr (ID number)########################################################
for filename in filenames:                                          #
    err, arr_ptr, arr_size = gm.LoadLayerList(path + filename, gm.GM_LoadFlags_UseDefaultLoadOpts)
    layer_arr = gm.GM_LayerHandle_array_frompointer(arr_ptr)        #
    layer = layer_arr[0]                                            #
    print("C: New File Loaded")######################################

layers_are_open = gm.GetLoadedLayerList()
arr_ptr, arr_size = layers_are_open
initial_layers = gm.GM_LayerHandle_array_frompointer(arr_ptr)
for i in range(arr_size):
   print(initial_layers[i])

# generate an elevation grid for layer 0   ############################################################################################
grid_setup = gm.GM_GridGenSetup_t()                                 #
grid_setup.mGridAlg = gm.GM_GridAlg_BinAverage                      #
grid_setup.mElevUnits = gm.GM_ElevUnit_Meters                       #
err, grid_layer = gm.GenerateElevationGrid2([initial_layers[0]], grid_setup)
print("D: Grid Created for Layer 0")#################################

layers_are_open = gm.GetLoadedLayerList()
arr_ptr, arr_size = layers_are_open
new_array = gm.GM_LayerHandle_array_frompointer(arr_ptr)
for i in range(arr_size):
   print(new_array[i])

# generate the contour lines at intervals of 50 feet###################################################################################
contour_params = gm.GM_ContourParams_t()                        #
contour_params.mIntervalInFeet = 50                             #
contour_params.mShowProgress = False                            #
err, contour_layer = gm.GenerateContours(new_array[2], contour_params) #
print("E: New Contours Created for Layer 0")#########################

layers_are_open = gm.GetLoadedLayerList()
arr_ptr, arr_size = layers_are_open
final_array = gm.GM_LayerHandle_array_frompointer(arr_ptr)
for i in range(arr_size):
   print(final_array[i])

# export the contours##################################################################################################################
gm.ExportVector("C:\\Users\\AirWorksProcessing\\Documents\\contours.dxf", gm.GM_Export_DXF, final_array[3], None, gm.GM_VectorExportFlags_GenPRJFile, 0x0)
print("F: Contours Exported to output folder")

# # close the layers after we're done with them
# gm.CloseLayer(pointcloudlayer)
# gm.CloseLayer(contour_layer)