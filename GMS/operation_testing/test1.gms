//Set editing language set to C# in VScode so that // works for comments
//Made by Ted Yee 2023-10-17 for Airworks Inc.
// Must start with files named 'kml_grid'(already gridded), 'kml', 'pointcloud', 'overhang', and 'water'
// Polygons limited to 99999 vertices, may need to raise that in the code
// Units automatically taken from pointcloud and printed to the console, can only be changed via the code

GLOBAL_MAPPER_SCRIPT VERSION="1.00"
//0: Enter Settings and Import Files (but they should already be open)
    //DEFINE_VAR\
        //NAME="FILEORFOLDER"\
        //PROMPT="Single file=YES, Many tiles in a folder=NO"
    //IF COMPARE_STR="%FILEORFOLDER%=YES"
        //DEFINE_VAR NAME="INPUTFILE" PROMPT=FILE ABORT_ON_CANCEL PROMPT_TEXT="INPUT FILE?"
        //IMPORT FILENAME="%INPUTFILE%"
        //END_IF
    // ELSE COMPARE_STR="%FILEORFOLDER%=YES"
        //DEFINE_VAR NAME="INPUTPUTFOLDER" PROMPT=DIR ABORT_ON_CANCEL PROMPT_TEXT="Output Folder?"
        //DIR_LOOP_START DIRECTORY="%INPUTFOLDER%" FILENAME_MASKS= "*.las" RECURSE_DIR=YES
        //IMPORT FILENAME="%FNAME_W_DIR%"
        //DIR_LOOP_END
        //END_IF
    // SPLIT_LAYER \
    //     FILENAME="base_file" \
    //     SPLIT_BY_ATTR=<Feature Desc>

    DEFINE_VAR NAME="BASEDXF" PROMPT=FILE ABORT_ON_CANCEL PROMPT_TEXT="Base DXF (contains B-OVERHANG, W-WATER and will be merged with A-OBSTRUCTION and G-TOPO-...?"
    DEFINE_VAR NAME="OUTPUTFOLDER" PROMPT=DIR ABORT_ON_CANCEL PROMPT_TEXT="Output Folder?"
    DEFINE_VAR NAME="RES_M" PROMPT ABORT_ON_CANCEL PROMPT_TEXT="Enter spatial resolution in meters for data_grid, obs_grid and output. Suggested 0.3"
    DEFINE_VAR NAME="ISLANDMIN" PROMPT ABORT_ON_CANCEL PROMPT_TEXT="Enter minimum area size of obstuction layer in sq ft. Suggested 200"
    DEFINE_VAR NAME="MINR" PROMPT ABORT_ON_CANCEL PROMPT_TEXT="Minor contour intervals in feet, suggested=1"
    DEFINE_VAR NAME="MAJR" PROMPT ABORT_ON_CANCEL PROMPT_TEXT="Major contour intervals in feet, suggested=5"
    //splits base dxf and extracts overhang and water layers
    IMPORT FILENAME="%BASEDXF%"  USE_DEFAULT_PROJ=YES
    SPLIT_LAYER                                         \
        FILENAME="%BASEDXF%"                            \
        SPLIT_BY_ATTR="<Feature Desc>"
    EDIT_VECTOR                                         \
        FILENAME="*B-OVERHANG"                          \
        MOVE_TO_NEW_LAYER=YES                           \
        NEW_LAYER_NAME="overhang"
    EDIT_VECTOR                                         \
        FILENAME="*W-WATER"                             \
        MOVE_TO_NEW_LAYER=YES                           \
        NEW_LAYER_NAME="water"

    //rest of the bllock finds and sets the units
    QUERY_LAYER_METADATA \
        RESULT_VAR=%UNITS% \
        METADATA_LAYER="pointcloud" \
        METADATA_ATTR="PROJ_UNITS"
    QUERY_LAYER_METADATA \
        RESULT_VAR=%pc_epsg% \
        METADATA_LAYER="pointcloud" \
        METADATA_ATTR="EPSG_CODE"
    LOG_MESSAGE Detected pointcloud units were %UNITS%. This will be used for all horizontal and vertical projections

    LOG_MESSAGE %TIMESTAMP%: Step0 Complete, startfile loaded

