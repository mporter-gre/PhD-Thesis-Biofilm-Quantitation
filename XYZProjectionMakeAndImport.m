function XYZProjectionMakeAndImport(session, imageId, c, flipDim)

tic;
imageObj = getImages(session, imageId);
pixels = imageObj.getPrimaryPixels;
sizeX = pixels.getSizeX.getValue;
sizeY = pixels.getSizeY.getValue;
numZ = pixels.getSizeZ.getValue;
%numC = pixels.getSizeC.getValue;
numT = pixels.getSizeT.getValue;
physX = pixels.getPhysicalSizeX.getValue;
physY = pixels.getPhysicalSizeY.getValue;
physZ = pixels.getPhysicalSizeZ.getValue;
imageName = char(imageObj.getName.getValue.getBytes');
imageNameXZ = [imageName '_XZ'];
imageNameYZ = [imageName '_YZ'];
%stack = zeros(sizeY, sizeX, numZ, 1, numT);
if numZ<2
    disp('not enough z sections for projection');
    return;
end
for thisT = 1:numT
    for thisZ = 1:numZ
        stack(:,:,thisZ,1,thisT) = getPlane(session, imageId, thisZ-1, c-1, thisT-1);
    end
    XZProj(:,:,1,1,thisT) = squeeze(max(stack(:,:,:,:,thisT), [], 1));
    YZProj(:,:,1,1,thisT) = squeeze(max(stack(:,500:600,:,:,thisT), [], 2));
end
if flipDim == 1
    XZProj = flipdim(XZProj, 2);
    YZProj = flipdim(YZProj, 2);
end

XZImage = createNewImage(session, imageNameXZ, {525}, 'uint16', physX, physZ, 1, sizeX, numZ, 1, numT);
YZImage = createNewImage(session, imageNameYZ, {525}, 'uint16', physY, physZ, 1, sizeY, numZ, 1, numT);

importPlanesToOmero(session, permute(XZProj, [2 1 3 4 5]), XZImage);
importPlanesToOmero(session, permute(YZProj, [2 1 3 4 5]), YZImage);
toc;