function computeTeff(obj, cc, pc, sc)
    %>计算等效温度
    obj.Teff = ColocateField(cc, cc.envTemp);
    energyLeft = ColocateField(cc);
    energyRight = ColocateField(cc);
    % 循环控制变量
    number = 2000;
    deltaT = 0.1;
    errorMax = 1e-3;
    
    for i = 1 : cc.NX
        for j = 1 : cc.NY
            error = zeros(number, 1);
            flag = -1;% 用于控制温度增减
            for p = 1 : number
                % 方程左边
                energyLA = 0; energyTA = 0;
                energyLO = 0; energyTO = 0;
                for k = 1 : cc.NW
                    deltaw = cc.frequency.face(k+1) - cc.frequency.face(k);
                    NLeft = 1 / (exp(pc.hbar*cc.frequency.point(k+1) / (pc.kb*obj.Teff.data(i+1, j+1))) - 1);
                    if cc.frequency.point(k+1) >= sc.wMinLA && cc.frequency.point(k+1) <= sc.wMaxLA
                        energyLA = energyLA + NLeft*pc.hbar*cc.frequency.point(k+1)*deltaw / sc.gvLA(k+1);
                    end
                    if cc.frequency.point(k+1) >= sc.wMinTA && cc.frequency.point(k+1) <= sc.wMaxTA
                        energyTA = energyTA + NLeft*pc.hbar*cc.frequency.point(k+1)*deltaw / sc.gvTA(k+1);
                    end
                    if cc.frequency.point(k+1) >= sc.wMinLO && cc.frequency.point(k+1) <= sc.wMaxLO
                        energyLO = energyLO + NLeft*pc.hbar*cc.frequency.point(k+1)*deltaw / sc.gvLO(k+1);
                    end
                    if cc.frequency.point(k+1) >= sc.wMinTO && cc.frequency.point(k+1) <= sc.wMaxTO
                        energyTO = energyTO + NLeft*pc.hbar*cc.frequency.point(k+1)*deltaw / sc.gvTO(k+1);
                    end
                end
                energyLeft(i+1, j+1) = (energyLA + energyTA + energyLO + energyTO) / (2*pi)^3;
                % 方程右边
                energyLA = 0; energyTA = 0;
                energyLO = 0; energyTO = 0;
                for k = 1 : cc.NW
                    deltaw = cc.frequency.face(k+1) - cc.frequency.face(k);
                    NRight = 1 / (exp(pc.hbar*cc.frequency.point(k+1) / (pc.kb*obj.TF.data(i+1, j+1))) - 1);
                    if cc.frequency.point(k+1) >= sc.wMinLA && cc.frequency.point(k+1) <= sc.wMaxLA
                        energyLA = energyLA + (obj.n(k).LA.data(i+1, j+1) + NRight)*pc.hbar*cc.frequency.point(k+1)*deltaw / sc.gvLA(k+1);
                    end
                    if cc.frequency.point(k+1) >= sc.wMinTA && cc.frequency.point(k+1) <= sc.wMaxTA
                        energyTA = energyTA + (obj.n(k).TA.data(i+1, j+1) + NRight)*pc.hbar*cc.frequency.point(k+1)*deltaw / sc.gvTA(k+1);
                    end
                    if cc.frequency.point(k+1) >= sc.wMinLO && cc.frequency.point(k+1) <= sc.wMaxLO
                        energyLO = energyLO + (obj.n(k).LO.data(i+1, j+1) + NRight)*pc.hbar*cc.frequency.point(k+1)*deltaw / sc.gvLO(k+1);
                    end
                    if cc.frequency.point(k+1) >= sc.wMinTO && cc.frequency.point(k+1) <= sc.wMaxTO
                        energyTO = energyTO + (obj.n(k).TO.data(i+1, j+1) + NRight)*pc.hbar*cc.frequency.point(k+1)*deltaw / sc.gvTO(k+1);
                    end
                end
                energyRight(i+1, j+1) = (energyLA + energyTA + energyLO + energyTO) / (2*pi)^3;
                % 左右校准
                error(p) = double(abs((energyRight(i+1, j+1) - energyLeft(i+1, j+1)) / energyRight(i+1, j+1)));
                if error(p) < errorMax
                    break;
                end
                if p >= 2 && (error(p) - error(p-1)) > 0
                    flag = -1*flag;
                end
                obj.Teff.data(i+1, j+1) = obj.Teff.data(i+1, j+1) + flag*deltaT;
            end
        end
    end

end