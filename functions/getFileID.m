function [] = getFileID(cc, k)
    %>获得数据文件ID
    index = find(cc.parGrid >= k, 1) - 1;
    if cc.fileIndex == index
        return;
    else
        if cc.elog ~= 0
            fclose(cc.elog);
        end
        if cc.plog ~= 0
            fclose(cc.plog);
        end
        cc.fileIndex = index;
        cc.elog = fopen([cc.filePath, 'ElectronLogPart', num2str(index)], 'a+');
        cc.plog = fopen([cc.filePath 'PhononLogPart', num2str(index)], 'a+');
    end
end