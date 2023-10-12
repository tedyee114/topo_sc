import globalmapper as gm

#import
gm.LoadLayerList ("C:\\Users\\AirWorksProcessing\\Documents\\toposcript\\MERLIN.laz", gm.GM_LoadFlags_UseDefaultLoadOpts)

#export
gm.ExportRaster ("C:\\Users\\AirWorksProcessing\\Documents\\toposcript\\image.tif",gm.GM_Export_GeoTIFF, gm.NULL, None, 1000, 1000, gm.NULL)