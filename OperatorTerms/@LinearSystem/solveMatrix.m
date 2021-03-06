function solveMatrix(obj, iterNum)
    %>高斯赛德尔求解矩阵
    for iter = 1 : iterNum
        for rowID = 1 : obj.rowNumber
            temp = obj.b(rowID);
            ap = 0;
            for i = obj.rowStartID(rowID) : obj.rowStartID(rowID+1) - 1
                colID = obj.columnID(i);
                if rowID ~= colID
                    aij = obj.matrix(i);
                    temp = temp - aij * obj.result(colID);
                else
                    ap = obj.matrix(i);
                end
            end
            temp = temp / ap;
            obj.result(rowID) = temp;
        end
        errorMax = obj.getResidual;
        if errorMax <= 1e-7
            break;
        end
    end
end