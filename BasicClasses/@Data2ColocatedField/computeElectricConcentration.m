function [value] = computeElectricConcentration(obj, es)
    %>计算电子所在位置电子密度
    index1 = find(es.position(1) < obj.modelx.face, 1);
    if obj.NY ~= 1
        index2 = find(es.position(2) < obj.modely.face, 1);
        value = obj.eleConc.data(index1, index2);
    else
        value = obj.eleConc.data(index1, obj.NY + 1);
    end
end