# topo_sc
Automated Global Mapper Topo Generation
Created for use at Airworks Inc By Ted Yee, 2023
There are 3 ways to generate contours, but only method 3 was completely finished
To view this readme formatting correctly in GitHub, click View Code rather than preview mode

**Only Global Mapper Versions 23 and above support scripting

**For scripting help in GlobalMapperSript:
-https://ezdxf.readthedocs.io/en/stable/concepts/layers.html#layer-properties
-https://www.bluemarblegeo.com/knowledgebase/global-mapper-21/GlobalMapper_ScriptingReference.pdf

**For scripting help on writing inner script in python (Python to control Global Mapper)
-https://www.bluemarblegeo.com/knowledgebase/global-mapper-python-24-1/index.html

1.  a. Run an 'outer script' called called torunpythonfromterminal.py
        a. This specifies files for operation, without manual QC of pointcloud classification
        b. It operates by:
            1. Opening Global Mapper through the commandline
            2. Telling Global Mapper what files to open and what settings to use (this step not built yet)
            3. Running a script (the 'inner script') inside of Global Mapper that tells the software what operations to execute
            4. Outputted file of contours.dxf is stylized
            5. contour_stylized.dxf is merged into specified base dxf
        c. Note that this process is completely autonomous and trusts completely in pointcloud's classfication, not company procedure
    ** There are two scripts. The outer script (torunpythonfromterminal.py) can be replaced by any script completing the same functions written in any language.\
    The 'inner script' referenced above can be written in either Python (.py) or GlobalMapperScript (.gms), it does not have to match the outer script.\
    For option 1, the setup is a commandline script, running global mapper, running an inner script, on a file, or graphically as below:

    ______________________________________________________________
    |              _____________________________________________ |
    |              |               ___________________________ | |
    |              |               |               _________ | | |
    | outer script | Global Mapper | inner script  | files | | | |
    |   (opens)    |     (runs)    | (operates on) |_______| | | |
    |              |               |_________________________| | |
    |              |___________________________________________| |
    |____________________________________________________________|

2.  a. Open Global Mapper manually
    b. Manually QC pointcloud classification (at least ground/class2 and nonground/any other class)
    c. Rename files as "kml", "kml_grid" (3d gridded kml), and "pointcloud" (tiles need to be all on one layer)
    d. User runs Topo_Script1.gms from within Global Mapper either by FILE>RUN SCRIPT or CTRL+SHIFT+O
    e. User is prompted to input settings (which as a workaround are stored as attributes of the pointcloud file) and select base dxf. When selecting, prompt will appear as a "SAVE AS" box and ask if user wants to overwrite existing file. This message is just an unavoidable system feature, just click yes, nothing will be overwritten
    f. Obstruction Layer and Contours are automatically generated
    g. Contours are automatically clipped to obstruction layer (this takes a very long time and often creates errors, which is why this was scrapped)
    f. %OUTPUTFOLDER%basedxf_with_obs_contours.dxf is expoerted, then imported to Global Mapper for viewing

3.  Same a-f as Option 2, but then...
    g. User hears sound, manually crops contours to obstruction layer
    h. User either manually exports, recolors, and merges files or runs Topo_Script2.gms to do all of that
