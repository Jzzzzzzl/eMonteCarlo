function addToMatrix(obj, rowID, colID, value)
    %>添加数值到CSR顺序表中
    found = false;
    globalID = 1;
    for i = obj.rowStartID(rowID) : obj.rowStartID(rowID+1) - 1
        if colID == obj.columnID(i)
            globalID = i;
            found = true;
            break;
        end
    end
    if found
        obj.matrix(globalID) = obj.matrix(globalID) + value;
    else
        error("未找到编号！添加系数失败！")
    end
end