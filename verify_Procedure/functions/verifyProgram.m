function [] = verifyProgram(type, dv, pc)
    % 验证
    
    switch type
        case "EnergyToVector"
            num = 500;
            allowedError = 0.001;
            for i = 1 : num
                es = ElectricStatus;
                es.vector = [randNumber(0.8,1.0) randNumber(0.1,0.2) randNumber(0.1,0.2)] * pc.dGX;
                es.valley = dv.whichValley(es);
                dv.judgeBsSrSp(es);
                es = dv.bs.computeEnergyAndVelocity(es, pc);
                item = es.energy;
                es = dv.bs.chooseWaveVector(es, pc);
                es = dv.bs.computeEnergyAndVelocity(es, pc);
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
