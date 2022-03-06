classdef ParallelElectricSimulation < handle
    
    properties
        eGroup
        pGroup
        eHistory
        pHistory
        
        
    end
    
    methods
        
        function obj = ParallelElectricSimulation(bs, pc, cc)
            %
            
            obj.GenerateElectrics(bs, pc, cc);
            obj.GeneratePhonons(cc);
            obj.GenerateElectricsHistory(cc);
            obj.GeneratePhononsHistory(cc);
            
        end
        
        function GenerateElectrics(obj, bs, pc, cc)
            %生成电子群,并初始化
            
            obj.eGroup = repmat(ElectricStatus, cc.superElecs, 1);
            for i = 1 : cc.superElecs
                obj.eGroup(i) = obj.eGroup(i).InitializeStatus(bs, pc);
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
        
        function SubsectionParallelCompute(obj, bs, sr, sp, sc, pc, cc)
            %
            
            tic
            for k = 1 : cc.noFly
                %飞行完成后保存电子信息
                obj.ParallelCompute(bs, sr, sp, sc, pc, cc);
                obj.eHistory(:, k) = obj.eGroup;
                obj.pHistory(:, k) = obj.pGroup;
                %输出计算进度
                disp(['计算进度： ', num2str(k / cc.noFly * 100), '%']);
            end
            toc
        end
        
        function ParallelCompute(obj, bs, sr, sp, sc, pc, cc)
            %
            
            for i = 1 : cc.superElecs
                % 散射段
                sr.ScatterringTable(obj.eGroup(i), sc, pc, cc);
                obj.eGroup(i).scatype = sr.scatType;
                [obj.eGroup(i), obj.pGroup(i)] = sp.ElectricScatProcess(obj.eGroup(i), obj.pGroup(i), bs, sc, pc, sr);
                % 自由飞行段
                obj.eGroup(i) = obj.FreeFlyProcess(obj.eGroup(i), bs, sr, pc, cc);
            end
        end
        
        function [es] = FreeFlyProcess(~, es, bs, sr, pc, cc)
            %
            
            es.vector(1) = es.vector(1) + (-pc.e) * cc. electricField * sr.flyTime / pc.hbar;
            es = es.WhetherBeyondBrillouinZone(pc);
            es = es.WhichValleyNum;
            es = es.ComputeInParabolicFactor(pc);
            es.energy = bs.ComputeElectricEnergy(es, pc);
            es.velocity = bs.ComputeElectricVelocity(es, pc);
            es.position = es.position + es.velocity * sr.flyTime;
            es.time = es.time + sr.flyTime;
            
        end
        
        
        
        
        
    end
end