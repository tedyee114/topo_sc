from pickle import TRUE
import globalmapper as gm
from os import listdir

arr_ptr, arr_size = gm.GetLoadedLayerList()                                     #makes new array of layers
B = gm.GM_LayerHandle_array_frompointer(arr_ptr)   

#region 6: MERGED_GRID=LOOSE_GROUND_GRID+BW_GRID
cs = gm.GM_GridCombineSetup_t ()
cs.mCombineOp = 0
cs.mLayer1 = B[4]
cs.mLayer2 = B[5]
print ("hi")
MERGED_GRID = gm.CombineTerrainLayers(cs, 0x0)
print (MERGED_GRID)
#endregion