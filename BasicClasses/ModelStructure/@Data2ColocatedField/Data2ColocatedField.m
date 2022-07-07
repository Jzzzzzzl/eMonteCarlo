classdef Data2ColocatedField < BoundaryReflection
    %% 数据读取类
    properties
        %>x方向电场
        xField
        %>y方向电场
        yField
        %>总电场
        xyField
        %>电子浓度场
        eleConc
        %>掺杂浓度场
        dopDensity
        %>器件温度场
        deviceTemp
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
        computeSuperElectricCharge(obj)
        computePositionParameters(obj, es)
        fieldInterpolation(obj, field1, field2, method)
    end
    
end