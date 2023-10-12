gm.GenerateElevationGrid(POINTCLOUD, )

# generate an elevation grid with all the loaded layers
    grid_setup = gm.GM_GridGenSetup_t()
    #grid layer name
    grid_setup.mGridAlg = gm.GM_GridAlg_BinAverage
    grid_setup.mElevUnits = gm.GM_ElevUnit_Feet
    #spacing=1ft
    #grid_setup.mTightnessMult = 0.5
    #grid_setup.mBounds = KML????
    err, grid_layer = gm.GenerateElevationGrid2([layers_arr[0]], grid_setup)