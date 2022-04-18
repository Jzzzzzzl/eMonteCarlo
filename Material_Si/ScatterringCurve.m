classdef ScatterringCurve < handle
    %% 色散曲线
    properties
        frequency
        omegaLA
        omegaTA
        omegaLO
        omegaTO
        gvLA
        gvTA
        gvLO
        gvTO
        dosLA
        dosTA
        dosLO
        dosTO
        taoLA
        taoTA
        taoLO
        taoTO
    end
    
    properties
        %各极化支频率定义域
        wMinLA
        wMaxLA
        wMinTA
        wMaxTA
        wMinLO
        wMaxLO
        wMinTO
        wMaxTO
        %谷间散射对应频率
        wgLA
        wgTA
        wgLO
        wgTO
        wfLA
        wfTA
        wfLO
        wfTO
    end
    
    methods
        function obj = ScatterringCurve(pc)
            %>构造函数
            obj.omegaLA = @(q) 0.000e13 + 8.861e3*q - 1.931e-7*q.^2;
            obj.omegaTA = @(q) 0.000e13 + 5.993e3*q - 3.165e-7*q.^2;
            obj.omegaLO = @(q) 9.473e13 + 5.876e2*q - 1.950e-7*q.^2;
            obj.omegaTO = @(q) 9.824e13 - 2.547e3*q + 1.140e-7*q.^2;
            %计算定义域及谷间声子频率
            obj.frequencyDomain(pc);
            obj.frequencyToInter(pc);
        end
        
        function frequencyDomain(obj, pc)
            %>各极化支频率定义域
            obj.wMinLA = double(obj.omegaLA(0));
            obj.wMaxLA = double(obj.omegaLA(pc.dGX));
            obj.wMinTA = double(obj.omegaTA(0));
            obj.wMaxTA = double(obj.omegaTA(pc.dGX));
            obj.wMinLO = double(obj.omegaLO(pc.dGX));
            obj.wMaxLO = double(obj.omegaLO(0));
            obj.wMinTO = double(obj.omegaTO(pc.dGX));
            obj.wMaxTO = double(obj.omegaTO(0));
        end
        
        function frequencyToInter(obj, pc)
            %>谷间散射对应频率
            obj.wgLA = double(obj.omegaLA(pc.qg));
            obj.wgTA = double(obj.omegaTA(pc.qg));
            obj.wgLO = double(obj.omegaLO(pc.qg));
            obj.wgTO = double(obj.omegaTO(pc.qg));
            obj.wfLA = double(obj.omegaLA(pc.qf));
            obj.wfTA = double(obj.omegaTA(pc.qf));
            obj.wfLO = double(obj.omegaLO(pc.qf));
            obj.wfTO = double(obj.omegaTO(pc.qf));
        end
        
        function frequency = phononFrequency(obj, ps)
            %>计算PhononStatus对象频率
            switch ps.polar
                case "LA"
                    frequency = double(obj.omegaLA(ps.wavenum));
                case "TA"
                    frequency = double(obj.omegaTA(ps.wavenum));
                case "LO"
                    frequency = double(obj.omegaLO(ps.wavenum));
                case "TO"
                    frequency = double(obj.omegaTO(ps.wavenum));
                otherwise
                    error("声子极化支类型有误！")
            end
        end
        function computeGroupVelocityDOSTao(obj, cc)
            % 初始化
            taoLA = zeros(NW+2,1);
            taoTA = zeros(NW+2,1);
            taoLO = zeros(NW+2,1);
            taoTO = zeros(NW+2,1);
            dosLA = zeros(NW+2,1);
            dosTA = zeros(NW+2,1);
            dosLO = zeros(NW+2,1);
            dosTO = zeros(NW+2,1);
            gvLA  = zeros(NW+2,1);
            gvTA  = zeros(NW+2,1);
            gvLO  = zeros(NW+2,1);
            gvTO  = zeros(NW+2,1);
            % 计算群速度表/态密度表
            GroupvLA = diff(omegaLA,q,1);
            GroupvTA = diff(omegaTA,q,1);
            GroupvLO = diff(omegaLO,q,1);
            GroupvTO = diff(omegaTO,q,1);
            wLA = double(abs(vpa(subs(omegaLA ,q,[grid.q.point]))));
            wTA = double(abs(vpa(subs(omegaTA ,q,[grid.q.point]))));
            wLO = double(abs(vpa(subs(omegaLO ,q,[grid.q.point]))));
            wTO = double(abs(vpa(subs(omegaTO ,q,[grid.q.point]))));
            vLA = double(abs(vpa(subs(GroupvLA,q,[grid.q.point]))));
            vTA = double(abs(vpa(subs(GroupvTA,q,[grid.q.point]))));
            vLO = double(abs(vpa(subs(GroupvLO,q,[grid.q.point]))));
            vTO = double(abs(vpa(subs(GroupvTO,q,[grid.q.point]))));
            for k = 1:NW+2
                if grid.w.point(k) >= wMinLA && grid.w.point(k) <= wMaxLA
                    gv.LA(k) = spline(wLA,vLA,grid.w.point(k));
                    dos.LA(k) = 3*grid.w.point(k)^2 / (2*pi^2*gv.LA(k)^3);
                end
                if grid.w.point(k) >= wMinTA && grid.w.point(k) <= wMaxTA
                    gv.TA(k) = spline(wTA,vTA,grid.w.point(k));
                    dos.TA(k) = 3*grid.w.point(k)^2 / (2*pi^2*gv.TA(k)^3);
                end
                if grid.w.point(k) >= wMinLO && grid.w.point(k) <= wMaxLO
                    gv.LO(k) = spline(wLO,vLO,grid.w.point(k));
                    dos.LO(k) = 3*grid.w.point(k)^2 / (2*pi^2*gv.LO(k)^3);
                end
                if grid.w.point(k) >= wMinTO && grid.w.point(k) <= wMaxTO
                    gv.TO(k) = spline(wTO,vTO,grid.w.point(k));
                    dos.TO(k) = 3*grid.w.point(k)^2 / (2*pi^2*gv.TO(k)^3);
                end 
            end
            % 弛豫时间
            invTaou = zeros(NW+2,1);
            invTaob = zeros(NW+2,1);
            for i = 1:NW+2
                invSumTao = 0;
                if gv.LA(i) ~= 0
                    % Umklapp Scattering
                    invTaou(i) = 2*gammaG^2*kb*T*grid.w.point(i)^2/(miu*V0*omegaD);
                    % Boundary Scattering
                    invTaob(i) = gv.LA(i)/mLength;
                    % Combined
                    invSumTao = invSumTao + invTaou(i) + invTaob(i);
                    tao.LA(i) = 1/invSumTao;
                end
                invSumTao = 0;
                if gv.TA(i) ~= 0
                    % Umklapp Scattering
                    invTaou(i) = 2*gammaG^2*kb*T*grid.w.point(i)^2/(miu*V0*omegaD);
                    % Boundary Scattering
                    invTaob(i) = gv.TA(i)/mLength;
                    % Combined
                    invSumTao = invSumTao + invTaou(i) + invTaob(i);
                    tao.TA(i) = 1/invSumTao;
                end
                invSumTao = 0;
                if gv.LO(i) ~= 0
                    % Umklapp Scattering
                    invTaou(i) = 2*gammaG^2*kb*T*grid.w.point(i)^2/(miu*V0*omegaD);
                    % Boundary Scattering
                    invTaob(i) = gv.LO(i)/mLength;
                    % Combined
                    invSumTao = invSumTao + invTaou(i) + invTaob(i);
                    tao.LO(i) = 1/invSumTao;
                end
                invSumTao = 0;
                if gv.TO(i) ~= 0
                    % Umklapp Scattering
                    invTaou(i) = 2*gammaG^2*kb*T*grid.w.point(i)^2/(miu*V0*omegaD);
                    % Boundary Scattering
                    invTaob(i) = gv.TO(i)/mLength;
                    % Combined
                    invSumTao = invSumTao + invTaou(i) + invTaob(i);
                    tao.TO(i) = 1/invSumTao;
                end
            end
            tao.LA(1) = tao.LA(2);
            tao.LA(NW+2) = tao.LA(NW+1);
            tao.TA(1) = tao.TA(2);
            tao.TA(NW+2) = tao.TA(NW+1);
            tao.LO(1) = tao.LO(2);
            tao.LO(NW+2) = tao.LO(NW+1);
            tao.TO(1) = tao.TO(2);
            tao.TO(NW+2) = tao.TO(NW+1);
        end
        
    end
end
