//Set editing language set to C# in VScode so that // works for comments
//Made by Ted Yee 2023-10-17 for Airworks Inc.
//Must start with files named 'kml_grid'(already gridded), 'kml', and 'pointcloud'
//when selecting base file, it will ask if you want to overwrite the file, just ignore it
//Polygons limited to 99999 vertices, may need to raise that in the code
//Units automatically taken from pointcloud and printed to the console, can only be changed via the code

GLOBAL_MAPPER_SCRIPT VERSION="1.00"

    SET_LAYER_OPTIONS FILENAME="A-OBSTRUCTION" HIDDEN=NO
    SET_LAYER_OPTIONS FILENAME="G-TOPO-MINR"   HIDDEN=NO
    SET_LAYER_OPTIONS FILENAME="G-TOPO-MAJR"   HIDDEN=NO
	SET_LAYER_OPTIONS FILENAME="basedxf"       HIDDEN=NO


//9: Export 3 layers and base dxf from second import of Topo_Script1
    EXPORT_VECTOR                       \
		FILENAME=basedxf_with_obs_contours.dxf \
		TYPE=DXF                        \
		EXPORT_LAYER="obs_polygons"     \
	    EXPORT_LAYER="G-TOPO-MINR"      \
        EXPORT_LAYER="G-TOPO-MAJR"      \
        EXPORT_LAYER="basedxf"          \
		GEN_PRJ_FILE=NO                 \
		SPLIT_BY_ATTR=NO                \
		SPATIAL_RES_METERS=0.3
    LOG_MESSAGE %TIMESTAMP%: Step9 done: file exported as basedxf_with_obs_contours.dxf


//10: Import new DXF and hide all other layers
	SET_LAYER_OPTIONS \
        FILENAME="*" \
        HIDDEN=YES
    
	IMPORT FILENAME=basedxf_with_obs_contours.dxf USE_DEFAULT_PROJ=YES
    LOG_MESSAGE %TIMESTAMP%: Step10 done: new file opened and other layers turned off

LOG_MESSAGE  Process Complete; Elapsed time: %TIME_SINCE_START%