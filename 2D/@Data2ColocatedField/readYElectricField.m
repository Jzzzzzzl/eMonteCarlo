function readYElectricField(obj)
    %>
    try
        load YeField.dat
    catch
        error("缺少YeField.dat文件！")
    end
    %>转化为国际量纲
    YeField(:,1) = 1e-6 * YeField(:,1);
    YeField(:,2) = 1e-6 * YeField(:,2);
    YeField(:,3) = 1e2 * YeField(:,3);
    obj.fieldInterpolation(YeField, obj.yField);
end