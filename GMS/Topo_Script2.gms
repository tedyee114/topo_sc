
//Set editing language set to C# in VScode so that // works for comments
//Made by Ted Yee 2023-10-17 for Airworks Inc.
// Must start with files named 'kml_grid'(already gridded), 'kml', 'pointcloud', 'overhang', and 'water'
// Polygons limited to 99999 vertices, may need to raise that in the code
// Units automatically taken from pointcloud and printed to the console, can only be changed via the code
//
//THIS IS PART 2 OF THE SCRIPT, Topo_Script1.gms must be run, then contours manually cropped, then this

GLOBAL_MAPPER_SCRIPT VERSION="1.00"


//8: EXPORT into DXF
	SPLIT_LAYER \
        FILENAME="obs_polygons" \
        SPLIT_BY_ATTR="<Feature Desc>"
    EDIT_VECTOR \
        FILENAME="obs_polygons - Unknown Line Type"\
        STYLE_ATTR="LINE_COLOR=RGB(255,0,0)" \
		ATTR_VAL="<Feature Desc>=A-OBSTRUCTION"
    
    SPLIT_LAYER \
        FILENAME="contours" \
        SPLIT_BY_ATTR="<Feature Desc>"
    EDIT_VECTOR \
        FILENAME="contours - Contour Line, Intermediate"\
        STYLE_ATTR="LINE_COLOR=RGB(128,128,128)" \
		ATTR_VAL="<Feature Desc>=G-TOPO-MINR"
    EDIT_VECTOR \
        FILENAME="contours - Contour Line, Major"\
        STYLE_ATTR="LINE_COLOR=RGB(192,192,192)" \
		ATTR_VAL="<Feature Desc>=G-TOPO-MAJR"

    
    EXPORT_VECTOR \
		FILENAME=obslayer_contour.dxf \
		TYPE=DXF \
		EXPORT_LAYER="obs_polygons - Unknown Line Type"\
	    EXPORT_LAYER="contours - Contour Line, Intermediate" \
        EXPORT_LAYER="contours - Contour Line, Major" \
		SHAPE_TYPE=LINES \
		GEN_PRJ_FILE=NO \
		SPLIT_BY_ATTR=NO \
		SPATIAL_RES_METERS=0.3\
		FILENAME_ATTR_LIST="<Feature Name>"
     LOG_MESSAGE %TIMESTAMP%: Step8 done: file exported.



//9: See new DXF and hide all other layers
	LAYER_LOOP_START \
        FILENAME="*" \
        VAR_NAME_PREFIX="HIDE"
    SET_LAYER_OPTIONS \
        FILENAME="%HIDE_FNAME_W_DIR%" \
        HIDDEN=YES
	LAYER_LOOP_END
	import FILENAME=obslayer_contour.dxf USE_DEFAULT_PROJ=YES