function [] = VerifyProgram(type, bs, pc)
    % 验证
    
    switch type
        case "EnergyToVector"
            num = 200;
            allowedError = 0.001;
            
            for i = 1 : num
                es = ElectricStatus;
                es.vector = [Random(0.7,0.9) Random(0.1,0.3) Random(0.1,0.2)] * pc.dGX;
                es = es.WhichValleyNum;
                es = es.ComputeInParabolicFactor(pc);
                
%                 es.velocity = bs.ComputeElectricVelocity(es, pc);
%                 disp(es.velocity / 1e5)
%                 disp(es.vipara)
                
                es.energy = bs.ComputeElectricEnergy(es, pc);
                item = es.energy;
                es = bs.ChooseWaveVector(es, pc);
                es = es.ComputeInParabolicFactor(pc);
                es.energy = bs.ComputeElectricEnergy(es, pc);
                disp(es.energy / pc.e)
                
                if abs((es.energy - item)/item) > allowedError
                    error("能量正反验证错误！")
                end
            end
            if i == num
                disp("电子波矢选择与能量计算正反验证无误")
            end
    end
end
