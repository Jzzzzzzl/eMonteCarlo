function [es,ps] = scatteringProcess(obj, dv, es, ps, sc, pc)
    %>针对不同散射类型计算电子声子散射过程
    ps.time = es.time;
    vectorTemp = es.vector;
    ps.position = es.position;
    switch es.scatype
        case 1 % ionized impurity
            k = obj.chooseStandardVectorForElasticScattering(es, pc, 'ii');
            es = obj.getGeneralElectricWaveVector(es, pc, k);
        case 2 % acoustic piezoelectric
            k = obj.chooseStandardVectorForElasticScattering(es, pc, 'ap');
            es = obj.getGeneralElectricWaveVector(es, pc, k);
        case 3 % intra
            k = obj.chooseStandardVectorForElasticScattering(es, pc, 'intra');
            es = obj.getGeneralElectricWaveVector(es, pc, k);
        case 4 % polar LO ab
            ps.aborem = "ab";
            ps.polar = "LO";
            k = obj.chooseStandardVectorForInelasticScattering(es, pc, 'po', sc.wPolarLO, 1);
            es = obj.getGeneralElectricWaveVector(es, pc, k);
        case 5 % polar LO em
            ps.aborem = "em";
            ps.polar = "LO";
            k = obj.chooseStandardVectorForInelasticScattering(es, pc, 'po', sc.wPolarLO, -1);
            es = obj.getGeneralElectricWaveVector(es, pc, k);
        case 6 % inter G3U LA ab
            ps.aborem = "ab";
            ps.polar = "LA";
            es.valley = randomValley(es, "interG3U");
            dv.valleyGuidingPrinciple(es);
            k = dv.valley.chooseStandardVectorForInelasticScattering(es, pc, 'inter', sc.wU2GLA, 1);
            es = dv.valley.getGeneralElectricWaveVector(es, pc, k);
        case 7 % inter G3U LO ab
            ps.aborem = "ab";
            ps.polar = "LO";
            es.valley = randomValley(es, "interG3U");
            dv.valleyGuidingPrinciple(es);
            k = dv.valley.chooseStandardVectorForInelasticScattering(es, pc, 'inter', sc.wU2GLO, 1);
            es = dv.valley.getGeneralElectricWaveVector(es, pc, k);
        case 8 % inter G3U LA em
            ps.aborem = "em";
            ps.polar = "LA";
            es.valley = randomValley(es, "interG3U");
            dv.valleyGuidingPrinciple(es);
            k = dv.valley.chooseStandardVectorForInelasticScattering(es, pc, 'inter', sc.wU2GLA, -1);
            es = dv.valley.getGeneralElectricWaveVector(es, pc, k);
        case 9 % inter G3U LO em
            ps.aborem = "em";
            ps.polar = "LO";
            es.valley = randomValley(es, "interG3U");
            dv.valleyGuidingPrinciple(es);
            k = dv.valley.chooseStandardVectorForInelasticScattering(es, pc, 'inter', sc.wU2GLO, -1);
            es = dv.valley.getGeneralElectricWaveVector(es, pc, k);
        case 10 % inter G3G1 LA ab
            ps.aborem = "ab";
            ps.polar = "LA";
            es.valley = randomValley(es, "interG3G1");
            dv.valleyGuidingPrinciple(es);
            k = dv.valley.chooseStandardVectorForInelasticScattering(es, pc, 'inter', sc.wG2GLA, 1);
            es = dv.valley.getGeneralElectricWaveVector(es, pc, k);
        case 11 % inter G3G1 LO ab
            ps.aborem = "ab";
            ps.polar = "LO";
            es.valley = randomValley(es, "interG3G1");
            dv.valleyGuidingPrinciple(es);
            k = dv.valley.chooseStandardVectorForInelasticScattering(es, pc, 'inter', sc.wG2GLO, 1);
            es = dv.valley.getGeneralElectricWaveVector(es, pc, k);
        case 12 % inter G3G1 LA em
            ps.aborem = "em";
            ps.polar = "LA";
            es.valley = randomValley(es, "interG3G1");
            dv.valleyGuidingPrinciple(es);
            k = dv.valley.chooseStandardVectorForInelasticScattering(es, pc, 'inter', sc.wG2GLA, -1);
            es = dv.valley.getGeneralElectricWaveVector(es, pc, k);
        case 13 % inter G3G1 LO em
            ps.aborem = "em";
            ps.polar = "LO";
            es.valley = randomValley(es, "interG3G1");
            dv.valleyGuidingPrinciple(es);
            k = dv.valley.chooseStandardVectorForInelasticScattering(es, pc, 'inter', sc.wG2GLO, -1);
            es = dv.valley.getGeneralElectricWaveVector(es, pc, k);
        case 14 % 
            return;
    end
    
    if ~isequal(ps.polar, "non")
        ps.vector = es.vector - vectorTemp;
        ps.getFrequency(sc);
    end
    
    function value = randomValley(~, type)
        %>随机选择能谷
        switch type
            case "interG3U"
                valleys = [1, -1, 2, -2, 3, -3, 4, -4, 5, -5, 6, -6];
                index = round(randNumber(0.5, 12.5));
                value = valleys(index);
            case "interG3G1"
                value = 11;
        end
    end
end