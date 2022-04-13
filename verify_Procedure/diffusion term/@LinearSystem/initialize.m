function initialize(obj)
    %>
    for i = 1 : obj.matrixSize
        obj.matrix(i) = 0;
    end
    for i = 1 : obj.rowNumber
        obj.b(i) = 0;
        obj.result(i) = 0;
    end
end