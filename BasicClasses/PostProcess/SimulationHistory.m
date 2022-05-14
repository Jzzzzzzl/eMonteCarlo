classdef SimulationHistory < handle
    %% 本文件提供历史信息记录类
    properties
        eGroup
        pGroup
    end
    
    methods
        function obj = SimulationHistory(dv, pc, cc)
            %>构造函数
            obj.generateElectrics(dv, pc, cc);
            obj.generatePhonons(cc);
        end
        
        function generateElectrics(obj, dv, pc, cc)
            %>生成电子群
            obj.eGroup = repmat(ElectricStatus, cc.superElecs, 1);
            for i = 1 : cc.superElecs
                obj.eGroup(i) = ElectricStatus;
                obj.eGroup(i).initializeElectricStatus(dv, pc, cc);
            end
        end
        
        function generatePhonons(obj, cc)
            %>生成声子群
            obj.pGroup = repmat(PhononStatus, cc.superElecs, 1);
            for i = 1 : cc.superElecs
                obj.pGroup(i) = PhononStatus;
                obj.pGroup(i).initializePhononStatus;
            end
        end
        
    end
end