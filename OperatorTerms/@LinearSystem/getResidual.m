function [error] = getResidual(obj)
    %>计算误差
    error = 0;
    for rowID = 1 : obj.rowNumber
        ap = 0;
        residualInRow = 0;
        for i = obj.rowStartID(rowID) : obj.rowStartID(rowID+1) - 1
            colID = obj.columnID(i);
            aij = obj.matrix(i);
            residualInRow = residualInRow + aij * obj.result(colID);
            if rowID == colID
                ap = aij;
            end
        end
        residualInRow = residualInRow - obj.b(rowID);
        residualInRow = abs(residualInRow / ap);
        error = error + residualInRow;
    end
    error = error / obj.rowNumber;
end