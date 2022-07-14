function computeGroupVelocityDOSTao(obj, cc, pc)
    %>计算群速度表/态密度表
    try
        tempT = max(max(cc.initTemp.data));
    catch
        tempT = cc.initTemp;
    end
    for k = 1 : cc.NW
        if cc.frequency.point(k+1) >= obj.wMin.LA && cc.frequency.point(k+1) <= obj.wMax.LA
            obj.gv.LA(k+1) = abs(spline(obj.qband(:, 2), obj.qband(:, 8), cc.frequency.point(k+1)));
            obj.dos.LA(k+1) = 3*cc.frequency.point(k+1)^2 / (2*pi^2*obj.gv.LA(k+1)^3);
        end
        if cc.frequency.point(k+1) >= obj.wMin.TA && cc.frequency.point(k+1) <= obj.wMax.TA
            obj.gv.TA(k+1) = abs(spline(obj.qband(:, 3), obj.qband(:, 9), cc.frequency.point(k+1)));
            obj.dos.TA(k+1) = 3*cc.frequency.point(k+1)^2 / (2*pi^2*obj.gv.TA(k+1)^3);
        end
        if cc.frequency.point(k+1) >= obj.wMin.LO && cc.frequency.point(k+1) <= obj.wMax.LO
            obj.gv.LO(k+1) = abs(spline(obj.qband(:, 5), obj.qband(:, 10), cc.frequency.point(k+1)));
            obj.dos.LO(k+1) = 3*cc.frequency.point(k+1)^2 / (2*pi^2*obj.gv.LO(k+1)^3) * 1e-2;
        end
        if cc.frequency.point(k+1) >= obj.wMin.TO && cc.frequency.point(k+1) <= obj.wMax.TO
            obj.gv.TO(k+1) = abs(spline(obj.qband(:, 6), obj.qband(:, 11), cc.frequency.point(k+1)));
            obj.dos.TO(k+1) = 3*cc.frequency.point(k+1)^2 / (2*pi^2*obj.gv.TO(k+1)^3) * 1e-2;
        end
    end
    % 弛豫时间
    for i = 1 : cc.NW
        invSumTao = 0;
        if obj.gv.LA(i+1) ~= 0
            % Umklapp Scattering
            invTaou = 2*pc.gammaG^2*pc.kb*tempT ...
                       * cc.frequency.point(i+1)^2/(pc.miu*pc.V0*pc.omegaD);
            % Boundary Scattering
            invTaob = obj.gv.LA(i+1)/(cc.modelx.face(end) - cc.modelx.face(1));
            % Combined
            invSumTao = invSumTao + invTaou + invTaob;
            obj.tao.LA(i+1) = 1/invSumTao;
        end
        invSumTao = 0;
        if obj.gv.TA(i+1) ~= 0
            invTaou = 2*pc.gammaG^2*pc.kb*tempT ...
                       * cc.frequency.point(i+1)^2/(pc.miu*pc.V0*pc.omegaD);
            invTaob = obj.gv.TA(i+1)/(cc.modelx.face(end) - cc.modelx.face(1));
            invSumTao = invSumTao + invTaou + invTaob;
            obj.tao.TA(i+1) = 1/invSumTao;
        end
        invSumTao = 0;
        if obj.gv.LO(i+1) ~= 0
            invTaou = 2*pc.gammaG^2*pc.kb*tempT ...
                       * cc.frequency.point(i+1)^2/(pc.miu*pc.V0*pc.omegaD);
            invTaob = obj.gv.LO(i+1)/(cc.modelx.face(end) - cc.modelx.face(1));
            invSumTao = invSumTao + invTaou + invTaob;
            obj.tao.LO(i+1) = 1/invSumTao;
        end
        invSumTao = 0;
        if obj.gv.TO(i+1) ~= 0
            invTaou = 2*pc.gammaG^2*pc.kb*tempT ...
                       * cc.frequency.point(i+1)^2/(pc.miu*pc.V0*pc.omegaD);
            invTaob = obj.gv.TO(i+1)/(cc.modelx.face(end) - cc.modelx.face(1));
            invSumTao = invSumTao + invTaou + invTaob;
            obj.tao.TO(i+1) = 1/invSumTao;
        end
    end
end