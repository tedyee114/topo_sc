import globalmapper as gm
from os import listdir

# retrieve all lidar files in the directory
source_directory = "C:\\Users\\AirWorksProcessing\\Documents\\toposcript\\"     # choose a source directory containing lidar data
dir_files = listdir(source_directory)
filenames = []
for f in dir_files:
    file = f.lower()
    if file.endswith(".las") or file.endswith(".laz"):
        filenames.append(file)

# modify the display options
vert_display_opts = gm.GM_VerticalDisplayOptions_t()
vert_display_opts.mHillShading = True
vert_display_opts.mShaderName = "Slope Shader"
gm.SetVerticalDisplayOptions(vert_display_opts)

# loop through all the lidar layers
for file in filenames:
    err, arr_ptr, arr_size = gm.LoadLayerList(source_directory + file, gm.GM_LoadFlags_UseDefaultLoadOpts)
    layers_arr = gm.GM_LayerHandle_array_frompointer(arr_ptr)

# generate an elevation grid with all the loaded layers
    grid_setup = gm.GM_GridGenSetup_t()
    grid_setup.mGridAlg = gm.GM_GridAlg_BinAverage
    grid_setup.mElevUnits = gm.GM_ElevUnit_Meters
    err, grid_layer = gm.GenerateElevationGrid2([layers_arr[0]], grid_setup)

	# get the right dimensions for the image
    bounds = gm.GetLayerInfo(grid_layer).mGlobalRect
    ratio = abs(bounds.mMaxX - bounds.mMinX) / abs(bounds.mMaxY - bounds.mMinY)
    width = 1920
    height = width * (1 / ratio)
    if height < 1080:   # make sure the exported layers are at least HD
        height = 1080
        width = height * ratio
    width = int(width)
    height = int(height)

# export the raster image
    target_dir = "C:\\Users\\AirWorksProcessing\\Documents\\toposcript\\"  # choose a directory that you may write to
    gm.ExportRaster(target_dir + file + " elevation grid.jpg", gm.GM_Export_JPG , grid_layer, None, width, height, 0x0)
    gm.CloseLayer(layers_arr[0])
    gm.CloseLayer(grid_layer)