function meshPlot(obj)
    %>模型网格画图
    X = obj.modelx.face;
    Y = obj.modely.face;
    Z = ones(obj.NY + 1, obj.NX + 1);
    figure
    mesh(X, Y, Z)
end