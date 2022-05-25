function computeInducedElectricField(obj, pc, eGroup)
    %>
    p = [eGroup(:).position];
    x = p(1:3:end);
    [~, ix] = max(obj.xField.data);
    leftIndex = ix(obj.NY+1) - 5;
    [~, ix] = min(obj.xField.data);
    rightIndex = ix(obj.NY+1) + 2;
    
    d1 = 100e-9;
    d2 = 100e-9;
    d3 = 100e-9;
    ratioD = 0.4;
    deltax = ratioD*d3;
    index = x >= (d1+d2) & x <= (d1+d2+deltax);
    numbers = sum(double(index));
    inducedE = 0.1*numbers*obj.superElecCharge/deltax/(pc.epsilonL*pc.epsilon0);
    
    obj.xField.data = obj.xFieldCopy.data;
    obj.xField.data(leftIndex:rightIndex, obj.NY+1) = ...
               obj.xField.data(leftIndex:rightIndex, obj.NY+1) + inducedE;
end