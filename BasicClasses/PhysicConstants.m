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
        kn                          %倒空间笛卡尔坐标下倒格子基矢坐标
        hsp                        %倒空间笛卡尔坐标下高对称点坐标
        rho                         %密度
        ul                          %纵向声速
        ut                          %横向声速
        u                           %平均声速
        p                           %压电常数
        epsilonL                   %低频相对介电常量
        epsilonH                  %高频相对介电常量
        dBD                        %k空间距离基准
        dGA
        dGM
        dGX
        dGL
        dGK
        dKN                       %2pi / a
    end

end
