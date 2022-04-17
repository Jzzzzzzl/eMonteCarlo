function readDopingDensity(obj, mm)
    %>
    try
        load TotalDoping.dat
    catch
        error("缺少TotalDoping.dat文件！")
    end
    %>转化为国际量纲
    TotalDoping(:,1) = 1e-6 * TotalDoping(:,1);
    TotalDoping(:,2) = 1e-6 * TotalDoping(:,2);
    TotalDoping(:,3) = 1e6 * TotalDoping(:,3);
    obj.fieldInterpolation(mm, TotalDoping, obj.dopDensity);
end