GLOBAL_MAPPER_SCRIPT
//for topo contour generation in feet, need to add variable for that later

//1- Manually QC Pointcloud Classification
////if we ever decide to skip this, use this block to import all files from a folder
//DEFINE_VAR\
    //NAME="FILEORFOLDER"\
    //PROMPT="Single file=YES, Many tiles in a folder=NO"

IF COMPARE_STR="%FILEORFOLDER%=YES"
//DEFINE_VAR\
    //NAME="FILE"
    //PROMPT="SELECT A FILE"
        //FILE
//IMPORT FILENAME="%FILE%"

END_IF

ELSE COMPARE_STR="%FILEORFOLDER%=YES"
//DEFINE_VAR\
    //NAME="FOLDER"
    //PROMPT="SELECT A FOLDER CONTAINING DESIRED POINTCLOUDS"
        //DIR
//DIR_LOOP_START DIRECTORY="%FOLDER%" FILENAME_MASKS= "*.tif" RECURSE_DIR=YES
  //IMPORT FILENAME="%FNAME_W_DIR%"
//DIR_LOOP_END
END_IF



////or just one file

//2- Create GROUND GRID
GENERATE_ELEV_GRID\
    ELEV_UNITS=FEET

//3- Create KML GRID
//4- Create B&W GRID
//5- Merge GROUND+B&W GRID
//6- KML GRID-MERGED GRID=OBSTRUCTION GRID
//7- OBSTRCUTION GRID>areas>simplify>lines
//8- Create NEW/LOOSER GROUND GRID>contours.clip to obstrucion and KML
//9- EXPORT into DXF
//10- Merge into base DXF


//Export to specified location
EXPORT_RASTER FILENAME "C:\Users\AirWorksProcessing\Downloads\use_this_one_merged_1828.tif" TYPE=GEOTIFF PALETTE=OPTIMIZED


UNLOAD_ALL