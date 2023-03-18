function readLatticeTemperature(obj)
    %>读取晶格温度场
    try
        load LatticeTem.dat
    catch
        error("缺少LatticeTem.dat文件！")
    end
    %>转化为国际量纲
    LatticeTem(:,1) = 1e-6 * LatticeTem(:,1);
    LatticeTem(:,2) = 1e-6 * LatticeTem(:,2);
    LatticeTem(:,3) = 1 * LatticeTem(:,3);
    obj.fieldInterpolation(LatticeTem, obj.latticeTem, 'direct');
end