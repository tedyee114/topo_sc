#dxf_merger_test

# import subprocess                                                                         #allows access to windows commandline
# # subprocess.Popen('python -m pip install --upgrade pip')                                   #upgrades the downloader, just so nothing goes wrong
# subprocess.Popen('pip3 install git+https://github.com/mozman/ezdxf.git@master')
# subprocess.Popen('pip3 install ezdxf')
import ezdxf
from ezdxf.addons import Importer

base_dxf = ezdxf.readfile('C:/Users/AirWorksProcessing/Documents/Scripts/2710_B-OVERHANG.dxf')
contour_dxf=ezdxf.readfile('C:/Users/AirWorksProcessing/Documents/Scripts/2710_W-WATER.dxf')
def merge(contour_dxf, base_dxf):
    importer = Importer(contour_dxf, base_dxf)
    # import all entities from source modelspace into target modelspace
    importer.import_modelspace()
    # import all required resources and dependencies
    importer.finalize()

merge(contour_dxf, base_dxf)

#base_dxf.save()  # to save as file1.dxf
base_dxf.saveas('C:/Users/AirWorksProcessing/Documents/Scripts/2710_B-OVERHABG.dxf')