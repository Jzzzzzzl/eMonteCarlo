function computeDivergence(obj, mm, divU)
    %>计算交叉网格散度
    for i = 1 : mm.NX
        deltax = mm.modelx.face(i + 1) - mm.modelx.face(i);
        for j = 1 : mm.NY
            deltay = mm.modely.face(j + 1) - mm.modely.face(j);
            temp = 0;
            temp = temp + (obj.datax(i + 1, j + 1) - obj.datax(i, j + 1)) * deltay;
            temp = temp + (obj.datay(i + 1, j + 1) - obj.datay(i + 1, j)) * deltax;
            divU.data(i + 1, j + 1) = temp / (deltax * deltay);
        end
    end
end