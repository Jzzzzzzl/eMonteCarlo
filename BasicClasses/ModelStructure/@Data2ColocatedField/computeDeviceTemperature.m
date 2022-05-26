function [value] = computeDeviceTemperature(obj, es)
    %>计算电子所在位置器件温度
    index1 = find(es.position(1) < obj.modelx.face, 1) + 1;
    if isempty(index1)
        index1 = obj.NX + 1;
    end
    if obj.NY ~= 1
        index2 = find(es.position(2) < obj.modely.face, 1) + 1;
        if isempty(index2)
            index2 = obj.NY + 1;
        end
        value = obj.deviceTemp.data(index1, index2);
    else
        value = obj.deviceTemp.data(index1, obj.NY + 1);
    end
end