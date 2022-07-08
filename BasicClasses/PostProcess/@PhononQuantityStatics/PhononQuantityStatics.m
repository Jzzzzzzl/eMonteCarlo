classdef PhononQuantityStatics < handle
    %% 声子统计类
    properties
        %>五维数组：1d：x point
        %>               2d：y point
        %>               3d：frequency point
        %>               4d：polar type
        %>               5d：ab or em
        %>声子频率之和(em - ab)
        allSumF
        %>声子发射数统计
        allSumN
        %>最小统计时间
        minTime
        %>最大统计时间
        maxTime
        %>BTE源项
        nDot
        %>产热量
        Q
        %>远平衡分布函数
        n
        %>扩散温度
        TF
        %>等效温度
        Teff
        %>极化支等效温度
        pTeff
        %>极化类型结构体
        polar
    end
    
    methods
        function obj = PhononQuantityStatics(cc)
            %>构造函数
            obj.initializeVariables(cc);
        end
    end
    
    methods
        
    end
    
end