import globalmapper as gm
files = gm.SelectFile(None, None, 0)
print (files[1])
gm.LoadLayerList(files[1], gm.GM_LoadFlags_UseDefaultLoadOpts)