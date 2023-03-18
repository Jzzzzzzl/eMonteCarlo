function relax(obj, alpha)
    %>对流项松弛因子(扩散项不需要亚松弛修正)
    for rowID = 1 : obj.rowNumber
        ap = 1;
        for i = obj.rowStartID(rowID) : obj.rowStartID(rowID+1) - 1
            colID = obj.columnID(i);
            if rowID == colID
                ap = obj.matrix(i);
                obj.matrix(i) = ap / alpha;
                break;
            end
        end
        obj.addToRHS(rowID, ap * obj.result(rowID) * (1 - alpha) / alpha);
    end
end