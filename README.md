# topo_sc
Automated Global Mapper Topo Generation
Created for use at Airworks Inc By Ted Yee, 2023

To view this readme formatting correctly in GitHub, click Code rather than PREVIEW mode

There are definitely opportunities to make the script more automatic, I just hit roadblocks:
    *assigning elevations to the kml and then automatically gridding it was unsuccessful, but the code is still there
    *output layer colors are colored incorrectly (see first ** below this)
    *cropping. Ugh... As far as I could find, there is no simple line-crop-to-areas command in the scripting languange, all crops must be operation boundaries. So to crop contours to the obstruction areas (must be areas, not lines), the obs_areas should be used as boundaries for contour generation. This is written in Topo_Script1, but commented out because cropping while generating the contours seems to be too large of an operation for computers (even when given access to all cores and maximized) and it takes forever and always creates errors. By uncommenting the marked snippets of Topo_Script1, a complete automatic process can be used, but currently with errors. This is the reason that option 3 (manual cropping and a 2-part script) was chosen.


**output layers are colored individually. i.e., in AutoCAD they will appear as COLOR=RED&LAYER=DEFAULT, it should be COLOR=BYLAYER&LAYER=RED. This could maybe be changed by creating a layer style instead of assigning entity color attributes in Global Mapper

**Only Global Mapper Versions 23 and above support scripting

**For scripting help in GlobalMapperSript:
-https://ezdxf.readthedocs.io/en/stable/concepts/layers.html#layer-properties
-https://www.bluemarblegeo.com/knowledgebase/global-mapper-21/GlobalMapper_ScriptingReference.pdf

**For scripting help on writing inner script in python (Python to control Global Mapper)
-https://www.bluemarblegeo.com/knowledgebase/global-mapper-python-24-1/index.html

There are 3 ways to generate contours, but only method 3 was chosen and completely coded:

1.  For option 1, the setup is a commandline script, running global mapper, running an inner script, on a file, or graphically as below:
    ______________________________________________________________
    |              _____________________________________________ |
    |              |               ___________________________ | |
    |              |               |               _________ | | |
    | outer script | Global Mapper | inner script  | files | | | |
    |   (opens)    |     (runs)    | (operates on) |_______| | | |
    |              |               |_________________________| | |
    |              |___________________________________________| |
    |____________________________________________________________|
    a. Run an 'outer script' called called torunpythonfromterminal.py
        a. This specifies files for operation, without manual QC of pointcloud classification
        b. It operates by:
            1. Taking user input (files to use, settings)
            2. Opening Global Mapper through the commandline
            3. Passing user input variables to Global Mapper about what files to open and what settings to use (this step not built yet)
            4. Running another script (the 'inner script') inside of Global Mapper that tells the software what operations to execute
            5. Outputted file of contours.dxf is stylized
            6. contour_stylized.dxf is merged into specified base dxf
        c. Note that this process is completely autonomous and trusts completely in pointcloud's classfication, which is not company procedure
        
    ** There are two scripts. The outer script (torunpythonfromterminal.py) can be replaced by any script completing the same functions written in any language.\
    The 'inner script' referenced above can be written in either Python (.py) or GlobalMapperScript (.gms), it does not have to match the outer script.\
    

2.  a. Open Global Mapper manually
    b. Manually QC pointcloud classification (at least ground/class2 and nonground/any other class)
    c. Rename files as "kml", "kml_grid" (3d gridded kml), and "pointcloud" (tiles need to be all on one layer)
    d. User runs Topo_Script1.gms from within Global Mapper either by FILE>RUN SCRIPT or CTRL+SHIFT+O
    e. User is prompted to input settings and select base dxf. When selecting, prompt will appear as a "SAVE AS" box and ask if user wants to overwrite existing file. This message is  an unavoidable system feature, just click yes, as nothing will actually be overwritten
    f. Obstruction Layer and Contours are automatically generated
    g. Contours are automatically clipped to obstruction layer (this takes a very long time and often creates errors, which is why this was scrapped)
    f. %OUTPUTFOLDER%basedxf_with_obs_contours.dxf is exported, then imported to Global Mapper for viewing


3.  Same a-f as Option 2, but then...
    g. User hears sound, manually crops layers 'G-TOPO-MINR' and 'G-TOPO-MAJR' to 'obs_areas - Unknown Line Type'
    h. User either manually exports, recolors, and merges files or runs Topo_Script2.gms to do all of that
