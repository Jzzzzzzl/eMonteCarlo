classdef ScatterringRateTableForValley < BandStructureForValley
    %% 本文件提供能谷散射表父类
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
        %>最大散射率索引表
        maxScatRate
        %>电离杂质散射修正系数
        xsForimpurity
        %>极化光学散射修正系数
        xsForPolarOptical
        %>飞行时间
        flyTime
        %>散射率表
        scatTable
        %>散射角表
        scatAngle
        %>散射率累加表
        scatTableAll
        %>散射率插值表
        interScatable
        %>散射角插值表
        interScatangle
        %>散射表能量索引
        energyFace
    end
    
    properties
        %>各种散射率句柄函数
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
        rejectScatteringType(obj, cc, es)
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
            elseif index == 1
                index = 2;
            end
            r = rand * obj.interScatable(obj.nofScat, index);
            es.scatype = find(obj.interScatable(:, index) > r, 1);
            es.theta = obj.interScatangle(es.scatype, index);
            if isempty(es.scatype)
                error("散射类型为空！")
            end
        end
        function computeFlyTime(obj, es)
            %>计算飞行时间
            index = find(obj.maxScatRate(:, 1) >= es.energy, 1);
            obj.flyTime = -log(randNumber(0.1, 0.9)) / obj.maxScatRate(index, 2);
        end
        
    end
end