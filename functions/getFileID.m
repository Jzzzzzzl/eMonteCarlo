function [elog, plog] = getFileID(cc, parGrid, k)
    %>获得数据文件ID
    index = find(parGrid >= k, 1) - 1;
    elog = fopen([cc.filePath, '/eDatas/ElectronLog'], 'a+');
    plog = fopen([cc.filePath '/pDatas/PhononLogPart', num2str(index)], 'a+');
end