//1: QC Pointcloud Classification
    //I could theoretically add an autoclassification, but that's not how we do it
    LOG_MESSAGE %TIMESTAMP%: Step1 MANUALLY SKIPPED!!!!: no pointcloud classification needed

//2:  Create data_grid from ground points, buildings, and water polygons
    GENERATE_ELEV_GRID \
        FILENAME="pointcloud"\
        FILENAME="overhang"\
        FILENAME="water"\
        LAYER_DESC="data_grid"\
        //lidar 2 means points assigned to the ground class (segmentation)
        LIDAR_FILTER=2\
        GRID_TYPE=ELEVATION\
        GRID_ALG=BIN_AVG\
        ELEV_UNITS=%UNITS%\
        SPATIAL_RES_METERS=%RES_M%\
        NO_DATA_DIST_MULT=0
    LOG_MESSAGE %TIMESTAMP%: Step2 done: data_grid Generated

//3: Create KML GRID -- for now, the elevation grid must be added before the script.
    // assign KML points elevations from any loaded terrain data (see page 96 https://www.bluemarblegeo.com/knowledgebase/global-mapper-21/GlobalMapper_ScriptingReference.pdf)
    EDIT_VECTOR \
        APPLY_ELEVS=YES \
	    FILENAME="kml"\
        REPLACE_EXISTING=YES
    GENERATE_ELEV_GRID \
        FILENAME="kml"\
        LAYER_DESC="kml_grid"\
        GRID_TYPE=ELEVATION\
        GRID_ALG=BIN_AVG\
        ELEV_UNITS=%UNITS%\
        SPATIAL_RES_METERS=0.9\
        NO_DATA_DIST_MULT=0
    LOG_MESSAGE %TIMESTAMP%: Step3 MANUALLY SKIPPED!!!!: kml_grid should have been generated before script

//4: KML GRID-MERGED GRID=OBSTRUCTION GRID
    COMBINE_TERRAIN \
        LAYER1_FILENAME="kml_grid"\
        LAYER2_FILENAME="data_grid"\
        COMBINE_OP=FILTER_KEEP_FIRST_IF_SECOND_INVALID\
        LAYER_DESC="obs_grid"\
        ELEV_UNITS=%UNITS%\
        SPATIAL_RES_METERS=%RES_M%
    LOG_MESSAGE %TIMESTAMP%: Step4 done: obstruction_grid generated


//5: OBSTRUCTION GRID>areas>simplify>lines
    GENERATE_LAYER_BOUNDS \
        FILENAME="obs_grid"\
        LAYER_DESC="obs_areas"\
        BOUNDS_TYPE=POLYGON\
		MAX_VERTEX_COUNT=99999
    EDIT_VECTOR \
        FILENAME="obs_areas"\
        CONVERT_AREAS_TO_LINES=YES\
		SMOOTH_FEATURES=YES\
        STYLE_ATTR="LINE_COLOR=RGB(255,0,0)"
    LOG_MESSAGE %TIMESTAMP%: Step5 done: grid>areas>simplify>lines


//6: Delete islands smaller than %ISLANDMIN% sq ft
	//adds area value to entity's attribute list
	ADD_MEASURE_ATTRS \
		FILENAME="obs_areas" \
		AREA_UNITS="SQUARE FEET" \
		MEASURE_UNIT_TYPE="BASE"    
	
    //deletes entities with area attrubute smaller than %ISLANDMIN% sq ft
	EDIT_VECTOR \
		FILENAME="obs_areas"\
		DELETE_FEATURES=YES \
		AREA_UNITS="SQUARE FEET" \
		COMPARE_STR="ENCLOSED_AREA<%ISLANDMIN%" \
		COMPARE_NUM=YES

    SPLIT_LAYER                                         \
        FILENAME="obs_areas"                            \
        SPLIT_BY_ATTR="<Feature Desc>"

    EDIT_VECTOR                                         \
        FILENAME="obs_areas - Unknown Line Type"        \
		ATTR_VAL="<Feature Desc>=A-OBSTRUCTION"         \
        STYLE_ATTR="LINE_COLOR=RGB(255,0,0)"            \
        MOVE_TO_NEW_LAYER=YES                           \
		NEW_LAYER_NAME="obs_polygons"
    
    LOG_MESSAGE %TIMESTAMP%: Step6 done: small islands removed


