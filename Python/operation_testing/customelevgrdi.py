from pickle import TRUE
import globalmapper as gm
from os import listdir

B = gm.GM_LayerHandle_array_frompointer(arr_ptr)                                #mDatum=23....WGS84
kmlelevation = gm.GetFeatureElevation(B[1], gm.GM_FeatureClass_Area, 0)         #mDatum=14....NAD83

a = gm.GetProjection()
gm.CreateCustomElevGridLayerEx(None, a, 0, B[1], 0)
