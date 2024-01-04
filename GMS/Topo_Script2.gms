//Set editing language set to C# in VScode so that // works for comments
//Made by Ted Yee 2023-10-17 for Airworks Inc.
//Must start with files named 'kml_grid'(already gridded), 'kml', and 'pointcloud'
//when selecting base file, it will ask if you want to overwrite the file, just ignore it
//Polygons limited to 99999 vertices, may need to raise that in the code
//Units automatically taken from pointcloud and printed to the console, can only be changed via the code

GLOBAL_MAPPER_SCRIPT VERSION="1.00"
//9: Read user-inputted values that were stored (as a workaround) as pointcloud attributes
    QUERY_LAYER_METADATA                \
        METADATA_LAYER="pointcloud"     \
        METADATA_ATTR="OUTPUTFOLDER"    \
        RESULT_VAR=%OUTPUTFOLDER%

    QUERY_LAYER_METADATA                \
        METADATA_LAYER="pointcloud"     \
        METADATA_ATTR="RES_M"           \
        RESULT_VAR=%RES_M%
    LOG_MESSAGE %TIMESTAMP%: Step9 done: read settings from Topo_Script1

//10: Export 3 layers and base dxf from second import of Topo_Script1
    EXPORT_ANY                          \
		FILENAME=%OUTPUTFOLDER%basedxf_with_obs_contours.dxf \
		TYPE=DXF                        \
		EXPORT_LAYER="obs_polygons"     \
	    EXPORT_LAYER="G-TOPO-MINR"      \
        EXPORT_LAYER="G-TOPO-MAJR"      \
        EXPORT_LAYER="basedxf"          \
		GEN_PRJ_FILE=NO                 \
		SPLIT_BY_ATTR=NO                \
		SPATIAL_RES_METERS=%RES_M%
    LOG_MESSAGE %TIMESTAMP%: Step10 done: file exported to %OUTPUTFOLDER%


//11: Import new DXF and hide all other layers
	LAYER_LOOP_START \
        FILENAME="*" \
        VAR_NAME_PREFIX="HIDE"
    SET_LAYER_OPTIONS \
        FILENAME="%HIDE_FNAME_W_DIR%" \
        HIDDEN=YES
	LAYER_LOOP_END
    
	IMPORT FILENAME=%OUTPUTFOLDER%basedxf_with_obs_contours.dxf USE_DEFAULT_PROJ=YES
    LOG_MESSAGE %TIMESTAMP%: Step11 done: new file opened and other layers turned off

LOG_MESSAGE  Process Complete; Elapsed time: %TIME_SINCE_START%