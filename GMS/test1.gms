IMPORT FILENAME="C:\\Users\\AirWorksProcessing\\Documents\\Scripts\\2710.las"
GENERATE_ELEV_GRID \
    FILENAME="C:\\Users\\AirWorksProcessing\\Documents\\Scripts\\2710.las"\
    GRID_TYPE=ELEVATION \
    LAYER_DESC="kml_grid"\
    GRID_ALG=BIN_AVG\
    ELEV_UNITS=FEET\
    SPATIAL_RES_METERS=0.9\
    NO_DATA_DIST_MULT=0
LOG_MESSAGE %TIMESTAMP%: Step3 done: kml_grid Generated