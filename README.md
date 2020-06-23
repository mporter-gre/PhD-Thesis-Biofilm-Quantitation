The main focus of my PhD thesis is quantifying and interpreting bacterial multicellular behaviour in microscopy image data, primarily in the context of biofilms of Bacillus subtilis, but also in the firing of the Type VI Secretion System of Serratia marcescens. Storing and organising microscopy images on an OMERO server [1] allows convenient access to unprocessed intensity data from Matlab using the OMERO.matlab toolkit [2]. Within this environment I developed a set of tools designed to have generalised functionality for analysing intensity images and brought them together in a package called OMERO.mtools [3] with full source code available [4]. It is, however, sometimes necessary to perform bespoke analyses for very specific experiments. In this repository I present the code used in my thesis that fits this description. 

Of the functions here, two have been published previously. ‘YuabExtentAnalysis.m’ (run from its GUI in Interfaces/YuabExtentLaunchpad.m) was used to determine the penetrance of the YuaB protein into floating biofilms of B. subtilis [5] and ‘fpBacteriaSeg3D.m’ is a multi-step procedure for segmenting fluorescent S. marcescens cells for automatic cell counting [6].

The remainder of the code here was used to quantify laser scanning confocal microscopy of B. subtilis colony biofilms in three distinct temporal windows of growth: during “Colonisation”, when individual cells develop into a coherent biomass; throughout “Expansion”, when a monolayer of chains of cells grow radially from the central mass; and “Maturation”, where radial expansion virtually stops and the biomass becomes thicker. Wild-type NCBI 3610 strain growth was compared to specific gene-deletion strains using combinations of non-fluorescent cells, constitutively fluorescent (GFP) cells and cells harbouring a GFP promoter reporter for the eps operon.

Biological processes probed at each of these stages include the colonisation rate, eps expression via GFP signal intensity, and physical measurements such as the motion of features relative to the leading edge of the biofilm.

To use the code a Matlab environment should be set up with the OMERO.matlab toolkit of a version matching the server where the images are hosted, and a session object should be declared as global. Table 1 below explains the period of biofilm formation each file was used to analyse as well as the arguments and returns of each function, which are defined in Table 2.

[1] https://www.openmicroscopy.org/omero/
[2] https://www.openmicroscopy.org/omero/downloads/
[3] https://www.openmicroscopy.org/omero/features/analyze/
[4] https://github.com/mporter-gre/mtools
[5] Hobley, L., Ostrowski, A., Rao, F. V, Bromley, K.M., Porter, M., Prescott, A.R., et al. (2013) BslA is a self-assembling bacterial hydrophobin that coats the Bacillus subtilis biofilm. Proc Natl Acad Sci U S A 110: 13600–5 http://www.pubmedcentral.nih.gov/articlerender.fcgi?artid=3746881&tool=pmcentrez&rendertype=abstract
[6] Gerc, A.J., Diepold, A., Trunk, K., Porter, M., Rickman, C., Armitage, J.P., et al. (2015) Visualization of the Serratia Type VI Secretion System Reveals Unprovoked Attacks and Dynamic Assembly. Cell Rep 12: 2131–42 http://www.cell.com/article/S221112471500950X/fulltext

Table 1 | - | - | -
------- | - | - | -
Colonisation | Data Type | Arguments | Output 
------------ | --------- | --------- | ------
biofilmColonisationRate.m | Time-lapse | session, imageId, c | meanPatch, minMaxMeanPatch, grads, fdhm
measureCellOrientationsInMiddle.m | Single plane | session, imageId | props 
measureCellOrientationsInRing.m | Single plane | session, imageId | props
rotateImageAndImport.m | Single plane | session, imageId | 
roiIntensityOverTime.m | Time-lapse | session, imageId, c | meanPatch, minMaxMeanPatch, FXMinMax, fdhm
Expansion | | |
roiIntensityOverTime.m | Time-lapse | session, imageId, c | meanPatch, minMaxMeanPatch, FXMinMax, fdhm
biofilmGrowthRate.m | Time-lapse | session, imageId,  c, tRange | grad, rsq, micronsPerMinute
distanceFromBiofilmFront.m | ROI data | session, imageId,  rightMost, pointCoords | distFromFront, stats, gof
distFromBiofilmFrontVsStepGrad.m | ROI data | distFromFront, steps | startDistVsGrad, distFromFrontVsStep
trackPointROIDistances.m | ROI data | session, imageId | coords, distMat, steps 
Maturation | | |
biofilmVolumeSURF.m | Z-Stack | volumes | points 
volumeUnderBiofilm.m | Z-Stack | session, dsId | volumes, volSum
XYZProjectionMakeAndImport.m | Z-Stack | session, imageId, c, flipDim |



session |
OMERO session object
imageId |
OMERO image ID
c |
Channel number
tRange |
Time range e.g. [0-25]
rightMost |
Vector of x-coordinates
pointCoords |
Matrix of x-y coordinates, as columns
distFromFront
Vector of distances
steps |
Vector of step distances
volumes |
Volume map images
dsId |
OMERO dataset ID
flipDim |
Flip dimensions (Bool)
meanPatch |
Mean intensity of an ROI
minMaxMeanPatch |
Mean intensity of an ROI, normalised
grads |
Vector of gradients
fdhm |
Full duration half max
props |
Matlab regionprops
FXMinMax |
Normalised function of line
rsq |
R-Squared of fit
micronsPerMinute |
Speed of expansion
stats |
Statistics of fit
gof |
Goodness of fit
startDistVsGrad |
Matrix of start distance from biofilm front and grandients, as columns
distFromFrontVsStep |
Matrix of distance from biofilm front and grandients, as columns
points |
Matlab SURFPoint objects
volSum |
Sum of volume map image



