function modelMeshingAndReadData(obj, pc)
    %>构建节点和读取数据
    obj.updateConfigureConstants;
    %>划分网格
    obj.frequencyGrid(0, pc.maxFrequency, obj.NW);
    obj.modelXGrid(0, obj.mLength, obj.NX);
    obj.modelYGrid(0, obj.mWidth, obj.NY);
    obj.angleGrid(0, 2*pi, obj.NA);
    obj.energyGrid(0, pc.maxEnergy, obj.NE, 0.99, obj.NE/10);
    %>构建散射概率函数
    if obj.NX ~= 1%>非材料计算
        if obj.NY == 1
            obj.scatProba = zeros(obj.NX+2, 1);
            index0 = 2;
            index1 = find(obj.modelx.face >= (obj.d1 - obj.relaxLenPB), 1) + 1;
            index2 = find(obj.modelx.face >= obj.d1, 1) + 1;
            index3 = find(obj.modelx.face >= (obj.d1 + obj.d2), 1) + 1;
            index4 = find(obj.modelx.face >= (obj.d1 + obj.d2 + obj.relaxLenCH), 1) + 1;
            index5 = obj.NX + 1;
            obj.scatProba(index0:index1) = obj.minproba;
            obj.scatProba(index1+1:index2) = logspace(log10(obj.minproba), log10(obj.maxproba), index2-index1);
            obj.scatProba(index2+1:index3) = obj.maxproba;
            obj.scatProba(index3+1:index4) = logspace(log10(obj.maxproba), log10(obj.minproba), index4-index3);
            obj.scatProba(index4+1:index5) = obj.minproba;
        else
            disp("二维情况暂未考虑！")
        end
    else
        obj.scatProba = ones(3, 1);
    end
    %>若指定掺杂浓度，则构建均匀掺杂浓度和电子浓度物理场
    if isscalar(obj.initDopDen)
        obj.eleConc = ColocateField(obj, obj.initDopDen);
        obj.dopDensity = ColocateField(obj, obj.initDopDen);
    else %>否则读取模型数据
        obj.data2ColocatedField;
    end
    %>若指定标量温度，则构建单一标量温度场
    try
        obj.deviceTemp = ColocateField(obj, obj.initTemp);
    catch %>否则使用等效温度场
        obj.deviceTemp = obj.initTemp;
    end
    %>计算超电子电荷量
    obj.computeSuperElectricCharge;
end