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
            
            obj.GenerateElectrics(bs, pc, cc);
            obj.GeneratePhonons(cc);
            obj.GenerateElectricsHistory(cc);
            obj.GeneratePhononsHistory(cc);
            
        end
        
        function GenerateElectrics(obj, bs, pc, cc)
            %生成电子群,并初始化
            
            obj.eGroup = repmat(ElectricStatus, cc.superElecs, 1);
            for i = 1 : cc.superElecs
                obj.eGroup(i).InitializeStatus(bs, pc);
            end
            
        end
        
        function GeneratePhonons(obj, cc)
            %生成声子群
            
            obj.pGroup = repmat(PhononStatus, cc.superElecs, 1);
            
        end
        
        function GenerateElectricsHistory(obj, cc)
            %生成电子历史信息
            
            obj.eHistory = repmat(ElectricStatus, cc.superElecs, cc.noFly);
            
        end
        
        function GeneratePhononsHistory(obj, cc)
            %生成声子历史信息
            
            obj.pHistory = repmat(PhononStatus, cc.superElecs, cc.noFly);
            
        end
        
    end
    
end