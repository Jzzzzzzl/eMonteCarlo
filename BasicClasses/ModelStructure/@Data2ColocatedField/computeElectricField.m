function [value] = computeElectricField(obj, es)
    %>计算电子所在单元格电场强度
    %>必须保证index1和index2为内部节点
    index1 = find(es.position(1) < obj.modelx.face, 1);
    if isempty(index1)
        index1 = obj.NX + 1;
    end
    if obj.NY ~= 1
        index2 = find(es.position(2) < obj.modely.face, 1);
        if isempty(index2)
            index2 = obj.NY + 1;
        end
        valuex = obj.xField.data(index1, index2);
        valuey = obj.yField.data(index1, index2);
        value = [valuex, valuey, 0];
    else
        valuex = obj.xField.data(index1, obj.NY + 1);
        value = [valuex, 0, 0];
    end
end