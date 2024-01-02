GLOBAL_MAPPER_SCRIPT
//DEFINE_VAR NAME="UNITS" VALUE="meters"
QUERY_LAYER_METADATA \
	RESULT_VAR=%UNITS% \
	METADATA_LAYER="pointcloud" \
	METADATA_ATTR="PROJ_UNITS"
   QUERY_LAYER_METADATA \
        RESULT_VAR=%pc_epsg% \
        METADATA_LAYER="pointcloud" \
        METADATA_ATTR="EPSG_CODE"
LOG_MESSAGE %UNITS%
LOG_MESSAGE %pc_epsg%
//DEFINE_VAR NAME="UNITS" PROMPT ABORT_ON_CANCEL PROMPT_TEXT="Detected units were %UNITS%. Accept and continue? If not please type 'feet' or 'meters' to override or cancel the whole script"