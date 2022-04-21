function computeGroupVelocityDOSTao(obj, cc, pc)
    %>计算群速度表/态密度表
    for k = 1 : cc.NW
        if cc.frequency.point(k+1) >= obj.wMinLA && cc.frequency.point(k+1) <= obj.wMaxLA
            obj.gvLA(k+1) = abs(spline(obj.band(:, 2), obj.band(:, 14), cc.frequency.point(k+1)));
            obj.dosLA(k+1) = 3*cc.frequency.point(k+1)^2 / (2*pi^2*obj.gvLA(k+1)^3);
        end
        if cc.frequency.point(k+1) >= obj.wMinLO && cc.frequency.point(k+1) <= obj.wMaxLO
            obj.gvLO(k+1) = abs(spline(obj.band(:, 12), obj.band(:, 15), cc.frequency.point(k+1)));
            obj.dosLO(k+1) = 3*cc.frequency.point(k+1)^2 / (2*pi^2*obj.gvLO(k+1)^3);
        end
    end
    % 弛豫时间
    for i = 1 : cc.NW
        invSumTao = 0;
        if obj.gvLA(i+1) ~= 0
            % Umklapp Scattering
            invTaou = 2*pc.gammaG^2*pc.kb*cc.envTemp ...
                       * cc.frequency.point(i+1)^2/(pc.miu*pc.V0*pc.omegaD);
            % Boundary Scattering
            invTaob = obj.gvLA(i+1)/(cc.modelx.face(end) - cc.modelx.face(1));
            % Combined
            invSumTao = invSumTao + invTaou + invTaob;
            obj.taoLA(i+1) = 1/invSumTao;
        end
        invSumTao = 0;
        if obj.gvLO(i+1) ~= 0
            invTaou = 2*pc.gammaG^2*pc.kb*cc.envTemp ...
                       * cc.frequency.point(i+1)^2/(pc.miu*pc.V0*pc.omegaD);
            invTaob = obj.gvLO(i+1)/(cc.modelx.face(end) - cc.modelx.face(1));
            invSumTao = invSumTao + invTaou + invTaob;
            obj.taoLO(i+1) = 1/invSumTao;
        end
    end
end