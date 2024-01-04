//Editing language set to C++ in VScode becuase .gms and .cpp both use // for comments and there's no .gms debugger
GLOBAL_MAPPER_SCRIPT VERSION="1.00"

//1 hard-coded file import
//IMPORT FILENAME="C:\\Users\\AirWorksProcessing\\Documents\\Scripts\\2710.las"
//LOG_MESSAGE %TIMESTAMP%: Step1 done

//2 grid generation
//GENERATE_ELEV_GRID FILENAME="C:\\Users\\AirWorksProcessing\\Documents\\Scripts\\2710.las"\
	//LAYER_DESC="data_grid"\
	//GRID_TYPE=ELEVATION\
	//GRID_ALG=BIN_AVG\
	//ELEV_UNITS=FEET\
	//SPATIAL_RES_METERS=0.9\
	//NO_DATA_DIST_MULT=0
//LOG_MESSAGE %TIMESTAMP%: Step2 done

//3 contour generation
 GENERATE_ELEV_GRID \
        FILENAME="pointcloud" \
        LAYER_DESC="loose_data_grid_for_contours"\
        GRID_TYPE=ELEVATION\
		LIDAR_FILTER=2\
        LAYER_BOUNDS="kml"\ 
        GRID_ALG=BIN_AVG\
        ELEV_UNITS=feet\
        SPATIAL_RES_METERS=.3\
        NO_DATA_DIST_MULT=3
    GENERATE_CONTOURS \
        FILENAME="loose_data_grid_for_contours" \
        ELEV_UNITS=feet \
        INTERVAL=1\
        MULT_MINOR=1\
        MULT_MAJOR=5\
        LAYER_DESC="contours"\
		SAMPLING_METHOD=BOX_4x4 \
        SMOOTH_CONTOURS=YES \
        MIN_CONTOUR_LEN=6 \
//4 dxf export
//EXPORT_VECTOR \
	//FILENAME="C:\\Users\\AirWorksProcessing\\Documents\\Scripts\\output\\contour.dxf" \
	//TYPE=DXF \
	//EXPORT_LAYER="contours"\
	//SHAPE_TYPE=LINES \
	//GEN_PRJ_FILE=NO \
	//SPLIT_BY_ATTR=NO \
	//SPATIAL_RES_METERS=0.25\
	//FILENAME_ATTR_LIST="<Feature Name>" \
	//FILENAME_INCLUDE_ATTR_NAME=YES
//LOG_MESSAGE %TIMESTAMP%: Step4 done

LOG_MESSAGE  Process Complete; Elapsed time %TIME_SINCE_START%