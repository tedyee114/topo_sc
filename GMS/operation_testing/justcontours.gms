//Editing language set to C++ in VScode becuase .gms and .cpp both use // for comments and there's no .gms debugger
GLOBAL_MAPPER_SCRIPT VERSION="1.00"

//1 hard-coded file import
IMPORT FILENAME="C:\\Users\\AirWorksProcessing\\Documents\\Scripts\\2710.las"
LOG_MESSAGE %TIMESTAMP%: Step1 done

//2 grid generation
GENERATE_ELEV_GRID FILENAME="C:\\Users\\AirWorksProcessing\\Documents\\Scripts\\2710.las"\
	LAYER_DESC="data_grid"\
	GRID_TYPE=ELEVATION\
	GRID_ALG=BIN_AVG\
	ELEV_UNITS=FEET\
	SPATIAL_RES_METERS=0.9\
	NO_DATA_DIST_MULT=0
LOG_MESSAGE %TIMESTAMP%: Step2 done

//3 contour generation
GENERATE_CONTOURS \
	FILENAME="data_grid" \
 	INTERVAL=20 \
 	LAYER_DESC="contours"
 LOG_MESSAGE %TIMESTAMP%: Step3 done

//4 dxf export
EXPORT_VECTOR \
	FILENAME="C:\\Users\\AirWorksProcessing\\Documents\\Scripts\\output\\contour.dxf" \
	TYPE=DXF \
	EXPORT_LAYER="contours"\
	SHAPE_TYPE=LINES \
	GEN_PRJ_FILE=NO \
	SPLIT_BY_ATTR=NO \
	SPATIAL_RES_METERS=0.25\
	FILENAME_ATTR_LIST="<Feature Name>" \
	FILENAME_INCLUDE_ATTR_NAME=YES
LOG_MESSAGE %TIMESTAMP%: Step4 done