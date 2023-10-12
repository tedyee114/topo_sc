from pickle import TRUE
import globalmapper as gm
from os import listdir
import sys
#from tkinter import Tk
#from tkinter.filedialog import askdirectory

arr_ptr, arr_size = gm.GetLoadedLayerList()                         #mDatum=14....NAD83                                                makes new array of layers
layerlist = gm.GM_LayerHandle_array_frompointer(arr_ptr)            #mDatum=23....WGS84


#elev = gm.GetAreaFeature([layerlist[0]], 0)
eleva = gm.GetFeatureElevation(layerlist[0], gm.GM_FeatureClass_Area, 0)
print (eleva)
if eleva[0] == 58:
	print("bad")
	sys.exit()
else:
	print("good")

elevb = gm.GetFeatureElevation(layerlist[1], gm.GM_FeatureClass_Area, 0)
print (elevb)
if elevb[0] == 58:
	print("bad")
else:
	print("good")