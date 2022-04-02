function [] = verifyProgram(type, dv, pc, cc)
    %>验证
    switch type
        case "EnergyToVector"
            num = 1000;
            allowedError = 0.001;
            for i = 1 : num
                es = ElectricStatus;
                es.vector = [randNumber(-0.2,0.2) randNumber(-0.2, 0.2) randNumber(-0.2,0.2)] * pc.dGM;
                es.valley = 11;
                es.valley = dv.whichValley(es);
                dv.valleyGuidingPrinciple(es);
                es = dv.bs.computeEnergyAndVelocity(es, pc);
                item = es.energy;
                es = dv.bs.chooseWaveVector(es, pc, randNumber(0, pi));
                es = dv.bs.computeEnergyAndVelocity(es, pc);
                disp(es.energy / pc.e)
                if abs((es.energy - item)/item) > allowedError
                    error("能量正反验证错误！")
                end
            end
            if i == num
                disp("电子波矢选择与能量计算正反验证无误")
            end
        case "AcousticPiezoelectricScat"
            es = ElectricStatus;
            es.valley = 1;
            dv.valleyGuidingPrinciple(es);
            es.energy = 5.6*pc.e;
            dv.bs.chooseWaveVector(es, pc, randNumber(0, pi));
            dv.bs.computeEnergyAndVelocity(es, pc);
            dv.sr.updateScatterringRateFormula(dv, pc, cc);
            disp(dv.sr.thetaAP)
    end
end
