function importPlanesToOmero(session, stack, imageObj)
%Import planes after creating a new image. See CreateNewImage.m
%the stack should be 5D.
%Have the stack in the correct type, i.e. uint16 etc.

store = session.createRawPixelsStore;
pixels = imageObj.getPrimaryPixels;
pixelsId = pixels.getId.getValue;
store.setPixelsId(pixelsId, false);

[~, ~, numZ, numC, numT] = size(stack);

for thisZ = 1:numZ
    for thisC = 1:numC
        for thisT = 1:numT
            planeAsBytes = toByteArray(stack(:,:,thisZ,thisC,thisT)', pixels);
            store.setPlane(planeAsBytes, thisZ-1, thisC-1, thisT-1);
        end
    end
end
store.close