from tkinter import *
from tkinter import filedialog
  
# Function for opening the file explorer window
fileeeee = filedialog.askopenfilename(initialdir = "/",
                                      title = "Select a File",
                                      filetypes = (("All files",
                                                     "*.*"),
                                                   ("Python Files",
                                                    "*.py*")))
print (fileeeee)