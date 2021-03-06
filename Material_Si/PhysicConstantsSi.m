classdef PhysicConstantsSi < PhysicConstants
    %% 物理常量类
    properties
        %>谷内声学散射平均声子波矢大小
        qa
        %>f型谷间散射平均声子波矢大小
        qf
        %>g型谷间散射平均声子波矢大小
        qg
    end
    
    properties
        %>>>>>>>>>>>>GammaX能谷参数<<<<<<<<<<<<<
        %>GammaX能谷带差，以第一导带极小值为基准点
        EgGX
        %>有效质量分量
        mtGX
        mlGX
        %>非抛物线性参数
        alphaGX
        %>GX能谷散射类型数量
        nofScatGX
        %>距Gamma点距离比率
        centerRatioGX
        %>GX能谷最大散射率
        maxScatRateGX
        %>GX能谷电离杂质散射修正系数
        xsForimpurityGX
        %>各向同性平均形变势
        DLA
        DTA
        %>耦合常数
        gDKLA
        gDKTA
        gDKLO
        gDKTO
        fDKLA
        fDKTA
        fDKLO
        fDKTO
    end
    
    methods
        function obj = PhysicConstantsSi
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
            obj.ul = 8.6e3;
            obj.ut = 4.7e3;
            obj.u = (2*obj.ut + obj.ul)/3;
            obj.epsilonL = 13;
            obj.epsilonH = [];
            obj.maxVelocity = 3e5;
            obj.maxFrequency = 10e13;
            obj.maxEnergy = 10*obj.e;
            obj.dGX = sqrt(sum(obj.hsp.X.^2));
            obj.dBD = obj.dGX;
            obj.dGL = sqrt(sum(obj.hsp.L.^2));
            obj.dKN = 2*pi/obj.a;
            obj.qa = 0.1*obj.dBD;
            obj.qf = 0.95*obj.dBD;
            obj.qg = 0.3*obj.dBD;
            obj.gammaG = 0.73;
            obj.C44 = 75e9;
            obj.miu = 75e9;
            obj.thetaD = 643;
            obj.omegaD = obj.thetaD*obj.kb/obj.hbar;
            obj.V0 = sqrt(3)*obj.c^3/8;
            obj.k = 148;
            %>GammaX能谷参数
            obj.EgGX = 0*obj.e;
            obj.mtGX = 0.196*obj.m;
            obj.mlGX = 0.916*obj.m;
            obj.alphaGX = 0.5;
            obj.nofScatGX = 18;
            obj.centerRatioGX = 0.85;
            obj.maxScatRateGX = [0.09*obj.e 2.5e13
                                          0.22*obj.e 4.2e13
                                          0.40*obj.e 6.2e13
                                          0.60*obj.e 8.4e13
                                          0.80*obj.e 1.1e14
                                          1.00*obj.e 1.4e14
                                          1.40*obj.e 2.0e14 
                                          2.00*obj.e 3.2e14
                                          3.00*obj.e 5.5e14
                                          4.50*obj.e 1.0e15
                                          99.0*obj.e 2.0e15];
            obj.xsForimpurityGX = 0.2;
            obj.DLA = 6.39*obj.e;
            obj.DTA = 3.01*obj.e;
            obj.gDKLA = 1.5e10*obj.e;
            obj.gDKTA = 0.3e10*obj.e;
            obj.gDKLO = 10.0e10*obj.e;
            obj.fDKLA = 3.5e10*obj.e;
            obj.fDKTA = 0.5e10*obj.e;
            obj.fDKLO = 3.5e10*obj.e;
            obj.fDKTO = 1.5e10*obj.e;
        end
        
    end
end
