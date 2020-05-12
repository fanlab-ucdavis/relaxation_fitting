# relaxation_fitting
MATLAB code for mono-exponential fitting of MRI relaxation parameters.

monoexponential_fit folder contains simple linear and non-linear routines to fit a single exponential.
Written by Samantha Holdsworth, Ph.D. and Wei Bian, Ph.D.


StimFit package is from Marc Lebel, Ph.D. (GE Healthcare).

Corrects for stimulated echoes to more accurately measure R2 decay parameter.
Current settings are for fast spin echo (FSE) scans with eight echoes acquired at Stanford PET/MRI.
Note that due to idiosyncrasies of the StimFit software, the 8-echo data is read into a 4D matrix
with 16 volumes, and half of these volumes (specific selected ones) are set to zero.