//7: Create NEW/LOOSER GROUND GRID>contours only within obstrucion and KML
    GENERATE_ELEV_GRID \
        FILENAME="pointcloud" \
        LAYER_DESC="loose_data_grid_for_contours"\
        GRID_TYPE=ELEVATION\
		LIDAR_FILTER=2\
        LAYER_BOUNDS="kml"\ 
        GRID_ALG=BIN_AVG\
        ELEV_UNITS=%UNITS%\
        SPATIAL_RES_METERS=%RES_M%\
        NO_DATA_DIST_MULT=3
    GENERATE_CONTOURS \
        FILENAME="loose_data_grid_for_contours" \
        LAYER_DESC="contours"\
        INTERVAL=1\
        ELEV_UNITS=feet \
        MULT_MINOR=%MINR%\
        MULT_MAJOR=%MAJR%\
		SAMPLING_METHOD=BOX_4x4 \
        SMOOTH_CONTOURS=YES \
        MIN_CONTOUR_LEN=6 \
        LAYER_BOUNDS="kml" \
        POLYGON_CROP_FILE="obs_polygons"\        //cropping to obs areas is the longest time, doing it during export is much faster but then they crop themselves. Maybe make two outputs to join in outer python script?
		POLYGON_CROP_USE_ALL=YES\
		POLYGON_CROP_EXCLUDE=YES

    SPLIT_LAYER                                         \
        FILENAME="contours"                             \
        SPLIT_BY_ATTR="<Feature Desc>"
    
    EDIT_VECTOR                                         \
        FILENAME="contours - Contour Line, Intermediate"\
		ATTR_VAL="<Feature Desc>=G-TOPO-MINR"           \
        STYLE_ATTR="LINE_COLOR=RGB(128,128,128)"        \
        MOVE_TO_NEW_LAYER=YES                           \
		NEW_LAYER_NAME="G-TOPO-MINR"

    EDIT_VECTOR                                         \
        FILENAME="contours - Contour Line, Major"       \
		ATTR_VAL="<Feature Desc>=G-TOPO-MAJR"           \
        STYLE_ATTR="LINE_COLOR=RGB(192,192,192)"        \
        MOVE_TO_NEW_LAYER=YES                           \
		NEW_LAYER_NAME="G-TOPO-MAJR"

    LOG_MESSAGE %TIMESTAMP%: Step7 done: UNClipped Contours Generated, split and individually colored, not whole layer colored

LOG_MESSAGE  Process Complete; Elapsed time %TIME_SINCE_START% Please now crop the contours to the obs_polygons and then run the python scripto


//9: Export 3 layers
    IMPORT FILENAME="%BASEDXF%"
    EXPORT_VECTOR                                   \
		FILENAME=%OUTPUTFOLDER%basedxf_with_obs_contours.dxf \
		TYPE=DXF                                    \
		EXPORT_LAYER="obs_polygons"                 \
	    EXPORT_LAYER="G-TOPO-MINR"                  \
        EXPORT_LAYER="G-TOPO-MAJR"                  \
        EXPORT_LAYER="%BASEDXF%"                    \
		SHAPE_TYPE=LINES                            \
		GEN_PRJ_FILE=NO                             \
		SPLIT_BY_ATTR=NO                            \
		SPATIAL_RES_METERS=%RES_M%                  \
		FILENAME_ATTR_LIST="<Feature Name>"
    LOG_MESSAGE %TIMESTAMP%: Step9 done: file exported to %OUTPUTFOLDER%.


//10: See new DXF and hide all other layers
	LAYER_LOOP_START \
        FILENAME="*" \
        VAR_NAME_PREFIX="HIDE"
    SET_LAYER_OPTIONS \
        FILENAME="%HIDE_FNAME_W_DIR%" \
        HIDDEN=YES
	LAYER_LOOP_END
	import FILENAME=%OUTPUTFOLDER%basedxf_with_obs_contours.dxf USE_DEFAULT_PROJ=YES
    LOG_MESSAGE %TIMESTAMP%: Step10 done: new file opened and other layers turned off

LOG_MESSAGE  Process Complete; Elapsed time %TIME_SINCE_START%