import globalmapper as gm

layers_are_open = gm.GetLoadedLayerList()
arr_ptr, arr_size = layers_are_open
layers_arr = gm.GM_LayerHandle_array_frompointer(arr_ptr)
#print(layers_arr[0])

# generate the contour lines at intervals of 50 feet
contour_params = gm.GM_ContourParams_t()
contour_params.mIntervalInFeet = 50
contour_params.mShowProgress = True
err, contour_layer = gm.GenerateContours(layers_arr[2], contour_params)
print("D-contours created")