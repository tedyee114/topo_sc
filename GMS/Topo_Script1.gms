//Editing language set to C++ in VScode becuase .gms and .cpp both use // for comments and there's no .gms debugger
//Made by Ted Yee 2023-10-17 for Airworks Inc.
//Unlicensed, contains no proprietary infomation
//
//must start with files named "kml"(already gridded, "pointcloud", "overhang", "water"

GLOBAL_MAPPER_SCRIPT VERSION="1.00"
//need to add variable units for that later, currently hard-coded to feet

//0: all files must imported before being operated upon below (even though it requests the filepath again)
    //use this block to import all files from a folder
    //DEFINE_VAR\
        //NAME="FILEORFOLDER"\
        //PROMPT="Single file=YES, Many tiles in a folder=NO"
    //IF COMPARE_STR="%FILEORFOLDER%=YES"
    //DEFINE_VAR\
        //NAME="FILE"
        //PROMPT="SELECT A FILE"
            //FILE
    //IMPORT FILENAME="%FILE%"
    //END_IF

    //ELSE COMPARE_STR="%FILEORFOLDER%=YES"
    //DEFINE_VAR\
        //NAME="FOLDER"
        //PROMPT="SELECT A FOLDER CONTAINING DESIRED POINTCLOUDS"
            //DIR
    //DIR_LOOP_START DIRECTORY="%FOLDER%" FILENAME_MASKS= "*.tif" RECURSE_DIR=YES
    //IMPORT FILENAME="%FNAME_W_DIR%"
    //DIR_LOOP_END
	//END_IF
	// import FILENAME="C:\\Users\\AirWorksProcessing\\Documents\\Scripts\\2710.las"
    // import FILENAME="C:\\Users\\AirWorksProcessing\\Documents\\Scripts\\merlin_el.dxf"
    // import FILENAME="C:\\Users\\AirWorksProcessing\\Documents\\Scripts\\2710_W-WATER.dxf"
    // import FILENAME="C:\\Users\\AirWorksProcessing\\Documents\\Scripts\\2710_B-OVERHANG.dxf"

	import FILENAME="C:\\Users\\AirWorksProcessing\\Documents\\Scripts\\startfile.gmw"
LOG_MESSAGE %TIMESTAMP%: Step0 Complete, startfile loaded

//1: Manually QC Pointcloud Classification
LOG_MESSAGE %TIMESTAMP%: Step1 MANUALLY SKIPPED!!!!: no pointcloud classification needed

//2:  Create data_grid from ground points, buildings, and water polygons
    //set elev units to feet depending on native projection
    GENERATE_ELEV_GRID \
        // FILENAME="C:\\Users\\AirWorksProcessing\\Documents\\Scripts\\2710.las"\
        // FILENAME="C:\\Users\\AirWorksProcessing\\Documents\\Scripts\\2710_B-OVERHANG.dxf"\
        // FILENAME="C:\\Users\\AirWorksProcessing\\Documents\\Scripts\\2710_W-WATER.dxf"
        FILENAME="pointcloud"\
        FILENAME="overhang"\
        FILENAME="water"\
        LAYER_DESC="data_grid"\
        LIDAR_FILTER=2\
        GRID_TYPE=ELEVATION\
        GRID_ALG=BIN_AVG\
        ELEV_UNITS=FEET\
        SPATIAL_RES_METERS=1\
        NO_DATA_DIST_MULT=0
LOG_MESSAGE %TIMESTAMP%: Step2 done: data_grid Generated

//3: Create KML GRID
    //assign KML points elevations
    //set elev units to feet depending on native projection again (atleast get rid of the hard-coding)?
    //EDIT_VECTOR \
      //APPLY_ELEVS \
	  //  FILENAME="kml"\
        //ELEV_LAYER="2710.las (DTM Elevation Values)"   //can see sample scripts page 96 of pdf
    //for now, the elevation grid must be added before the script.
    // GENERATE_ELEV_GRID\
    //     FILENAME="C:\\Users\\AirWorksProcessing\\Documents\\Scripts\\merlin_el.dxf"\
    //     LAYER_DESC="kml_grid"\
    //     GRID_TYPE=ELEVATION\
    //     GRID_ALG=BIN_AVG\
    //     ELEV_UNITS=FEET\
    //     SPATIAL_RES_METERS=0.9\
    //     NO_DATA_DIST_MULT=0
