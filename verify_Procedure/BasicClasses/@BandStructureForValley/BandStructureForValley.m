classdef BandStructureForValley < handle
    %% 本文件提供能谷能带结构相关计算的父类
    % ======================================================================
    %>     属性说明：
    %>     Eg   ：能带带隙，以第一导带极小值为基准点
    %>     mt   ：横向有效质量
    %>     ml   ：纵向有效质量
    %>     md  ：态密度有效质量
    %>     alpha：能谷非抛物性参数
    %>     Tz   ：z轴Herring-Vogt变换矩阵
    %>     invTz：Tz逆矩阵
    %>     centerRatio：能谷中心所在位置比例
    %>
    % ======================================================================
    %>     函数说明：
    %> （1）[energy, velocity] = computeEnergyVelocityForStandardVector(obj, k, pc)：
    %>         该函数用于计算能谷主轴位于z轴（标准能谷）的电子波矢所对应的能量及群速度，
    %>         所得结果是针对标准能谷而言的，因此计算完成后需要根据不同能谷对群速度进行
    %>         旋转操作，而能量则可以直接使用；
    %> （2）[k] = generateStandardWaveVector(obj, es, pc)：
    %>         该函数用于生成位于原点的椭球能谷的电子波矢，需要根据不同能谷进行平移及
    %>         旋转操作（至于波矢位于第一布里渊区的条件暂时可以忽略）；
    %>
    % ======================================================================
    properties
        Eg
        mt
        ml
        alpha
        centerRatio
        md
        Tz
        invTz
        epsilon
    end
end
