function getFileID(obj, k)
    %>获得数据文件ID
    index = find(obj.parGrid >= k, 1) - 1;
    if obj.fileIndex == index
        return;
    else
        if obj.elog ~= 0
            fclose(obj.elog);
        end
        if obj.plog ~= 0
            fclose(obj.plog);
        end
        obj.fileIndex = index;
        obj.elog = fopen([obj.filePath, 'ElectronLogPart', num2str(index)], 'a+');
        obj.plog = fopen([obj.filePath 'PhononLogPart', num2str(index)], 'a+');
    end
end