LOG_MESSAGE %TIMESTAMP%: Step3 MANUALLY SKIPPED!!!!: kml_grid should have been generated before script

//4: KML GRID-MERGED GRID=OBSTRUCTION GRID
    COMBINE_TERRAIN \
        LAYER1_FILENAME="kml_grid"\
        LAYER2_FILENAME="data_grid"\
        COMBINE_OP=FILTER_KEEP_FIRST_IF_SECOND_INVALID\
        LAYER_DESC="obs_grid"\
        ELEV_UNITS=FEET\
        SPATIAL_RES_METERS=.1
LOG_MESSAGE %TIMESTAMP%: Step4 done: obstruction_grid generated


//5: OBSTRUCTION GRID>areas>simplify>lines
    GENERATE_LAYER_BOUNDS \
        FILENAME="obs_grid"\
        LAYER_DESC="obs_area"\
        BOUNDS_TYPE=POLYGON
    EDIT_VECTOR \
        FILENAME="obs_area"\
        CONVERT_AREAS_TO_LINES=YES\
		SMOOTH_FEATURES=YES\
		STYLE_ATTR="LINE_COLOR=RGB(255,0,0)"
LOG_MESSAGE %TIMESTAMP%: Step5 done: grid>areas>simplify>lines

//6: Delete islands smaller than 200 ft^2
	// ADD_MEASURE_ATTRS \
	// 	FILENAME="obs_area"\
	// 	AREA_UNITS="SQUARE FEET"\
	// 	MEASURE_UNIT_TYPE=BASE

    LAYER_LOOP_START FILENAME="obs_area" // VAR_NAME_PREFIX="HIDE"
        IF COMPARE_STR="ENCLOSED AREA<200" COMPARE_NUM=YES
		EDIT_VECTOR \
		FILENAME="obs_area"\
		DELETE_FEATURES=YES
	END_IF
    LAYER_LOOP_END
	
LOG_MESSAGE %TIMESTAMP%: Step6 done: deleting small islands


//8: Create NEW/LOOSER GROUND GRID>contours only within obstrucion and KML
    GENERATE_ELEV_GRID \
        FILENAME="pointcloud" \
        LAYER_DESC="loose_kml_grid_for_contours"\
        GRID_TYPE=ELEVATION\
		LIDAR_FILTER=2\
        LAYER_BOUNDS="kml"\ 
        GRID_ALG=BIN_AVG\
        ELEV_UNITS=FEET\
        SPATIAL_RES_METERS=1\
        NO_DATA_DIST_MULT=3
    GENERATE_CONTOURS \
        FILENAME="loose_kml_grid_for_contours" \
        INTERVAL=2\
        MULT_MINOR=1\
        MULT_MAJOR=5\
        LAYER_DESC="contours"\
        POLYGON_CROP_FILE="obs_area"\
		POLYGON_CROP_USE_ALL=YES\
		POLYGON_CROP_EXCLUDE=YES\
		STYLE_ATTR="LINE_COLOR=RGB(0,0,0)"
LOG_MESSAGE %TIMESTAMP%: Step6 done: Clipped Contours Generated

//9: EXPORT into DXF
//add %variable% export name
	EXPORT_VECTOR \
		FILENAME="C:\\Users\\AirWorksProcessing\\Documents\\Scripts\\output\\contour.dxf" \
		TYPE=DXF \
		EXPORT_LAYER="obs_area"\
	    EXPORT_LAYER="contours"\
		SHAPE_TYPE=LINES \
		GEN_PRJ_FILE=NO \
		SPLIT_BY_ATTR=NO \
		SPATIAL_RES_METERS=0.25\
		FILENAME_ATTR_LIST="<Feature Name>"\
        POLYGON_CROP_FILE="kml"\
		POLYGON_CROP_USE_ALL=YES
LOG_MESSAGE %TIMESTAMP%: Step 7 done: file exported to C:\\Users\\AirWorksProcessing\\Documents\\Scripts\\output. Process took %TIME_SINCE_START%


//10: Merge into main DXF?
	LAYER_LOOP_START FILENAME="*" VAR_NAME_PREFIX="HIDE"
	SET_LAYER_OPTIONS FILENAME="%HIDE_FNAME_W_DIR%" HIDDEN=YES
	LAYER_LOOP_END
	import FILENAME="C:\\Users\\ted_airworks.io\\Documents\\Scripts\\merged.dxf"