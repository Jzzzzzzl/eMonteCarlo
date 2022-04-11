classdef ScatterringRateTableForValley < BandStructureForValley
    %% 本文件提供能谷散射表父类
    % ======================================================================
    %>     属性说明：
    %>     xAB/xEM：用于计算随机生成的谷内声子波数
    %>     nofScat：散射类型数量
    %>     maxScatRate：最大散射率，用于计算飞行时间
    %>     xsForimpurity：电离杂质散射修正系数
    % ======================================================================
    %>     函数说明：
    %> （1）updateScatterringRateFormula(obj, dv, pc, cc)
    %>         该函数用于更新某一电子状态下对应的散射类型的句柄函数，需要注意的是，在使用该
    %>         函数之前，需要先将dv指向该电子所在能谷种类，然后计算dv.bs.epsilong参数，默认
    %>         情况下，飞行过程结束后的dv即满足要求，否则需要额外计算。
    %> （2）generateIntervalleyScatteringRate(obj, dv, pc, cc)
    %>         该函数用于更新计算谷间散射率的句柄函数
    %> （3）generateIntravalleyAcousticScatteringRate(obj, dv, pc, cc)
    %>         该函数用于更新计算声学谷内散射率的句柄函数
    %> （4）generateIntravalleyOpticalScatteringRate(obj, dv, pc, cc)
    %>         该函数用于更新计算光学谷内散射率的句柄函数
    %> （5）generateIonizedImpurityScatteringRate(obj, dv, pc, cc)
    %>         该函数用于更新计算电离杂质散射率的句柄函数
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
    end
    
    properties
        flyTime
        scatType
        scatTable
        scatTableAll
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
            obj.flyTime = -log(randNumber(0.01,0.9)) / obj.maxScatRate(index, 2);
        end
    end
end