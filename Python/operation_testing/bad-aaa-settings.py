from pickle import TRUE
import globalmapper as gm

arr_ptr, arr_size = gm.GetLoadedLayerList()                                     #makes new array of layers
B = gm.GM_LayerHandle_array_frompointer(arr_ptr)

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
print(LOOSE_GROUND_GRID)
print("D: Grid Created for Layer 1")