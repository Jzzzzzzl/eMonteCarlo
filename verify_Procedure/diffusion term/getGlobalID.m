function [globalID] = getGlobalID(~, ysize, xID, yID)
    %>从0开始
    globalID = int8((xID - 1) * ysize + yID);
end