function displayOneEquation(obj, rowID)
    %>展示指定globalID的单元格的离散方程系数
    for i = obj.rowStartID(rowID) : obj.rowStartID(rowID+1) - 1
        colID = obj.columnID(i);
        value = obj.matrix(i);
        sprintf(['a(', num2str(rowID), ', ', num2str(colID), ') = ', num2str(value)])
    end
    sprintf(['b(', num2str(rowID), ') = ', num2str(obj.b(rowID))])
end