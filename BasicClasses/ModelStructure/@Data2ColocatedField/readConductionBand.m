function readConductionBand(obj)
    %>读取导带能量
    try
        load ConductionBand.dat
    catch
        error("缺少ConductionBand.dat文件！")
    end
    %>转化为国际量纲
    ConductionBand(:,1) = 1e-6 * ConductionBand(:,1);
    ConductionBand(:,2) = 1e-6 * ConductionBand(:,2);
    ConductionBand(:,3) = 1 * ConductionBand(:,3);
    obj.fieldInterpolation(ConductionBand, obj.conducBand, 'direct');
end