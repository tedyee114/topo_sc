GLOBAL_MAPPER_SCRIPT
//DEFINE_VAR NAME="UNITS" VALUE="meters"
QUERY_LAYER_METADATA \
	RESULT_VAR=%UNITS% \
	METADATA_LAYER="pointcloud" \
	METADATA_ATTR="PROJ_UNITS"

LOG_MESSAGE %UNITS%
DEFINE_VAR NAME="UNITS" PROMPT ABORT_ON_CANCEL PROMPT_TEXT="Detected units were %UNITS%. Accept and continue? If not please type 'feet' or 'meters' to override or cancel the whole script"