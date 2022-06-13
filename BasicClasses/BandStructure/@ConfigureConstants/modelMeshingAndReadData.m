function modelMeshingAndReadData(obj, pc)
    %>构建节点和读取数据
    obj.updateConfigureConstants;
    obj.frequencyGrid(0, pc.maxFrequency, obj.NW);
    obj.modelXGrid(0, obj.mLength, obj.NX);
    obj.modelYGrid(0, obj.mWidth, obj.NY);
    if isscalar(obj.initDopDen)
        obj.eleConc = ColocateField(obj, obj.initDopDen);
        obj.dopDensity = ColocateField(obj, obj.initDopDen);
    else
        obj.data2ColocatedField;
    end
    obj.deviceTemp = ColocateField(obj, obj.initTemp);
    obj.computeSuperElectricCharge;
end