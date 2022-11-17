function readJouleHeatPower(obj)
    %>读取焦耳热
    try
        load JouleHeatPower.dat
    catch
        error("缺少JouleHeatPower.dat文件！")
    end
    %>转化为国际量纲
    JouleHeatPower(:,1) = 1e-6 * JouleHeatPower(:,1);
    JouleHeatPower(:,2) = 1e-6 * JouleHeatPower(:,2);
    JouleHeatPower(:,3) = 1e6 * JouleHeatPower(:,3);
    obj.fieldInterpolation(JouleHeatPower, obj.jouleHeat, 'direct');
end