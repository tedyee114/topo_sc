import globalmapper as gm
from os import listdir

# close all layers that may be open
layers_are_open = gm.GetLoadedLayerList()
if layers_are_open:
    arr_ptr, arr_size = layers_are_open
    initial_layers = gm.GM_LayerHandle_array_frompointer(arr_ptr)
    for i in range(arr_size):
        gm.CloseLayer(initial_layers[i])

# retrieve all files in the directory with the desired extension(s)
path = r"C:\\Users\\AirWorksProcessing\\Documents\\toposcript\\"
dir_files = listdir(path)
filenames = []
for f in dir_files:
    file = f.lower()
    if file.endswith(".laz") or file.endswith(".las"): # or file.endswith(".tar") or file.endswith(".gz"):
        filenames.append(file)

# loop over and load in all the found files
for filename in filenames:
    err, arr_ptr, arr_size = gm.LoadLayerList(path + filename, gm.GM_LoadFlags_UseDefaultLoadOpts)
    layer_arr = gm.GM_LayerHandle_array_frompointer(arr_ptr)
    layer = layer_arr[0]

# generate the contour lines at intervals of 50 feet
    contour_params = gm.GM_ContourParams_t()
    contour_params.mIntervalInFeet = 50
    contour_params.mShowProgress = False
    err, contour_layer = gm.GenerateContours(layer, contour_params)

# export the contours
    target_dir = r"C:\\Users\\AirWorksProcessing\\Documents\\toposcript\\"
    filename_wo_ext = filename[:filename.index(".")]
    gm.ExportVector(target_dir + filename_wo_ext + "_contours.dxf", gm.GM_Export_DXF, contour_layer, None, gm.GM_VectorExportFlags_HideProgress + gm.GM_VectorExportFlags_GenPRJFile, 0x0)
    gm.ExportVector(target_dir + filename_wo_ext + "_contours.shp", gm.GM_Export_Shapefile, contour_layer, None, gm.GM_VectorExportFlags_HideProgress + gm.GM_VectorExportFlags_GenPRJFile + gm.GM_VectorExportFlags_ExportLines + gm.GM_VectorExportFlags_Export3D, 0x0)

# close the layers after we're done with them
    gm.CloseLayer(layer)
    gm.CloseLayer(contour_layer)