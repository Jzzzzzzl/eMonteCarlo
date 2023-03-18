function getFileID(obj, index)
    %>获得数据文件ID
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
        obj.elog = fopen([obj.filePath, 'ElectronLogPart', num2str(obj.fileIndex)], 'a+');
        obj.plog = fopen([obj.filePath 'PhononLogPart', num2str(obj.fileIndex)], 'a+');
    end
end