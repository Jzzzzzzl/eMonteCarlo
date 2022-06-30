function modelMeshingAndReadData(obj, pc)
    %>构建节点和读取数据
    obj.updateConfigureConstants;
    obj.frequencyGrid(0, pc.maxFrequency, obj.NW);
    obj.modelXGrid(0, obj.mLength, obj.NX);
    obj.modelYGrid(0, obj.mWidth, obj.NY);
    obj.angleGrid(0, 2*pi, obj.NA);
    obj.energyGrid(0, pc.maxEnergy, obj.NE, 0.99, obj.NE/10);
    %>若指定掺杂浓度，则构建掺杂浓度和电子浓度物理场
    if isscalar(obj.initDopDen)
        obj.eleConc = ColocateField(obj, obj.initDopDen);
        obj.dopDensity = ColocateField(obj, obj.initDopDen);
    else %>否则读取模型数据
        obj.data2ColocatedField;
    end
    %>若指定标量温度，则构建单一标量温度场
    if isscalar(obj.initTemp)
        obj.deviceTemp = ColocateField(obj, obj.initTemp);
    else %>否则使用等效温度场
        obj.deviceTemp = obj.initTemp;
    end
    obj.computeSuperElectricCharge;
end