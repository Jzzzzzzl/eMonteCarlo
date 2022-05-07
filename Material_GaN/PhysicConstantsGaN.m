classdef PhysicConstantsGaN < PhysicConstants
    %% 物理常量类
    properties
        gammaG                 %Gruneisen非谐参数
        C44
        miu                        %剪切模量
        thetaD                    %德拜温度
        omegaD                  %德拜频率
        V0                          %单原子体积
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
        function obj = PhysicConstantsGaN
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
            obj.p = 0.375;
            obj.epsilonL = 8.9;
            obj.epsilonH = 5.35;
            obj.dGM = sqrt(sum(obj.hsp.M.^2));
            obj.dBD = obj.dGM;
            obj.dGL = sqrt(sum(obj.hsp.L.^2));
            obj.dGK = sqrt(sum(obj.hsp.K.^2));
            obj.dGA = sqrt(sum(obj.hsp.A.^2));
            obj.dKN = 2*pi/obj.a;
            
            obj.gammaG = 0.73;
            obj.C44 = 75e9;
            obj.miu = obj.C44;
            obj.thetaD = 643;
            obj.omegaD = obj.thetaD*obj.kb/obj.hbar;
            obj.V0 = sqrt(3)*obj.c^3/8;
            
            %>>>>>>>>U能谷参数
            obj.EgU = 2.0*obj.e;
            obj.mtU = 0.4*obj.m;
            obj.mlU = 0.4*obj.m;
            obj.alphaU = 0.17;
            obj.nofScatU = 12;
            obj.centerRatioU = sqrt(sum(obj.hsp.U.^2))/obj.dGM;
            obj.maxScatRateU = [99*obj.e 3.0e14];
            obj.xsForimpurityU = 0.1;
            obj.xsForPolarOpticalU = 0.1;
            obj.UD = 8.3*obj.e;
            obj.U2UDK = 10e10*obj.e;
            obj.U2G1DK = 10e10*obj.e;
            obj.U2G3DK = 20e10*obj.e;%这个对G3占比影响很大
            
            %>>>>>>>G1能谷参数
            obj.EgG1 = 0.0*obj.e;
            obj.mtG1 = 0.2*obj.m;
            obj.mlG1 = 0.2*obj.m;
            obj.alphaG1 = 0.03;
            obj.nofScatG1 = 10;
            obj.centerRatioG1 = 0;
            obj.maxScatRateG1 = [99*obj.e 5e14];
            obj.xsForimpurityG1 = 0.5;
            obj.xsForPolarOpticalG1 = 0.05;%0.03
            obj.G1D = 8.3*obj.e;
            obj.G12UDK = 10e10*obj.e;
            obj.G12G3DK = 10e10*obj.e;
            
            %>>>>>>>>G3能谷参数
            obj.EgG3 = 2.1*obj.e;
            obj.mtG3 = 0.4*obj.m;
            obj.mlG3 = 0.4*obj.m;
            obj.alphaG3 = 0.001;
            obj.nofScatG3 = 10;
            obj.centerRatioG3 = 0;
            obj.maxScatRateG3 = [99*obj.e 1.5e14];
            obj.xsForimpurityG3 = 0.1;
            obj.xsForPolarOpticalG3 = 0.07; 
            obj.G3D = 8.3*obj.e;
            obj.G32UDK = 10e10*obj.e;
            obj.G32G1DK = 5e10*obj.e;
        end
        
    end
end
