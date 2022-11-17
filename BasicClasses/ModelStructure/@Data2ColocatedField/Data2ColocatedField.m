classdef Data2ColocatedField < BoundaryReflection
    %% 数据读取类
    properties
        %>电势场
        potential
        %>晶格温度场
        latticeTem
        %>焦耳热
        jouleHeat
        %>导带能量
        conducBand
        %>电子迁移率
        eMobility
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
            obj.potential = ColocateField(obj);
            obj.latticeTem = ColocateField(obj);
            obj.jouleHeat = ColocateField(obj);
            obj.conducBand = ColocateField(obj);
            obj.eMobility = ColocateField(obj);
            obj.xField = ColocateField(obj);
            obj.yField = ColocateField(obj);
            obj.xyField = ColocateField(obj);
            obj.eleConc = ColocateField(obj);
            obj.dopDensity = ColocateField(obj);
            %>读取数据
            obj.readPotential;
            obj.readLatticeTemperature;
            obj.readJouleHeatPower;
            obj.readConductionBand;
            obj.readElectronMobility;
            obj.readXElectricField;
            obj.readYElectricField;
            obj.readDopingDensity;
            obj.readElectricConcentration;
            sumSquaresOf2ColocatedField(obj, obj.xyField, obj.xField, obj.yField);
        end
    end
    
    methods
        readPotential(obj)
        readLatticeTemperature(obj)
        readJouleHeatPower(obj)
        readConductionBand(obj)
        readElectronMobility(obj)
        readXElectricField(obj)
        readYElectricField(obj)
        readDopingDensity(obj)
        readElectricConcentration(obj)
        computeSuperElectricCharge(obj)
        computePositionParameters(obj, es)
        fieldInterpolation(obj, field1, field2, method)
    end
    
end