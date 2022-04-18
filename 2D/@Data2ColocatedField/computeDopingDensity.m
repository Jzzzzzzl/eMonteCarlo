function [value] = computeDopingDensity(obj, es)
    %>计算电子所在位置掺杂浓度
    index1 = find(es.position(1) < obj.modelx.face, 1);
    index2 = find(es.position(2) < obj.modely.face, 1);
    value = obj.dopDensity.data(index1, index2);
end