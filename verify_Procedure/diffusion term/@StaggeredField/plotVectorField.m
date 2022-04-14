function plotVectorField(obj, mm)
    %>矢量图
    if mm.NX ~= mm.NY
        error("只有NX == NY时才能画矢量图！")
    end
    X = mm.modelx.point;
    Y = mm.modely.face;
    figure
    quiver(X, Y, obj.datax, obj.datay')
end