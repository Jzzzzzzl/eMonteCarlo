classdef Data2ColocatedField < BoundaryReflection
    %% 数据读取类
    properties
        xField
        xFieldCopy
        yField
        yFieldCopy
        xyField
        eleConc
        dopDensity
        deviceTemp
    end
    
    methods
        function data2ColocatedField(obj)
            %>构造数据场
            obj.xField = ColocateField(obj);
            obj.xFieldCopy = ColocateField(obj);
            obj.yField = ColocateField(obj);
            obj.yFieldCopy = ColocateField(obj);
            obj.xyField = ColocateField(obj);
            obj.eleConc = ColocateField(obj);
            obj.dopDensity = ColocateField(obj);
            %>读取数据
            obj.readXElectricField;
            obj.readYElectricField;
            obj.readDopingDensity;
            obj.readElectricConcentration;
            sumSquaresOf2ColocatedField(obj, ...
                obj.xyField, obj.xFieldCopy, obj.yFieldCopy);
        end
    end
    
    methods
        readXElectricField(obj)
        readYElectricField(obj)
        readDopingDensity(obj)
        readElectricConcentration(obj)
        fieldInterpolation(obj, field1, field2, method)
        computeSuperElectricCharge(obj)
    end
end