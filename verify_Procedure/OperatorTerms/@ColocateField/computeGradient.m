function computeGradient(obj, mm, grad)
    %>计算正交网格梯度
    for i = 2 : mm.NX
        deltax = mm.modelx.point(i + 1) - mm.modelx.point(i);
        for j = 1 : mm.NY
            grad.datax(i, j + 1) = (obj.data(i + 1, j + 1) - obj.data(i, j + 1)) / deltax;
        end
    end
    for j = 2 : mm.NY
        deltay = mm.modely.point(j + 1) - mm.modely.point(j);
        for i = 1 : mm.NX
            grad.datay(i + 1, j) = (obj.data(i + 1, j + 1) - obj.data(i + 1, j)) / deltay;
        end
    end
end