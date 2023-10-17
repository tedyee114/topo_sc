//Editing language set to C++ in VScode becuase .gms and .cpp both use // for comments and there's no .gms debugger
//Made by Ted Yee 2023-10-17 for Airworks Inc.
//Unlicensed, contains no proprietary infomation
//
//Currently, only file needing to be loaded before running is an elev-assigned kML, all others will be imported from hard-coded locations

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

//0: import just one file
    import FILENAME="C:\\Users\\AirWorksProcessing\\Documents\\Scripts\\2710.las"
LOG_MESSAGE %TIMESTAMP%: Step0 done: Hardcoded Single File Imported

//1: Manually QC Pointcloud Classification
LOG_MESSAGE %TIMESTAMP%: Step1 MANUALLY SKIPPED!!!!: no pointcloud classification needed

//2:  Create data_grid from ground points, buildings, and water polygons
    //turn off all except ground class
    //set elev units to feet depending on native projection
    GENERATE_ELEV_GRID\
        FILENAME="C:\\Users\\AirWorksProcessing\\Documents\\Scripts\\2710.las"\
        FILENAME="C:\\Users\\AirWorksProcessing\\Documents\\Scripts\\2710_B-OVERHANG.dxf"\
        FILENAME="C:\\Users\\AirWorksProcessing\\Documents\\Scripts\\2710_W-WATER.dxf"\
        LAYER_DESC="data_grid"\
        GRID_TYPE=ELEVATION\
        GRID_ALG=BIN_AVG\
        ELEV_UNITS=FEET\
        SPATIAL_RES_METERS=0.9\
        NO_DATA_DIST_MULT=0
LOG_MESSAGE %TIMESTAMP%: Step2 done: data_grid Generated

//3: Create KML GRID
    //assign KML points elevations
    //set elev units to feet depending on native projection again (atleast get rid of the hard-coding)?
    //for now, the elevation-added file must be loaded ahead of time
    GENERATE_ELEV_GRID\
        FILENAME="MERLIN_elev.kml"\
        LAYER_DESC="kml_grid"\
        GRID_TYPE=ELEVATION\
        GRID_ALG=BIN_AVG\
        ELEV_UNITS=FEET\
        SPATIAL_RES_METERS=0.9\
        NO_DATA_DIST_MULT=0
LOG_MESSAGE %TIMESTAMP%: Step3 done: kml_grid Generated

//4: Merge GROUND+B&W GRID
//5: KML GRID-MERGED GRID=OBSTRUCTION GRID
//6: OBSTRCUTION GRID>areas>simplify>lines
//7: GENERATE_LAYER_BOUNDS FILENAME="data_grid" BOUNDS_TYPE=POLYGON
LOG_MESSAGE %TIMESTAMP%: Step4 not done

//8: Create NEW/LOOSER GROUND GRID>contours.clip to obstrucion and KML
//     GENERATE_CONTOURS \
//         FILENAME="data_grid" \
//         INTERVAL=20 \
//         LAYER_DESC="contours"
LOG_MESSAGE %TIMESTAMP%: Step5 not done

//9: EXPORT into DXF
////add %variable% export name
// EXPORT_VECTOR \
// 	FILENAME="C:\\Users\\AirWorksProcessing\\Documents\\Scripts\\output\\contour.dxf" \
// 	TYPE=DXF \
// 	EXPORT_LAYER="contours"\
// 	SHAPE_TYPE=LINES \
// 	GEN_PRJ_FILE=NO \
// 	SPLIT_BY_ATTR=NO \
// 	SPATIAL_RES_METERS=0.25\
// 	FILENAME_ATTR_LIST="<Feature Name>" \
// 	FILENAME_INCLUDE_ATTR_NAME=YES
LOG_MESSAGE %TIMESTAMP%: Step6 not done

//10: Merge into main DXF?