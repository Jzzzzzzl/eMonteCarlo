function readHeatConductivity(obj)
    %>读取热导率
    try
        load HeatConduc.dat
    catch
        error("缺少HeatConduc.dat文件！")
    end
    %>转化为国际量纲
    HeatConduc(:,1) = 1e-6 * HeatConduc(:,1);
    HeatConduc(:,2) = 1e-6 * HeatConduc(:,2);
    HeatConduc(:,3) = 100 * HeatConduc(:,3);
    obj.fieldInterpolation(HeatConduc, obj.heatConduc, 'direct');
end