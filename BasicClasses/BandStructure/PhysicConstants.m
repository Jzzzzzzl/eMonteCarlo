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
        %>>>>>>>>>>>>>>材料一般性参数<<<<<<<<<<<<%
        %>晶格常数
        a
        b
        c
        %>倒空间笛卡尔坐标下倒格子基矢坐标结构体
        kn
        %>倒空间笛卡尔坐标下高对称点坐标结构体
        hsp
        %>密度
        rho
        %>声速
        ul
        ut
        u
        %>压电常数
        p
        %>相对介电常量
        epsilonL
        epsilonH
        %>最大热运动速度
        maxVelocity
        %>最大频率上限
        maxFrequency
        %>k空间距离
        dBD
        dGA
        dGM
        dGX
        dGL
        dGK
        %>2pi/a
        dKN
        %>Gruneisen非简谐参数
        gammaG
        %>弹性模量
        C44
        %>剪切模量
        miu
        %>德拜温度
        thetaD
        %>德拜频率
        omegaD
        %>单原子体积
        V0
        %>热导率常量
        k
    end

end
