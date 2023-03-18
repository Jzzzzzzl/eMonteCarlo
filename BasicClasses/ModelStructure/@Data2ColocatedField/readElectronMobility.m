function readElectronMobility(obj)
    %>读取电子迁移率
    try
        load EMobility.dat
    catch
        error("缺少EMobility.dat文件！")
    end
    %>转化为国际量纲
    EMobility(:,1) = 1e-6 * EMobility(:,1);
    EMobility(:,2) = 1e-6 * EMobility(:,2);
    EMobility(:,3) = 1 * EMobility(:,3);
    obj.fieldInterpolation(EMobility, obj.eMobility, 'direct');
end