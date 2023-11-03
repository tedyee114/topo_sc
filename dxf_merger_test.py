#dxf_merger_test

import ezdxf
from ezdxf.addons import Importer

base_dxf = ezdxf.readfile('C:/Users/ted_airworks.io/Documents/Scripts/v0_SCE_-_1597246_MERLIN_2023-07-27.dxf')
contour_dxf=ezdxf.readfile('C:/Users/ted_airworks.io/Documents/Scripts/contour.dxf')
def merge(contour_dxf, base_dxf):
    importer = Importer(contour_dxf, base_dxf)
    # import all entities from source modelspace into target modelspace
    importer.import_modelspace()
    # import all required resources and dependencies
    importer.finalize()

merge(contour_dxf, base_dxf)

base_dxf.save()  # to save as file1.dxf
#base_dxf.saveas('C:/Users/ted_airworks.io/Documents/Scripts/merged.dxf')