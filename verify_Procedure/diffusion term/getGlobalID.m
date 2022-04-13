function [globalID] = getGlobalID(~, ysize, xID, yID)
    %>从0开始
    globalID = (xID - 1) * ysize + yID;
end