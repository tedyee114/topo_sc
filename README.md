# topo_sc
Automated Global Mapper Topo Generation
Created for use at Airworks Inc By Ted Yee, 2023
There are two ways to generate contours:

1.  a. Run an 'outer script' called called torunpythonfromterminal.py
        a. This specifies files for operation, without manual QC of pointcloud classification
        b. It operates by:
            1. Opening Global Mapper through the commandline
            2. Telling Global Mapper what files to open and what settings to use (this step not built yet)
            3. Running a script (the 'inner script') inside of Global Mapper that tells the software what operations to execute
            4. Outputted file of contours.dxf is stylized
            5. contour_stylized.dxf is merged into specified base dxf
        c. Note that this process is completely autonomous and trusts completely in pointcloud's classfication, not company procedure

2.  a. Open Global Mapper Manual
    b. Manually QC pointcloud classification (at least ground/class2 and nonground/any other class)
    c. Rename files as "kml" (3d gridded kml), "pointcloud", "overhang", "water" if exist
        1. Note that there in future could be a way to detect these files, grid the kml, and split the base dxf automatically, but hasn't been built yet
        2. Note that currently, for testing ease, some of these things are hardcoded, i.e. a saved workspace with these layers is told to open rather than rebuilding each time
    d. User runs script (the 'inner script') from within Global Mapper either by FILE>RUN SCRIPT or CTRL+SHIFT+O
    e. contours.dxf is outputted into documents/scripts/topo_sc/output, but is not stylized
    f. Manually stylie and merge dxfs

**Only Global Mapper Versions 23 and above support scripting
** There are two scripts. The outer script (torunpythonfromterminal.py) can be replaced by any script completing the same functions written in any language.\
    The 'inner script' referenced above can be written in either Python (.py) or GlobalMapperScript (.gms), it does not have to match the outer script.\
    For option 1, the setup is a script running global mapper running an inner script on a file, or graphically as below:

    ______________________________________________________________
    |              _____________________________________________ |
    |              |               ___________________________ | |
    |              |               |               _________ | | |
    | outer script | Global Mapper | inner script  | files | | | |
    |   (opens)    |     (runs)    | (operates on) |_______| | | |
    |              |               |_________________________| | |
    |              |___________________________________________| |
    |____________________________________________________________|

**For scripting help in GlobalMapperSript:
-https://ezdxf.readthedocs.io/en/stable/concepts/layers.html#layer-properties
-https://www.bluemarblegeo.com/knowledgebase/global-mapper-21/GlobalMapper_ScriptingReference.pdf

**For scripting help on writing inner script in python (Python to control Global Mapper)
-https://www.bluemarblegeo.com/knowledgebase/global-mapper-python-24-1/index.html