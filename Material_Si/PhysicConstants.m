classdef PhysicConstants < handle
    %% 物理常量类
    properties(Constant)
        e = 1.602176634e-19;
        m = 9.10956e-31;
        kb = 1.380649e-23;
        h = 6.6260755e-34;
        hbar = 1.05457266e-34;
        epsilon0 = 8.854187817e-12;
    end
    
    properties
        %>材料一般性参数
        a                           %晶格常数
        c
        kn
        hsp                        %倒空间笛卡尔坐标点
        rho                         %密度
        ul                          %纵向声速
        ut                          %横向声速
        u                           %平均声速
        p                           %压电常数
        epsilonL                   %相对介电常量
        epsilonH
        dGX                         %Gamma到X距离，k空间距离基准
        dBD
        dGL
        dKN
        qf                          %f型谷间散射平均声子波矢大小
        qg                          %g型谷间散射平均声子波矢大小
        gammaG                 %Gruneisen非谐参数
        C44
        miu                        %剪切模量
        thetaD                    %德拜温度
        omegaD                  %德拜频率
        V0                          %单原子体积
    end
    
    properties
        %>GammaX能谷参数
        EgGX                       %GammaX能谷带差，以第一导带极小值为基准点
        mtGX                      %有效质量分量
        mlGX
        alphaGX
        nofScatGX
        centerRatioGX
        maxScatRateGX
        xsForimpurityGX
        DLA                         %各向同性平均形变势
        DTA
        gDKLA                       %耦合常数
        gDKTA
        gDKLO
        fDKLA
        fDKTA
        fDKTO
    end
    
    methods
        function obj = PhysicConstants
            %>构造函数
            obj.a = 5.431e-10;
            obj.c = 3.867e-10;
            obj.kn.b1 = [-1.1629067753	1.1629067753	1.1629067753] * 1e10;
            obj.kn.b2 = [1.1629067753	-1.1629067753	1.1629067753] * 1e10;
            obj.kn.b3 = [1.1629067753	1.1629067753	-1.1629067753] * 1e10;
            obj.hsp.G = [0.0000000000	0.0000000000	0.0000000000] * 1e10;
            obj.hsp.X = [0.0000000000	1.1629067753	0.0000000000] * 1e10;
            obj.hsp.L = [0.5814533877	0.5814533877	0.5814533877] * 1e10;
            obj.rho = 2330;
            obj.ul = 9.2e3;
            obj.ut = 4.7e3;
            obj.u = (2*obj.ut + obj.ul)/3;
            obj.p = 0.7;
            obj.epsilonL = 11.9;
            obj.epsilonH = 0;
            obj.dGX = sqrt(sum(obj.hsp.X.^2));
            obj.dBD = obj.dGX;
            obj.dGL = sqrt(sum(obj.hsp.L.^2));
            obj.dKN = 2*pi/obj.a;
            obj.qf = 0.95*obj.dBD;
            obj.qg = 0.3*obj.dBD;
            obj.gammaG = 0.73;
            obj.C44 = 75e9;
            obj.miu = obj.C44;
            obj.thetaD = 643;
            obj.omegaD = obj.thetaD*obj.kb/obj.hbar;
            obj.V0 = sqrt(3)*obj.c^3/8;
            %>GammaX能谷参数
            obj.EgGX = 0*obj.e;
            obj.mtGX = 0.196*obj.m;
            obj.mlGX = 0.916*obj.m;
            obj.alphaGX = 0.5;
            obj.nofScatGX = 18;
            obj.centerRatioGX = 0.85;
            obj.maxScatRateGX = [1*obj.e 4.4e13; ...
                                          99*obj.e 3e14];
            obj.xsForimpurityGX = 0.1;
            obj.DLA = 6.39*obj.e;
            obj.DTA = 3.01*obj.e;
            obj.gDKLA = 0.8e10*obj.e;
            obj.gDKTA = 0.5e10*obj.e;
            obj.gDKLO = 11e10*obj.e;
            obj.fDKLA = 2e10*obj.e;
            obj.fDKTA = 0.3e10*obj.e;
            obj.fDKTO = 2e10*obj.e;
        end
        
    end
end
