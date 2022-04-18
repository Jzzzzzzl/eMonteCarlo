function readElectricConcentration(obj)
    %>
    try
        load Eleconc.dat
    catch
        error("缺少Eleconc.dat文件！")
    end
    %>转化为国际量纲
    Eleconc(:,1) = 1e-6 * Eleconc(:,1);
    Eleconc(:,2) = 1e-6 * Eleconc(:,2);
    Eleconc(:,3) = 1e6 * Eleconc(:,3);
    obj.fieldInterpolation(Eleconc, obj.eleConc);
end