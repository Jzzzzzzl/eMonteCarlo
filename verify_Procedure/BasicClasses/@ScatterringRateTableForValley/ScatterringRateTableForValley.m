classdef ScatterringRateTableForValley < handle
    %% 本文件提供能谷散射表父类
    % ======================================================================
    %>     属性说明：
    %>
    % ======================================================================
    %>     函数说明：
    %> （1）
    %>         
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
        md
        nofScat
        maxScatRate
        xsForimpurity
        scatTable
        scatTableAll
        scatType
        flyTime
    end
    
    methods
        function updateScatterringRateFormula(obj, es, dv, pc, cc)
            %更新散射率句柄函数
            obj.ionizedImpurityScatteringRate(pc, cc);
            obj.intravalleyAcousticScatteringRate(es, dv, pc, cc);
            obj.intravalleyOpticalScatteringRate(es, dv, pc, cc);
            obj.interScatteringRate(es, dv, pc, cc);
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