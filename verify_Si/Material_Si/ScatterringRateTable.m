classdef ScatterringRateTable < handle
    
    properties
        impuscat
        intrascat
        interscatab
        interscatem
        scatTable
        scatTableAll
        scatType
        flyTime
    end
    
    
    methods
        
        function obj = ScatterringRateTable(Material, pc, cc)
            % 三种散射的句柄函数
            
            if strcmpi(Material, "Si")
                % 电离杂质散射(弹性近似)
                b = @(energy, Ni) pc.e^2 * pc.hbar^2 * Ni / (8 * pc.epsilon0 * pc.epsilonSi * pc.kb * cc.envTemp * pc.md * energy);
                obj.impuscat = @(energy, Ni) sqrt(2) * pi * Ni * pc.e^4 / ((4 * pi * pc.epsilon0 * pc.epsilonSi)^2 * pc.md^(1/2))...
                                                        * energy^(-3/2) / (4 * b(energy, Ni) * (1 + b(energy, Ni))) * cc.xsForimpurity;
                % 声学波形变势散射(弹性近似)
                obj.intrascat = @(energy, D, u) sqrt(2) * pc.md^(3/2) * pc.kb * cc.envTemp * D^2 / (pi * pc.hbar^4 * u^2 * pc.rho) * energy^(1/2);
                % 谷间散射(非弹性近似)
                obj.interscatab = @(energy, DK, Zf, wi) DK^2 * pc.md^(3/2) * Zf / (sqrt(2) * pi * pc.rho * pc.hbar^3 * wi)...
                                                                    * (1 / (exp(pc.hbar * wi / (pc.kb * cc.envTemp)) - 1)) * real(sqrt(energy + pc.hbar * wi));
                obj.interscatem = @(energy, DK, Zf, wi) DK^2 * pc.md^(3/2) * Zf / (sqrt(2) * pi * pc.rho * pc.hbar^3 * wi)...
                                                                    * (1 + 1 / (exp(pc.hbar * wi / (pc.kb * cc.envTemp)) - 1)) * real(sqrt(energy - pc.hbar * wi));
            else
                disp("请使用材料：Si 的ScatterringRateTable类!")
            end
            
        end
        
        function scatType = get.scatType(obj)
            %自动计算散射类型
            
            r = rand * obj.scatTableAll(end);
            scatType = find(obj.scatTableAll > r, 1);
            
        end
        
        function flyTime = get.flyTime(obj)
            %自动计算飞行时间
            
            flyTime = -log(Random(0.2,1)) / obj.scatTableAll(end);
            
        end
        
        function obj = ScatterringTable(obj, es, sc, pc, cc)
            % 散射表
            
            % type = 1---------------e-impurity
            % type = 2---------------intra_LA
            % type = 3---------------intra_TA
            % type = 4---------------inter_g_ab_TA
            % type = 5---------------inter_g_ab_LA
            % type = 6---------------inter_g_ab_LO
            % type = 7---------------inter_f_ab_TA
            % type = 8---------------inter_f_ab_LA
            % type = 9---------------inter_f_ab_TO
            % type = 10--------------inter_g_em_TA
            % type = 11--------------inter_g_em_LA
            % type = 12--------------inter_g_em_LO
            % type = 13--------------inter_f_em_TA
            % type = 14--------------inter_f_em_LA
            % type = 15--------------inter_f_em_TO
            
            obj.scatTable = zeros(cc.nofScat, 1);
            obj.scatTable(1)  = obj.impuscat(es.energy, cc.dopDensity);
            obj.scatTable(2)  = obj.intrascat(es.energy, pc.DLA, pc.ul);
            obj.scatTable(3)  = obj.intrascat(es.energy, pc.DTA, pc.ut);
            obj.scatTable(4)  = obj.interscatab(es.energy, pc.gDKTA, 1, sc.wgTA);
            obj.scatTable(5)  = obj.interscatab(es.energy, pc.gDKLA, 1, sc.wgLA);
            obj.scatTable(6)  = obj.interscatab(es.energy, pc.gDKLO, 1, sc.wgLO);
            obj.scatTable(7)  = obj.interscatab(es.energy, pc.fDKTA, 4, sc.wfTA);
            obj.scatTable(8)  = obj.interscatab(es.energy, pc.fDKLA, 4, sc.wfLA);
            obj.scatTable(9)  = obj.interscatab(es.energy, pc.fDKTO, 4, sc.wfTO);
            obj.scatTable(10)= obj.interscatem(es.energy, pc.gDKTA, 1, sc.wgTA);
            obj.scatTable(11)= obj.interscatem(es.energy, pc.gDKLA, 1, sc.wgLA);
            obj.scatTable(12)= obj.interscatem(es.energy, pc.gDKLO, 1, sc.wgLO);
            obj.scatTable(13)= obj.interscatem(es.energy, pc.fDKTA, 4, sc.wfTA);
            obj.scatTable(14)= obj.interscatem(es.energy, pc.fDKLA, 4, sc.wfLA);
            obj.scatTable(15)= obj.interscatem(es.energy, pc.fDKTO, 4, sc.wfTO);
            %累积求和
            obj.scatTableAll = cumsum(obj.scatTable);
        end
        
        function ScatterringRatePlot(obj, sc, pc, cc)
            % 散射率画图
            
            energys = logspace(-3,1,100) * pc.e;
            scatTables = zeros(length(energys), cc.nofScat + 1);
            for i = 1 : length(energys)
                es = ElectricStatus;
                es.energy = energys(i);
                obj.ScatterringTable(es, sc, pc, cc);
                scatTables(i, 1 : end-1) = deal(obj.scatTable');
                scatTables(i, end) = sum(scatTables(i, 1 : end-1));
            end
            figure
            for j = 1 : cc.nofScat + 1
                slg = loglog(energys / pc.e * 1000, scatTables(:, j));
                slg.LineWidth = 3;
                hold on
            end
            legend("e-impurity","intra LA","intra TA","inter g ab TA","inter g ab LA",...
                      "inter g ab LO","inter f ab TA","inter f ab LA","inter f ab TO",...
                      "inter g em TA","inter g em LA","inter g em LO","inter f em TA",...
                      "inter f em LA","inter f em TO","total")
            xlabel('meV');
            ylabel('s^{-1}')

        end

        
        
    end
end