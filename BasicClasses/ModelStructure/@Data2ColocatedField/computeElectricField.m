function [value] = computeElectricField(obj, es)
    %>计算电子所在单元格电场强度
    index1 = find(es.position(1) < obj.modelx.face, 1);
    if obj.NY ~= 1
        index2 = find(es.position(2) < obj.modely.face, 1);
        valuex = obj.xField.data(index1, index2);
        valuey = -obj.yField.data(index1, index2);
        value = [valuex, valuey, 0];
    else
        valuex = obj.xField.data(index1, obj.NY + 1);
        value = [valuex, 0, 0];
    end
end