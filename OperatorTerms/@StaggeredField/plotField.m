function plotField(obj, mm)
    %>交叉网格物理场画图
    if mm.NY == 1
        %>一维物理场画图
        X = mm.modelx.face(2:end-1);
        Z = obj.datax(2:end-1, mm.NY+1);
        figure
        slg = plot(X, Z);
        slg.LineWidth = 2;
    else
        %>二维物理场画图
        %>x分量画图
        X = mm.modelx.face(2:end-1);
        Y = mm.modely.point(2:end-1);
        Z = zeros(mm.NX - 1, mm.NY);
        for i = 2 : mm.NX
            for j = 1 : mm.NY
                Z(i - 1, j) = obj.datax(i, j + 1);
            end
        end
        Z = Z';
        figure
        subplot(1, 2, 1)
        mesh(X, Y, Z)
        colormap(jet)
        title('x分量')
        %>y分量画图
        X = mm.modelx.point(2:end-1);
        Y = mm.modely.face(2:end-1);
        Z = zeros(mm.NX, mm.NY - 1);
        for i = 1 : mm.NX
            for j = 2 : mm.NY
                Z(i, j - 1) = obj.datay(i + 1, j);
            end
        end
        Z = Z';
        subplot(1, 2, 2)
        mesh(X, Y, Z)
        colormap(jet)
        title('y分量')
    end
end