function readXElectricField(obj)
    %>读取x方向电场数据
    try
        load XeField.dat
    catch
        error("缺少XeField.dat文件！")
    end
    %>转化为国际量纲
    XeField(:,1) = 1e-6 * XeField(:,1);
    XeField(:,2) = 1e-6 * XeField(:,2);
    XeField(:,3) = 1e2 * XeField(:,3);
    obj.fieldInterpolation(XeField, obj.xFieldCopy, 'spline');
end