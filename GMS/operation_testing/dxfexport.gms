GLOBAL_MAPPER_SCRIPT
//for rasterization of .tif, .laz or .las files into a single .tif file

//IMPORT FILENAME "C:\\Users\\AirWorksProcessing\\Documents\\toposcript\\MERLIN.LAZ"
EXPORT_VECTOR \
		FILENAME="C:\\Users\\ted_airworks.io\\Documents\\Scripts\\contour2.dxf" \
		TYPE=DXF \
		EXPORT_LAYER="obs_area"\
	    EXPORT_LAYER="contours"\
		SHAPE_TYPE=LINES \
		GEN_PRJ_FILE=NO \
		SPLIT_BY_ATTR=NO \
		SPATIAL_RES_METERS=0.25\
		FILENAME_ATTR_LIST="<Feature Name>"

//UNLOAD_ALL