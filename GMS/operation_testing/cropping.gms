GLOBAL_MAPPER_SCRIPT VERSION="1.00"
DEFINE_SPATIAL_OPERATION SPATIAL_OPERATION_NAME="croppy"

//Create a new layer named risk countaining countries the intersect the hurricane trajectory
Layer "after" = DIFFERENCE("G-TOPO-MINR","obs_polygons - Unknown Line Type")

//Select all feature in the new risk layer with the digitizer tool
SELECT "after"

END_DEFINE_SPATIAL_OPERATION

RUN_SPATIAL_OPERATION SPATIAL_OPERATION_NAME="croppy"