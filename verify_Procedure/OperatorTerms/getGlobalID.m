function [globalID] = getGlobalID(~, ysize, xID, yID)
    %>计算单元格CSR编号(从1开始)
    globalID = (xID - 1) * ysize + yID;
end