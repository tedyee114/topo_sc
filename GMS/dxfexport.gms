GLOBAL_MAPPER_SCRIPT
//for rasterization of .tif, .laz or .las files into a single .tif file

//IMPORT FILENAME "C:\\Users\\AirWorksProcessing\\Documents\\toposcript\\MERLIN.LAZ"
EXPORT_VECTOR FILENAME "C:\\Users\\AirWorksProcessing\\Documents\\toposcript\\contours.dxf"\
  EXPORT_LAYER=CONTOURS\
  TYPE=DXF

//UNLOAD_ALL