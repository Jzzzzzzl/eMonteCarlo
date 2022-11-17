function readPotential(obj)
    %>读取电势场
    try
        load Potential.dat
    catch
        error("缺少Potential.dat文件！")
    end
    %>转化为国际量纲
    Potential(:,1) = 1e-6 * Potential(:,1);
    Potential(:,2) = 1e-6 * Potential(:,2);
    Potential(:,3) = 1 * Potential(:,3);
    obj.fieldInterpolation(Potential, obj.potential, 'direct');
end