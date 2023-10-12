import globalmapper as gm
from os import listdir

#import
gm.LoadLayerList ("C:\\Users\\AirWorksProcessing\\Documents\\toposcript\\MERLIN.laz", gm.GM_LoadFlags_UseDefaultLoadOpts)

# generate an elevation grid with all the loaded layers
   # grid_setup = gm.GM_GridGenSetup_t()
    #grid_setup.mGridAlg = gm.GM_GridAlg_BinAverage
    #grid_setup.mElevUnits = gm.GM_ElevUnit_Meters
    #err, grid_layer = gm.GenerateElevationGrid2(["MERLIN.laz", grid_setup)

# generate an elevation grid with all the loaded layers
    #grid layer name
    #gm.GM_GridGenSetup.mGridAlg (gm.GM_GridAlg_BinAverage, gm.GM_ElevUnit_Feet)
    #spacing=1ft
    #grid_setup.mTightnessMult = 0.5
    #grid_setup.mBounds = KML????
    #gm.GenerateElevationGrid2([layers_arr[0]], gm.GM_GridGenSetup_t gm.GM_GridAlg_BinAverage + gm.GM_ElevUnit_Feet)

#export
gm.ExportRaster ("C:\\Users\\AirWorksProcessing\\Documents\\toposcript\\image.tif",gm.GM_Export_GeoTIFF, gm.NULL, None, 1000, 1000, gm.NULL)