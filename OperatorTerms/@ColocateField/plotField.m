function plotField(obj, mm, ~)
    %>正交网格物理场画图
    if nargin == 3
        figure
    else
        hold on
    end
    if mm.NY == 1
        %>一维物理场画图
        X = mm.modelx.point(2:end-1);
        Z = obj.data(2:end-1, mm.NY+1);
        slg = plot(X, Z);
        slg.LineWidth = 2;
    else
        %>二维物理场画图
        X = mm.modelx.point(2:end-1);
        Y = mm.modely.point(2:end-1);
        Z = zeros(mm.NX, mm.NY);
        for i = 1 : mm.NX
            for j = 1 : mm.NY
                Z(i, j) = obj.data(i+1, j+1);
            end
        end
        Z = Z';%数据结构差一个转置
        pcolor(X, Y, Z);
        shading interp
        colormap(jet)
    end
end