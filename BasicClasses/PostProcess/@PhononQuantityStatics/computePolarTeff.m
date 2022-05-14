function computePolarTeff(obj, cc, sc, type)
    
    
    switch type
        case 'LA'
            wMin = sc.wMinLA; wMax = sc.wMaxLA;
            gvelocity = sc.gvLA;
            for k = 1 : cc.NW
                nn(k).polar = n(k).LA;
            end
        case 'TA'
            wMin = sc.wMinTA; wMax = sc.wMaxTA;
            gvelocity = sc.gvTA;
            for k = 1 : cc.NW
                nn(k).polar = n(k).TA;
            end
        case 'LO'
            wMin = sc.wMinLO; wMax = sc.wMaxLO;
            gvelocity = sc.gvLO;
            for k = 1 : cc.NW
                nn(k).polar = n(k).LO;
            end
        case 'TO'
            wMin = sc.wMinTO; wMax = sc.wMaxTO;
            gvelocity = sc.gvTO;
            for k = 1 : cc.NW
                nn(k).polar = n(k).TO;
            end
    end
    function subComputepTeff(cc)
        %>计算极化支等效温度
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
                    energy = 0;
                    for k = 1 : cc.NW
                        deltaw = cc.frequency.face(k+1) - cc.frequency.face(k);
                        NLeft = 1 / (exp(pc.hbar*cc.frequency.point(k+1) / (pc.kb*obj.pTeff.data(i+1, j+1))) - 1);
                        if cc.frequency.point(k+1) >= wMin && cc.frequency.point(k+1) <= wMax
                            energy = energy + NLeft*pc.hbar*cc.frequency.point(k+1)*deltaw / gvelocity(k+1);
                        end
                    end
                    energyLeft(j+1,i+1) = energy / (2*pi)^3;
                    % 方程右边
                    energy = 0;
                    for k = 1:NW
                        deltaw = cc.frequency.face(k+1) - cc.frequency.face(k);
                        NRight = 1 / (exp(pc.hbar*cc.frequency.point(k+1) / (pc.kb*obj.pTeff.data(i+1, j+1))) - 1);
                        if cc.frequency.point(k+1) >= wMin && cc.frequency.point(k+1) <= wMax
                            energy = energy + (nn(k).polar(j+1,i+1) + NRight)*hbar*cc.frequency.point(k+1)*deltaw / gvelocity(k+1);
                        end
                    end
                    energyRight(j+1,i+1) = energy / (2*pi)^3;
                    % 左右校准
                    error(p) = double(abs((energyRight(j+1,i+1) - energyLeft(j+1,i+1)) / energyRight(j+1,i+1)));
                    if error(p) < errorMax
                        break;
                    end
                    if p >= 2 && (error(p) - error(p-1)) > 0
                        flag = -1*flag;
                    end
                    pTeff(j+1,i+1) = pTeff(j+1,i+1) + flag*deltaT;
                end
            end
        end
    end


end
