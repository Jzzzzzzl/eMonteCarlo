function computeSuperElectricCharge(obj)
    %>计算超电子电荷量
    sumCharge = 0;
    e = 1.602176634e-19;
    for i = 1 : obj.NX
        deltax = obj.modelx.face(i + 1) - obj.modelx.face(i);
        for j = 1 : obj.NY
            deltay = obj.modely.face(j + 1) - obj.modely.face(j);
            sumCharge = obj.eleConc.data(i + 1, j + 1) * deltax * deltay;
        end
    end
    obj.superElecCharge = sumCharge * e / obj.superElecs;
    disp(['超电子电荷量为：', sprintf('%.3f', obj.superElecCharge/e), ' e/m'])
end