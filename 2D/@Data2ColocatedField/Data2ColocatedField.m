classdef Data2ColocatedField < BoundaryReflection
    %% 
    properties
        xField
        yField
        xyField
        eleConc
        dopDensity
        superElecs
        superElecCharge
    end
    
    methods
        function data2ColocatedField(obj)
            %>构造数据场
            obj.xField = ColocateField(obj);
            obj.yField = ColocateField(obj);
            obj.xyField = ColocateField(obj);
            obj.eleConc = ColocateField(obj);
            obj.dopDensity = ColocateField(obj);
            %>读取数据
            obj.readXElectricField;
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