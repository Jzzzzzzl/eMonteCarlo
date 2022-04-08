classdef ScatterringProcessForValley < ScatterringRateTableForValley
    %% 本文件提供能谷散射过程父类
    % ======================================================================
    %>     属性说明：
    %> （1）qAB：谷内吸收类型声子波数
    %> （2）qEM：谷内发射类型声子波数
    % ======================================================================
    %>     函数说明：
    %> （1）[es, ps] = chooseElectricFinalStateAfterScattering(~, es, ps, dv, sc, pc, frequency, flag)
    %>         该函数用于选择散射后电子和声子状态，随机选择电子散射后波矢，使得散射前后电子
    %>         波矢差（即声子波矢）大小所对应的声子能量与“给定值”误差不超过一定限度；
    %> （2）[es] = chooseFinalVectorOfImpurityScattering(~, es, dv, pc)
    %>         该函数用于选择电离杂质散射后电子状态，由于其不改变电子能量大小，只改变电子群
    %>         速度方向，因此需要同时考虑随机选择电子状态后电子波矢所对应群速度的方向及电子
    %>         群速度大小是否满足误差要求；
    %> （3）chooseIntravalleyScatteringPhononWavenum(obj, dv, pc, cc)
    %>         该函数用于计算谷内散射声子波矢大小；
    %>         
    % ======================================================================
    properties
        
    end
end