function [] = verifyProgram(type, dv, pc, sc, cc)
    %>验证
    switch type
        case "EnergyToVector"
            num = 1000;
            allowedError = 0.001;
            for i = 1 : num
                es = ElectricStatus;
                es.vector = [randNumber(0.7,0.9) randNumber(-0.2, 0.2) randNumber(-0.2,0.2)] * pc.dBD;
                es.valley = 11;
                es.valley = dv.whichValley(es);
                dv.valleyGuidingPrinciple(es);
                es = dv.bs.computeEnergyAndGroupVelocity(es, pc);
                item = es.energy;
                es = dv.bs.chooseElectricWaveVector(es, pc, randNumber(0, pi));
                es = dv.bs.computeEnergyAndGroupVelocity(es, pc);
                disp(es.energy / pc.e)
                if abs((es.energy - item)/item) > allowedError
                    error("能量正反验证错误！")
                end
            end
            if i == num
                disp("电子波矢选择与能量计算正反验证无误")
            end
        case "AcousticPiezoelectricScatPlot"
            num = 500;
            es = ElectricStatus;
            es.valley = 11;
            dv.valleyGuidingPrinciple(es);
            energys = logspace(-5, 3, num) * pc.e;
            scatTables = zeros(num, 2);
            tic
            for i = 1 : num
                es.energy = energys(i);
                dv.bs.chooseElectricWaveVector(es, pc, randNumber(0, pi));
                dv.sr.acousticPiezoelectricScatteringRate(dv, es, pc, cc);
                scatTables(i, 1) = energys(i);
                scatTables(i, 2) = dv.sr.acousticPiezoelectric;
            end
            toc
            figure
            slg = loglog(scatTables(:, 1) / pc.e, scatTables(:, 2));
            slg.LineWidth = 3;
            xlabel("meV");
            ylabel("s^{-1}")
        case "chooseWaveVector"
            es = ElectricStatus;
            es.energy = 2.5*pc.e;
            number = 2000;
            tempk = zeros(number, 3);
            valleys = [1, -1, 2, -2, 3, -3, 4, -4, 5, -5, 6, -6];
            for i = 1 : number
                index = round(randNumber(0.5, 12.5));
                es.valley = valleys(index);
                es = dv.bs.chooseElectricWaveVector(es, pc, randNumber(0, pi));
                tempk(i, :) = es.vector;
            end
            figure
            plot3(tempk(:,1), tempk(:,2), tempk(:,3), '*')
            xlabel("kx");ylabel("ky");zlabel("kz");
            legend("k-space") 
        case "chooseWaveVectorForGamma"
            es = ElectricStatus;
            es.energy = 2.5*pc.e;
            number = 2000;
            tempk = zeros(number, 3);
            for i = 1 : number
                es.valley = 11;
                es = dv.bs.chooseElectricWaveVector(es, pc, randNumber(0, pi));
                tempk(i, :) = es.vector;
            end
            figure
            plot3(tempk(:,1), tempk(:,2), tempk(:,3), '*')
            xlabel("kx");ylabel("ky");zlabel("kz");
            legend("k-space") 
        case "testChooseVectorIntervalleyScattering"
            es = ElectricStatus;
            es.vector = [1.9813e+08 -0.1024 1.4830e+09];
            es.valley = 3;
            es.energy = 6.0820e-20;
            es.gamma = 6.9363e-20;
            es.epsilon = 6.0820e-20;
            es.scatype = 6;
            ps = PhononStatus;
            dv.valleyGuidingPrinciple(es);
            dv.sr.scatType = 6;
            for i = 1 : 1000
                [es, ps] = dv.sp.electricScatProcess(es, ps, dv, sc, pc);
                if ~isreal(es.vector(1))
                    error("出现虚数")
                end
            end
    end
end
