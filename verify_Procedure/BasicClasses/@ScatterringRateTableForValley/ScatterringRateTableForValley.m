classdef ScatterringRateTableForValley < handle
    %% 本文件提供能谷散射表父类
    % ======================================================================
    %>     属性说明：
    %>
    % ======================================================================
    %>     函数说明：
    %> （1）updateScatterringRateFormula(obj, dv, pc, cc)
    %>         该函数用于更新某一电子状态下对应的散射类型的句柄函数，需要注意的是，在使用该
    %>         函数之前，需要先将dv指向该电子所在能谷种类，然后计算dv.bs.epsilong参数，默认
    %>         情况下，飞行过程结束后的dv即满足要求，否则需要额外计算。
    %> （2）
    %>         
    %>
    % ======================================================================
    properties
        ionizedImpurityScatRate
        intraAcousticScatRateAB
        intraAcousticScatRateEM
        intraOpticalScatRateAB
        intraOpticalScatRateEM
        interScatRateAB
        interScatRateEM
    end
    
    properties
        nofScat
        maxScatRate
        xsForimpurity
        scatTable
        scatTableAll
        scatType
        flyTime
        xAB
        xEM
    end
    
    methods
        function updateScatterringRateFormula(obj, dv, pc, cc)
            %更新散射率句柄函数
            obj.generateIonizedImpurityScatteringRate(dv, pc, cc);
            obj.generateIntravalleyAcousticScatteringRate(dv, pc, cc);
            obj.generateIntravalleyOpticalScatteringRate(dv, pc, cc);
            obj.generateIntervalleyScatteringRate(dv, pc, cc);
        end
        
        function computeScatType(obj)
            %计算散射类型
            r = rand * obj.scatTableAll(end);
            obj.scatType = find(obj.scatTableAll > r, 1);
        end
        
        function computeFlyTime(obj)
            %计算飞行时间
            obj.flyTime = -log(randNumber(0.01,1.0)) / obj.maxScatRate;
        end
        
    end
end