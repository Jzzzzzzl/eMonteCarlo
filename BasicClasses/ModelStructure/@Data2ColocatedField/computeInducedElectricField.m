function computeInducedElectricField(obj, pc, eGroup)
    %>计算感生电场并更新xField
    p = [eGroup(:).position];
    x = p(1:3:end);
    y = p(2:3:end);
    if obj.NY == 1
        indexsx = x >= (obj.d1+obj.d2) & x <= (obj.d1+obj.d2+obj.sczLength);
        numbers = sum(double(indexsx));
        inducedE = obj.xsforInduce*numbers*obj.superElecCharge/...
                       obj.sczLength/(pc.epsilonL*pc.epsilon0);
        obj.xField.data = obj.xFieldCopy.data;
        obj.xField.data(obj.induceEl : obj.induceEr, obj.NY+1) = ...
                   obj.xField.data(obj.induceEl : obj.induceEr, obj.NY+1) + inducedE;
    else
        indexsx = x >= (obj.d1+obj.d2+obj.d3) & x <= (obj.d1+obj.d2+obj.d3+obj.sczLength);
        indexsy = y >= (obj.mWidth - obj.sczWidth) & y <= obj.mWidth;
        numbers = sum(double(indexsx & indexsy));
        inducedE = obj.xsforInduce*numbers*obj.superElecCharge/...
                       (obj.sczWidth)/(pc.epsilonL*pc.epsilon0);
        obj.xField.data = obj.xFieldCopy.data;
        obj.xField.data(obj.induceEl : obj.induceEr, obj.induceEb : obj.induceEt) = ...
                   obj.xField.data(obj.induceEl : obj.induceEr, obj.induceEb : obj.induceEt) + inducedE;
    end
end