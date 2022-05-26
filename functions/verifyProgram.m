function [] = verifyProgram(type, dv, pc, ~, cc)
    %>验证
    switch type
        case "EnergyToVector"
            %>验证选择波矢和能量计算是否可逆
            num = 10000;
            allowedError = 0.001;
            es = ElectricStatus;
            valleys = [1, 11, 13];
            for n = 1 : length(valleys)
                es.valley = valleys(n);
                for i = 1 : num
                    es.vector = [randNumber(-0.9, 0.9) randNumber(-0.9, 0.9) ...
                                     randNumber(-0.9, 0.9)] * pc.dBD;
                    es.valley = EPWaveVectorModify.whichValley(es);
                    dv.valleyGuidingPrinciple(es);
                    es = dv.valley.computeEnergyAndGroupVelocity(es, pc);
                    item = es.energy;
                    k = dv.valley.generateStandardElectricWaveVector(es, pc, randNumber(0, pi));
                    es = dv.valley.getGeneralElectricWaveVector(es, pc, k);
                    es = dv.valley.computeEnergyAndGroupVelocity(es, pc);
                    if abs((es.energy - item)/item) > allowedError
                        error("能量正反验证错误！")
                    end
                end
            end
            disp("能量正反验证无误！")
            
        case "AcousticPiezoelectricScatPlot"
            num = 500;
            es = ElectricStatus;
            es.position = [0 0 0];
            es.valley = 11;
            dv.valleyGuidingPrinciple(es);
            energys = logspace(-5, 3, num) * pc.e;
            scatTables = zeros(num, 2);
            tic
            for i = 1 : num
                es.energy = energys(i);
                k = dv.valley.generateStandardElectricWaveVector(es, pc, randNumber(0, pi));
                es = dv.valley.getGeneralElectricWaveVector(es, pc, k);
                dv.valley.acousticPiezoelectricScatteringRate(es, pc, cc);
                scatTables(i, 1) = energys(i);
                scatTables(i, 2) = dv.valley.acousticPiezoelectric;
            end
            toc
            figure
            slg = loglog(scatTables(:, 1) / pc.e, scatTables(:, 2));
            slg.LineWidth = 3;
            xlabel("meV");
            ylabel("s^{-1}")
            
        case "ValleyStructureOfValleyU"
            es = ElectricStatus;
            es.energy = 8.5*pc.e;
            es.position = [0 0 0];
            number = 2000;
            tempk = zeros(number, 3);
            valleys = [1, -1, 2, -2, 3, -3, 4, -4, 5, -5, 6, -6];
            for i = 1 : number
                index = round(randNumber(0.5, 12.5));
                es.valley = valleys(index);
                dv.valleyGuidingPrinciple(es);
                k = dv.valley.generateStandardElectricWaveVector(es, pc, randNumber(0, pi));
                es = dv.valley.getGeneralElectricWaveVector(es, pc, k);
                tempk(i, :) = es.vector;
            end
            figure
            plot3(tempk(:,1), tempk(:,2), tempk(:,3), '*')
            xlabel("kx");ylabel("ky");zlabel("kz");
            legend("k-space")
            
        case "ValleyStructureOfValleyGamma"
            es = ElectricStatus;
            es.energy = 3*pc.e;
            es.position = [0 0 0];
            number = 2000;
            tempk = zeros(number, 3);
            valleys = [11, 13];
            figure
            hold on
            for n = 1 : 2
                es.valley = valleys(n);
                dv.valleyGuidingPrinciple(es);
                for i = 1 : number
                    k = dv.valley.generateStandardElectricWaveVector(es, pc, randNumber(0, pi));
                    es = dv.valley.getGeneralElectricWaveVector(es, pc, k);
                    tempk(i, :) = es.vector;
                end
                plot3(tempk(:,1), tempk(:,2), tempk(:,3), '*')
            end
            xlabel("kx");ylabel("ky");zlabel("kz");
            legend("Gmma1", "Gamma3")
            
        case "SingleValleyDrifVelocityWithMaxScatRate"
            es = ElectricStatus;
            es.valley = 11;
            dv.valleyGuidingPrinciple(es);
            es.energy = 2*pc.e;
            number = 5000;
            perdrift = zeros(number, 2);
            if ~isvector(cc.eField)
                error("请输入电场向量！")
            end
            for i = 1 : number
                k = dv.valley.generateStandardElectricWaveVector(es, pc, randNumber(0, pi));
                es = dv.valley.getGeneralElectricWaveVector(es, pc, k);
                energyTemp = es.energy;
                vectorTemp = es.vector;
                dv.valley.computeFlyTime(es);
                es.vector = es.vector + (-pc.e) * cc.eField(2)*cc.direction*dv.valley.flyTime / pc.hbar;
                es = dv.valley.computeEnergyAndGroupVelocity(es, pc);
                vectorMold = sqrt(sum((vectorTemp - es.vector).^2));
                es.perdrift = (es.energy - energyTemp) / (pc.hbar * vectorMold);
                es = dv.valley.modifyElectricWaveVector(es, pc);
                es = dv.valley.computeEnergyAndGroupVelocity(es, pc);
                perdrift(i, 1) = vectorMold;
                perdrift(i, 2) = es.perdrift;
            end
            plot(perdrift(:, 1), perdrift(:, 2), '*')
            legend(['vd = ', num2str(sum(perdrift(:, 2)).*1e-7), ' x10^7 cm/s'])
            
        case 'inducedElectricField1D'
            N = 100;
            numbers = linspace(1, cc.superElecs, N);
            for i = 1 : N
                inducedE = cc.xsforInduce*numbers(i)*cc.superElecCharge/...
                               cc.sczWidth/(pc.epsilonL*pc.epsilon0);
                cc.xField.data = cc.xFieldCopy.data;
                cc.xField.data(cc.leftIndex : cc.rightIndex, cc.NY+1) = ...
                           cc.xField.data(cc.leftIndex : cc.rightIndex, cc.NY+1) + inducedE;
                plot(cc.modelx.point(2:end)*1e9, cc.xField.data(2:end, 2))
                axis([0 cc.modelx.face(end)*1e9 -3e7 8e7])
                title(['区域内超电子数：' num2str(numbers(i))])
                drawnow;
            end
            
        case 'verifyConfigureSettings'
            if rem(cc.noFly/cc.localWorkers, 1) ~= 0
                error('将飞行次数设置为核数的整数倍！')
            end
            if exist([cc.filePath 'ElectronLog'], 'file')
                error('先将文件夹清空！')
            end
            disp('没问题了，开始模拟吧！')
    end
end
