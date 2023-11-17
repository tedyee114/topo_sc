from tkinter import *
from tkinter import ttk
r= Tk()
r.geometry("700x350")
def selection:
    selected = str(radio.get)
    label.config(text=selected)
radio=Intvar()
    Label(text="wow").pack()
r1=Radiobutton(r, text="a", variable=radio, value=1, command=selection)
r2=Radiobutton(r, text="b", variable=radio, value=2, command=selection)
r1.pack()
r2.pack()