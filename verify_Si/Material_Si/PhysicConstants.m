classdef PhysicConstants < handle
    
    properties(Constant)
        e = 1.602176634e-19;
        m = 9.10956e-31;
        kb = 1.380649e-23;
        h = 6.6260755e-34;
        hbar = 1.05457266e-34;
        epsilon0 = 8.854187817e-12;
    end
    
    properties
        a                           %晶格常数
        c
        mt                          %有效质量分量
        ml
        mc                          %导带有效质量
        md                          %态密度有效质量
        rho                         %密度
        ul                          %纵向声速
        ut                          %横向声速
        % 电离杂质散射所需参数
        epsilonSi
        % 电子谷间散射所需参数
        gDKTA                       %耦合常数
        gDKLA
        gDKLO
        fDKTA
        fDKLA
        fDKTO
        dGX                         %Gamma到X距离
        bzR                         %第一布里渊区等效半径
        qf                          %f型谷间散射平均声子波矢大小
        qg                          %g型谷间散射平均声子波矢大小
        % 电子谷内散射所需参数
        DLA                         %各向同性平均形变势
        DTA
        qintra                      %谷内散射平均声子波矢大小
    end
    
    methods
        
        function obj = PhysicConstants(Material)
            if strcmpi(Material, "Si")
                obj.a = 5.431e-10;
                obj.c = 3.867e-10;
                obj.mt = 0.196*obj.m;
                obj.ml = 0.916*obj.m;
                obj.mc = ((1/obj.ml)/3 + 2*(1/obj.mt)/3)^(-1);
                obj.md = (obj.mt^2*obj.ml)^(1/3);
                obj.rho = 2330;
                obj.ul = 9.2e3;
                obj.ut = 4.7e3;
                % 电离杂质散射所需参数
                obj.epsilonSi = 11.9;
                % 电子谷间散射所需参数
                obj.gDKTA = 0.5e10*obj.e;
                obj.gDKLA = 0.8e10*obj.e;
                obj.gDKLO = 11e10*obj.e;
                obj.fDKTA = 0.3e10*obj.e;
                obj.fDKLA = 2e10*obj.e;
                obj.fDKTO = 2e10*obj.e;
                obj.dGX = 2*pi/obj.a;
                obj.bzR = (5/pi)^(1/3)*obj.dGX;
                obj.qf = 0.95*obj.dGX;
                obj.qg = 0.3*obj.dGX;
                % 电子谷内散射所需参数
                obj.DLA = 6.39*obj.e;
                obj.DTA = 3.01*obj.e;
                obj.qintra = 0.15*obj.dGX;
            else
                error("请使用材料：Si 的PhysicConstants类!")
            end
        end
        
    end
end
