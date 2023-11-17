//Editing language set to C++ in VScode becuase .gms and .cpp both use // for comments and there's no .gms debugger
//Made by Ted Yee 2023-10-17 for Airworks Inc.
//Unlicensed, contains no proprietary infomation
//
//must start with files named "kml_grid", "kml", "pointcloud", "overhang", "water"

GLOBAL_MAPPER_SCRIPT VERSION="1.00"
//need to add variable units for that later, currently hard-coded to feet

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

//0: all files must imported before being operated upon below (even though it requests the filepath again)
    // import FILENAME="C:\\Users\\AirWorksProcessing\\Documents\\Scripts\\2710.las"
    // import FILENAME="C:\\Users\\AirWorksProcessing\\Documents\\Scripts\\merlin_el.dxf"
    // import FILENAME="C:\\Users\\AirWorksProcessing\\Documents\\Scripts\\2710_W-WATER.dxf"
    // import FILENAME="C:\\Users\\AirWorksProcessing\\Documents\\Scripts\\2710_B-OVERHANG.dxf"
LOG_MESSAGE %TIMESTAMP%: Step0 done: Hardcoded Single File Imported

//1: Manually QC Pointcloud Classification
LOG_MESSAGE %TIMESTAMP%: Step1 MANUALLY SKIPPED!!!!: no pointcloud classification needed

//2:  Create data_grid from ground points, buildings, and water polygons
    //turn off all except ground class--maybe done??
    //set elev units to feet depending on native projection
    GENERATE_ELEV_GRID\
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
        SPATIAL_RES_METERS=2\
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
LOG_MESSAGE %TIMESTAMP%: Step3 done: kml_grid should have been generated before script

//5: KML GRID-MERGED GRID=OBSTRUCTION GRID
    COMBINE_TERRAIN \
        LAYER1_FILENAME="kml_grid"\
        LAYER2_FILENAME="data_grid"\
        COMBINE_OP=FILTER_KEEP_FIRST_IF_SECOND_INVALID\
        LAYER_DESC="obs_grid"\
        ELEV_UNITS=FEET\
        SPATIAL_RES_METERS=2
LOG_MESSAGE %TIMESTAMP%: Step4 done: obstruction_grid generated


//6: OBSTRUCTION GRID>delete islands smaller than>areas>simplify>lines
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

	
ADD_MEASURE_ATTRS \
	FILENAME="obs_area"\
	AREA_UNITS="SQUARE FEET"\
	MEASURE_UNIT_TYPE=BASE

IF COMPARE_STR="ENCLOSED AREA<200"
	EDIT_VECTOR \
	//COMPARE_NUM=YES\
	FILENAME="obs_area"\
	DELETE_FEATURES=YES
END_IF