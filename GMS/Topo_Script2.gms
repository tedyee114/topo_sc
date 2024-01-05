//Set editing language set to C# in VScode so that // works for comments
//Made by Ted Yee 2023-10-17 for Airworks Inc.
//This is part 2 of the topo generation script
//Must start with layers named 'A-OBSTRUCTION', 'G-TOPO-MINR', 'G-TOPO-MAJR', and 'basedxf'

GLOBAL_MAPPER_SCRIPT VERSION="1.00"

    DEFINE_VAR NAME="OUTPUTFOLDER" PROMPT=DIR ABORT_ON_CANCEL PROMPT_TEXT="Output Folder?"
        EDIT_VECTOR                                     \
        FILENAME="pointcloud"                           \
		ATTR_VAL="OUTPUTFOLDER=%OUTPUTFOLDER%"

    SET_LAYER_OPTIONS FILENAME="A-OBSTRUCTION" HIDDEN=NO
    SET_LAYER_OPTIONS FILENAME="G-TOPO-MINR"   HIDDEN=NO
    SET_LAYER_OPTIONS FILENAME="G-TOPO-MAJR"   HIDDEN=NO
	SET_LAYER_OPTIONS FILENAME="basedxf_whole"       HIDDEN=NO


//9: Export 3 layers and base dxf from second import of Topo_Script1
    EXPORT_VECTOR                       \
		FILENAME=%OUTPUTFOLDER%basedxf_plus_obs_contours.dxf \
		TYPE=DXF                        \
		EXPORT_LAYER="A-OBSTRUCTION"    \
	    EXPORT_LAYER="G-TOPO-MINR"      \
        EXPORT_LAYER="G-TOPO-MAJR"      \
        EXPORT_LAYER="basedxf_whole"          \
		GEN_PRJ_FILE=NO                 \
		SPLIT_BY_ATTR=NO                \
        //unless the two scirpts are put together, %RES_M% has no value and the resolution is automatic
        SPATIAL_RES_METERS=%RES_M%
    LOG_MESSAGE %TIMESTAMP%: Step9 done: file exported as %OUTPUTFOLDER%basedxf_plus_obs_contours.dxf


//10: Import new DXF and hide all other layers
	SET_LAYER_OPTIONS \
        FILENAME="*" \
        HIDDEN=YES
    
	IMPORT FILENAME=%OUTPUTFOLDER%basedxf_plus_obs_contours.dxf USE_DEFAULT_PROJ=YES
    LOG_MESSAGE %TIMESTAMP%: Step10 done: new file opened and other layers turned off

LOG_MESSAGE  Process Complete; Elapsed time: %TIME_SINCE_START%