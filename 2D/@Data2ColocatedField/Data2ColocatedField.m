classdef Data2ColocatedField < handle
    %>
    properties
        xField
        yField
        xyField
        eleConc
        dopDensity
    end
    
    methods
        function data2ColocatedField(obj, mm)
            %>构造数据场
            obj.xField = ColocateField(mm);
            obj.yField = ColocateField(mm);
            obj.xyField = ColocateField(mm);
            obj.eleConc = ColocateField(mm);
            obj.dopDensity = ColocateField(mm);
            %>读取数据
            obj.readXElectricField(mm);
            obj.readYElectricField(mm);
            obj.readDopingDensity(mm);
            obj.readElectricConcentration(mm);
            sumSquaresOf2ColocatedField(mm, obj.xyField, obj.xField, obj.yField);
        end
    end
    
    methods
        readXElectricField(obj, mm)
        readYElectricField(obj, mm)
        readDopingDensity(obj, mm)
        readElectricConcentration(obj, mm)
        fieldInterpolation(~, mm, field1, field2)
    end
end