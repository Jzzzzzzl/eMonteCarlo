function computeInducedElectricField(obj, pc, eGroup)
    %>计算感生电场并更新xField
    p = [eGroup(:).position];
    x = p(1:3:end);
    indexs = x >= (obj.d1+obj.d2) & x <= (obj.d1+obj.d2+obj.sczWidth);
    numbers = sum(double(indexs));
    inducedE = obj.xsforInduce*numbers*obj.superElecCharge/...
                   obj.sczWidth/(pc.epsilonL*pc.epsilon0);
    obj.xField.data = obj.xFieldCopy.data;
    obj.xField.data(obj.leftIndex : obj.rightIndex, obj.NY+1) = ...
               obj.xField.data(obj.leftIndex : obj.rightIndex, obj.NY+1) + inducedE;
end