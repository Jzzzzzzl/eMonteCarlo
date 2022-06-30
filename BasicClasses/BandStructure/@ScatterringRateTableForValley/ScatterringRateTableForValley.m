classdef ScatterringRateTableForValley < BandStructureForValley
    %% 本文件提供能谷散射表父类
    % ======================================================================
    %>     属性说明：
    %>     qAB/qEM：根据谷内散射率生成的谷内声子波数
    %>     thetaII：电离杂质散射散射角
    %>     thetaAP：声学压电散射散射角
    %>     thetaPOab/thetaPOem：极性光学散射散射角
    %>     nofScat：散射类型数量
    %>     maxScatRate：最大散射率矩阵，用于计算飞行时间
    %>     xsForimpurity：电离杂质散射修正系数
    %>     xsForPolarOptical：极性光学散射修正系数
    %>     flyTime：计算得到的飞行时间
    %>     scatType：计算得到的散射类型
    %>     scatTable：散射表
    %>     scatTableAll：累积散射表
    % ======================================================================
    properties
        %>谷内散射声子波矢大小
        qAB
        qEM
        %>声学压电散射散射角
        thetaAPiezo
        %>谷内极化光学散射散射角
        thetaPOab
        thetaPOem
        %>电离杂质散射散射角
        thetaIImpu
        %>散射类型数量
        nofScat
        %>最大散射率
        maxScatRate
        %>电离杂质散射修正系数
        xsForimpurity
        %>极化光学散射修正系数
        xsForPolarOptical
        %>飞行时间
        flyTime
        %>散射类型
        scatType
        %>散射表
        scatTable
        %>散射率累加表
        scatTableAll
        %>散射率插值表
        interScatable
        %>散射表能量索引
        energyFace
    end
    
    properties
        %>各种散射率句柄函数
        ionizedImpurity
        acousticPiezoelectric
        elasticIntraAcoustics
        inelasticIntraAcousticAB
        inelasticIntraAcousticEM
        inelasticIntraOpticalAB
        inelasticIntraOpticalEM
        inelasticPolarOpticalAB
        inelasticPolarOpticalEM
        inelasticInterAB
        inelasticInterEM
    end
    
    methods
        rejectFlyTime(obj, cc, es)
        ionizedImpurityScatteringRate(obj, es, pc)
        inelasticIntervalleyScatteringRate(obj, es, pc)
        inelasticPolarOpticalScatteringRate(obj, es, pc)
        acousticPiezoelectricScatteringRate(obj, es, pc)
        elasticIntravalleyAcousticScatteringRate(obj, es, pc)
        inelasticIntravalleyOpticalScatteringRate(obj, es, pc)
        inelasticIntravalleyAcousticScatteringRate(obj, es, pc)
    end
    
    methods
        function computeScatType(obj, cc, es)
            %>计算散射类型
            index = find(obj.energyFace >= es.energy/cc.e, 1) - 1;
            if isempty(index)
                index = cc.NE + 1;
            elseif index == 0
                index = obj.nofScat;
            end
            r = rand * obj.interScatable(obj.nofScat, index);
            obj.scatType = find(obj.interScatable(:, index) > r, 1);
        end
        function computeFlyTime(obj, es)
            %>计算飞行时间
            index = find(es.energy <= obj.maxScatRate(:, 1), 1);
            obj.flyTime = -log(randNumber(0.3, 0.6)) / obj.maxScatRate(index, 2);
        end
        
    end
end