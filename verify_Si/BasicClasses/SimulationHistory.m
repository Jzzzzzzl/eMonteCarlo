classdef SimulationHistory < handle
    
    properties
        eGroup
        pGroup
        eHistory
        pHistory
    end
    
    methods
        
        function obj = SimulationHistory(bs, pc, cc)
            %构造函数
            obj.generateElectrics(bs, pc, cc);
            obj.generatePhonons(cc);
            obj.generateElectricsHistory(cc);
            obj.generatePhononsHistory(cc);
            
        end
        
        function generateElectrics(obj, bs, pc, cc)
            %生成电子群
            obj.eGroup = repmat(ElectricStatus(bs, pc, cc), cc.superElecs, 1);
            
        end
        
        function generatePhonons(obj, cc)
            %生成声子群
            obj.pGroup = repmat(PhononStatus, cc.superElecs, 1);
            
        end
        
        function generateElectricsHistory(obj, cc)
            %生成电子历史信息
            obj.eHistory = repmat(ElectricStatus, cc.superElecs, cc.noFly);
            
        end
        
        function generatePhononsHistory(obj, cc)
            %生成声子历史信息
            obj.pHistory = repmat(PhononStatus, cc.superElecs, cc.noFly);
            
        end
        
    end
end