classdef Data2ColocatedField < BoundaryReflection
    %% 数据读取类
    properties
        xField
        yField
        xyField
        eleConc
        dopDensity
        superElecs
        superElecCharge
        xFieldCopy
    end
    
    methods
        function data2ColocatedField(obj)
            %>构造数据场
            obj.xField = ColocateField(obj);
            obj.yField = ColocateField(obj);
            obj.xyField = ColocateField(obj);
            obj.eleConc = ColocateField(obj);
            obj.dopDensity = ColocateField(obj);
            obj.xFieldCopy = ColocateField(obj);
            %>读取数据
            obj.readXElectricField;
            obj.xFieldCopy.data = obj.xField.data;
            obj.readYElectricField;
            obj.readDopingDensity;
            obj.readElectricConcentration;
            sumSquaresOf2ColocatedField(obj, obj.xyField, obj.xField, obj.yField);
        end
    end
    
    methods
        readXElectricField(obj)
        readYElectricField(obj)
        readDopingDensity(obj)
        readElectricConcentration(obj)
        fieldInterpolation(obj, field1, field2)
    end
end