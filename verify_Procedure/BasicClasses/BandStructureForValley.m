classdef BandStructureForValley < handle
    %% 本文件提供能谷能带结构相关计算的父类
    % ======================================================================
    %>     属性说明：
    %>     Eg   ：能带带隙
    %>     mt   ：横向有效质量
    %>     ml   ：纵向有效质量
    %>     alpha：能谷非抛物性参数
    %>     Tz   ：z轴Herring-Vogt变换矩阵
    %>     invTz：Tz逆矩阵
    %>     centerRatio：能谷中心所在位置比例
    %>
    % ======================================================================
    %>     函数说明：
    %> （1）computeEnergyVelocityForStandardVector(k, pc)：
    %>         该函数用于计算能谷主轴位于z轴（标准能谷）的电子波矢所对应的能量及群速度，
    %>         所得结果是针对标准能谷而言的，因此计算完成后需要根据不同能谷对群速度进行
    %>         旋转操作，而能量则可以直接使用；
    %> （2）generateStandardWaveVector(obj, es, pc)：
    %>         该函数用于生成位于原点的椭球能谷的电子波矢，需要根据不同能谷进行平移及
    %>         旋转操作，同时要满足波矢位于第一布里渊区的条件；
    %>
    % ======================================================================
    properties
        Eg
        mt
        ml
        alpha
        Tz
        invTz
        centerRatio
    end
    
    methods
        function [energy, velocity] = computeEnergyVelocityForStandardVector(obj, k, pc)
            %>计算电子能量
            epsilong = pc.hbar^2*(k(1)^2 / obj.mt + k(2)^2 / obj.mt + k(3)^2 / obj.ml) / 2;
            energy = epsilong * (1 + epsilong/pc.e * obj.alpha);
            %>计算电子速度
            kStar = obj.Tz * k';
            vStar = pc.hbar * kStar / (pc.m * (1+2*obj.alpha*epsilong));
            velocity = (obj.invTz * vStar)';
        end
        
        function [k] = generateStandardWaveVector(obj, es, pc)
            %>根据能量选择电子波矢
            epsilong = (sqrt(1 + 4*obj.alpha*es.energy/pc.e) - 1) / (2*obj.alpha) * pc.e;
            kStarMold = sqrt(2 * pc.m * epsilong) / pc.hbar;
            %>球空间随机选择波矢
            phi = randnumber(0, pi);
            theta = randnumber(0, 2*pi);
            kxStar = kStarMold * sin(phi) * cos(theta);
            kyStar = kStarMold * sin(phi) * sin(theta);
            kzStar = kStarMold * cos(phi);
            kStar = [kxStar, kyStar, kzStar]';
            k = (obj.invTz * kStar)';
        end
        
    end
end
