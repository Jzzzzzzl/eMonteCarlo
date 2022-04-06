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
        b
        c
        kn
        hsp                        %倒空间笛卡尔坐标点
        rho                         %密度
        ul                          %纵向声速
        ut                          %横向声速
        u                           %平均声速
        p                           %压电常数
        epsilonL                   %低/高频相对介电常量
        epsilonH
        dGM                        %Gamma到M距离，k空间距离基准
        dBD
        dGL
        dKN
        qU2U                         %谷间散射平均声子波矢大小
        qU2G
        qG2G
        maxFrequency
    end
    
    properties
        %>U能谷参数
        EgU                       %U能谷带差，以G1能谷为基准点
        mtU                      %有效质量分量
        mlU
        alphaU
        nofScatU
        centerRatioU
        maxScatRateU
        xsForimpurityU
        xsForPolarOpticalU
        UD
        U2UDK
        U2G1DK
        U2G3DK
        %>G1能谷参数
        EgG1
        mtG1
        mlG1
        alphaG1
        nofScatG1
        centerRatioG1
        maxScatRateG1
        xsForimpurityG1
        xsForPolarOpticalG1
        G1D
        G12UDK
        G12G3DK
        %>G3能谷参数
        EgG3
        mtG3
        mlG3
        alphaG3
        nofScatG3
        centerRatioG3
        maxScatRateG3
        xsForimpurityG3
        xsForPolarOpticalG3
        G3D
        G32UDK
        G32G1DK
    end
    
    methods
        function obj = PhysicConstants
            %>构造函数
            obj.a = 3.216e-10;
            obj.b = 3.216e-10;
            obj.c = 5.240e-10;
            obj.kn.b1 = [1.9915343026	1.1498128657	0.0000000000] * 1e10;
            obj.kn.b2 = [0.0000000000	2.2996257314	0.0000000000] * 1e10;
            obj.kn.b3 = [0.0000000000	0.0000000000	1.2213325813] * 1e10;
            obj.hsp.G = [0.0000000000	0.0000000000	0.0000000000] * 1e10;
            obj.hsp.M = [0.9957671513	0.5749064329	0.0000000000] * 1e10;
            obj.hsp.L = [0.9957671513	0.5749064329	0.6106662907] * 1e10;
            obj.hsp.A = [0.0000000000	0.0000000000	0.6106662907] * 1e10;
            obj.hsp.K = [0.6638447675	1.1498128657	0.0000000000] * 1e10;
            obj.hsp.U = obj.hsp.M + 2/3*obj.hsp.A;
            obj.rho = 5920;
            obj.ul = 6.6e3;
            obj.ut = 2.7e3;
            obj.u = (2*obj.ut + obj.ul)/3;
            obj.p = 0.7;
            obj.epsilonL = 8.9;
            obj.epsilonH = 5.35;
            obj.dGM = sqrt(sum(obj.hsp.M.^2));
            obj.dBD = obj.dGM;
            obj.dGL = sqrt(sum(obj.hsp.L.^2));
            obj.dKN = 2*pi/obj.a;
            obj.qU2U = obj.dKN - (3+sqrt(3))/3*obj.dGM;
            obj.qU2G = 1.05*obj.dBD;
            obj.qG2G = 1.05*obj.dBD;
            obj.maxFrequency = 5e14;
            %>U能谷参数
            obj.EgU = 2.2*obj.e;
            obj.mtU = 0.335*obj.m;
            obj.mlU = 1.704*obj.m;
            obj.alphaU = 0.5;
            obj.nofScatU = 18;
            obj.centerRatioU = sqrt(sum(obj.hsp.U.^2))/obj.dGM;
            obj.maxScatRateU = 3e15;
            obj.xsForimpurityU = 0.1;
            obj.xsForPolarOpticalU = 0.04;
            obj.UD = 8.3*obj.e;
            obj.U2UDK = 1e10*obj.e;
            obj.U2G1DK = 1e10*obj.e;
            obj.U2G3DK = 2e10*obj.e;
            %>G1能谷参数
            obj.EgG1 = 0.0*obj.e;
            obj.mtG1 = 0.197*obj.m;
            obj.mlG1 = 0.197*obj.m;
            obj.alphaG1 = 0.37;
            obj.nofScatG1 = 14;
            obj.centerRatioG1 = 0;
            obj.maxScatRateG1 = 3e15;
            obj.xsForimpurityG1 = 0.1;
            obj.xsForPolarOpticalG1 = 0.04;
            obj.G1D = 2*obj.e;
            obj.G12UDK = 2e10*obj.e;
            obj.G12G3DK = 1e10*obj.e;
            %>G3能谷参数
            obj.EgG3 = 2.4*obj.e;
            obj.mtG3 = 2.412*obj.m;
            obj.mlG3 = 0.277*obj.m;
            obj.alphaG3 = 0.22;
            obj.nofScatG3 = 14;
            obj.centerRatioG3 = 0;
            obj.maxScatRateG3 = 3e15;
            obj.xsForimpurityG3 = 0.1;
            obj.xsForPolarOpticalG3 = 0.04; 
            obj.G3D = 8.3*obj.e;
            obj.G32UDK = 2e10*obj.e;
            obj.G32G1DK = 0.3e10*obj.e;
        end
        
    end
end
