GLOBAL_MAPPER_SCRIPT VERSION="1.00"
import FILENAME="C:\\Users\\AirWorksProcessing\\Documents\\Scripts\\MERLIN.kml"
LOG_MESSAGE %TIMESTAMP%: Step0 done: Hardcoded Single File Imported
EDIT_VECTOR \
    FILENAME="C:\\Users\\AirWorksProcessing\\Documents\\Scripts\\MERLIN.kml"\
    APPLY_ELEVS \
	ELEV_LAYER="2710.las (DTM Elevation Values)"
EXPORT_VECTOR \
	EXPORT_LAYER="MERLIN.kml"\
	FILENAME="%DIR%%FNAME_WO_EXT%_CONTOURS.dxf"\
	TYPE=dxf \

GENERATE_ELEV_GRID \
    // FILENAME="C:\\Users\\AirWorksProcessing\\Documents\\Scripts\\2710.las"\
    // FILENAME="C:\\Users\\AirWorksProcessing\\Documents\\Scripts\\2710_B-OVERHANG.dxf"\
    // FILENAME="C:\\Users\\AirWorksProcessing\\Documents\\Scripts\\2710_W-WATER.dxf"
    FILENAME="2710.las (DTM Elevation Values)"\
	FILENAME="C:\\Users\\AirWorksProcessing\\Documents\\Scripts\\MERLIN.kml"\
    LAYER_DESC="kml_grid"\
    GRID_TYPE=ELEVATION\
    GRID_ALG=BIN_AVG\
    ELEV_UNITS=FEET\
    SPATIAL_RES_METERS=0.1\
    NO_DATA_DIST_MULT=0

	