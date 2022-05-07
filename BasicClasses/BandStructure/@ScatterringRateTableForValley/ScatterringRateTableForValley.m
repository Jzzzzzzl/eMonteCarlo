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
        qAB
        qEM
        thetaII
        thetaAP
        thetaPOab
        thetaPOem
        nofScat
        maxScatRate
        xsForimpurity
        xsForPolarOptical
        flyTime
        scatType
        scatTable
        scatTableAll
    end
    
    properties
        ionizedImpurity
        acousticPiezoelectric
        elasticIntraAcoustic
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
        ionizedImpurityScatteringRate(obj, es, pc, cc)
        inelasticIntervalleyScatteringRate(obj, es, pc, cc)
        inelasticPolarOpticalScatteringRate(obj, es, pc, cc)
        acousticPiezoelectricScatteringRate(obj, es, pc, cc)
        elasticIntravalleyAcousticScatteringRate(obj, es, pc, cc)
        inelasticIntravalleyOpticalScatteringRate(obj, es, pc, cc)
        inelasticIntravalleyAcousticScatteringRate(obj, es, pc, cc)
    end
    
    methods
        function computeScatType(obj)
            %>计算散射类型
            r = rand * obj.scatTableAll(end);
            obj.scatType = find(obj.scatTableAll > r, 1);
        end
        function computeFlyTime(obj, es)
            %>计算飞行时间
            energys = obj.maxScatRate(:, 1);
            index = find(es.energy <= energys, 1);
            obj.flyTime = -log(randNumber(1e-5, 1.0)) / obj.maxScatRate(index, 2);
        end
    end
end