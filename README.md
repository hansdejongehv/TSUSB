# TSUSB
Helper programs for [TurtleStitch](https://turtlestitch.org) workshops. The 5 programs below are available or will come available.
Further, there is documentation.
## Documentation
The documentation folder contains a detailed descriptions of how workshops can be run and how to use the helper programs. Also how to run TurtleStitch with a local host.
## TSStart
A program that will start the default browser with the TurtleStitch page opened.
It comes in three flavours: 
1. **TSStart-Remote** For when TurtleStitch is used remotely, so open turtlestitch.org/run
2. **TSStart-LocalHost** For when TurtleStitch is used with a local host
3. **TSStart-LocalFile** For when TurtleStitch is using a local file

Take one of these three files, copy it locally to e.g. the desktop, rename it to **TurtleStitch.exe** and then use it to start TurtleStitch.  

Benefits: 
1. Have a TurtleStitch icon on the desktop that you can reference from training material regardless of how TurtleStitch is run.
2. Record a timestamp of when TurtleStitch was started. Can be used to track how many designs were started at a certain PC.
## TSUSB-Label
This program can be used to sequentially label a series of (generally blank) USB sticks.

## TSUSB-Export	
This program runs on the PC where the TurtleStitch design is made. It has two functionalities:
### Export the design to the USB stick
Insert a USB stick with a volume label starting with TURTLEST and then the design (.XML) and .DST file are exported to the USB stick after a number of configurable
checks have been done to see whether the design is OK.  
E.g. number of colors, size of the design, number of stitches. 

When the design is out of the acceptable range,
there is a password protected opportunity to overrule the errors.  

After exporting the stick is automaticallly ejected so no need to by by haned.

In case there is already a design on the stick
from a previous export then the user is given the choice to continue with the previous design or to backup the old design and use the stick for the new design as if it were empty.
### Update files on the desktop, the documents folder or the downloads folder
Insert a USB stick with volume label UPDATETS and files to be updated are copied from the stick to the respective locations. The stick is then ejected. 
Benefits: when having a set of off-line PCs, it is an easy way to quickly update e.g. training material.

## TSUSB-Clean
This program runs generally after a workshop on a single PC to move the designs from the stick to a folder for later reference. The USB stick is emptied. 
Or run it during the workshop when you run out of blank USB sticks. Inser the stick, wait for the copy to happen and remove the already ejected stick. 
You can also annotate the design in case you want. Annotated designs are copied to a different folder in order to quickly find them back.

## TSUSB-Import
This program is designed to copy a .DST file on a USB stick to one or more USB connected embroidery machines.

