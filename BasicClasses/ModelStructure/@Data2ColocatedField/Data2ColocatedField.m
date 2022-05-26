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
    properties
        noFly
        superElecs
        superElecCharge
    end
    properties
        elog
        plog
        filePath
        fileIndex
        parGrid
    end

    
    methods
        function obj = Data2ColocatedField
            obj.elog = 0;
            obj.plog = 0;
            obj.fileIndex = 0;
        end
        
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
        fieldInterpolation(obj, field1, field2)
    end
end