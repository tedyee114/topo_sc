import globalmapper as gm
#x=10
#print(x)
#print(id(x))
#print(gm.GM_LoadFlags_UseDefaultLoadOpts)
#print(gm.GM_ExportOptsDXF_DWG_t().mCADType)
#dxf_options = gm.GM_ExportOptsDXF_DWG_t()
#dxf_options.mCADType=255
#print(dxf_options)
#print(contour_layer)

# print all open layers' pointers
layers_are_open = gm.GetLoadedLayerList()
arr_ptr, arr_size = layers_are_open
initial_layers = gm.GM_LayerHandle_array_frompointer(arr_ptr)
for i in range(arr_size):
   print(initial_layers[i])

#print(initial_layers[0])


gm.ExportVector("C:\\Users\\AirWorksProcessing\\Documents\\toposcript\\output\\python-contours.dxf", gm.GM_Export_DXF, initial_layers[1], None, gm.GM_VectorExportFlags_HideProgress + gm.GM_VectorExportFlags_GenPRJFile, 0x0)
print ("Yayyyyyy, it did it")