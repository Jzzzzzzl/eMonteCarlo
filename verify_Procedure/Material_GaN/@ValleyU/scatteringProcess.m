function [es, ps] = scatteringProcess(obj, dv, es, ps, sc, pc)
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
        case 6 % inter UU LA ab
            ps.aborem = "ab";
            ps.polar = "LA";
            es.valley = randomValley("interUU");
            k = obj.chooseStandardVectorForInelasticScattering(es, pc, 'inter', sc.wU2ULA, 1);
            es = obj.getGeneralElectricWaveVector(es, pc, k);
        case 7 % inter UU LO ab
            ps.aborem = "ab";
            ps.polar = "LO";
            es.valley = randomValley("interUU");
            k = obj.chooseStandardVectorForInelasticScattering(es, pc, 'inter', sc.wU2ULO, 1);
            es = obj.getGeneralElectricWaveVector(es, pc, k);
        case 8 % inter UU LA em
            ps.aborem = "em";
            ps.polar = "LA";
            es.valley = randomValley("interUU");
            k = obj.chooseStandardVectorForInelasticScattering(es, pc, 'inter', sc.wU2ULA, -1);
            es = obj.getGeneralElectricWaveVector(es, pc, k);
        case 9 % inter UU LO em
            ps.aborem = "em";
            ps.polar = "LO";
            es.valley = randomValley("interUU");
            k = obj.chooseStandardVectorForInelasticScattering(es, pc, 'inter', sc.wU2ULO, -1);
            es = obj.getGeneralElectricWaveVector(es, pc, k);
        case 10 % inter UG1 LA ab
            ps.aborem = "ab";
            ps.polar = "LA";
            es.valley = randomValley("interUG1");
            dv.valleyGuidingPrinciple(es);
            k = dv.valley.chooseStandardVectorForInelasticScattering(es, pc, 'inter', sc.wU2GLA, 1);
            es = dv.valley.getGeneralElectricWaveVector(es, pc, k);
        case 11 % inter UG1 LO ab
            ps.aborem = "ab";
            ps.polar = "LO";
            es.valley = randomValley("interUG1");
            dv.valleyGuidingPrinciple(es);
            k = dv.valley.chooseStandardVectorForInelasticScattering(es, pc, 'inter', sc.wU2GLO, 1);
            es = dv.valley.getGeneralElectricWaveVector(es, pc, k);
        case 12 % inter UG1 LA em
            ps.aborem = "em";
            ps.polar = "LA";
            es.valley = randomValley("interUG1");
            dv.valleyGuidingPrinciple(es);
            k = dv.valley.chooseStandardVectorForInelasticScattering(es, pc, 'inter', sc.wU2GLA, -1);
            es = dv.valley.getGeneralElectricWaveVector(es, pc, k);
        case 13 % inter UG1 LO em
            ps.aborem = "em";
            ps.polar = "LO";
            es.valley = randomValley("interUG1");
            dv.valleyGuidingPrinciple(es);
            k = dv.valley.chooseStandardVectorForInelasticScattering(es, pc, 'inter', sc.wU2GLO, -1);
            es = dv.valley.getGeneralElectricWaveVector(es, pc, k);
        case 14 % inter UG3 LA ab
            ps.aborem = "ab";
            ps.polar = "LA";
            es.valley = randomValley("interUG3");
            dv.valleyGuidingPrinciple(es);
            k = dv.valley.chooseStandardVectorForInelasticScattering(es, pc, 'inter', sc.wU2GLA, 1);
            es = dv.valley.getGeneralElectricWaveVector(es, pc, k);
        case 15 % inter UG3 LO ab
            ps.aborem = "ab";
            ps.polar = "LO";
            es.valley = randomValley("interUG3");
            dv.valleyGuidingPrinciple(es);
            k = dv.valley.chooseStandardVectorForInelasticScattering(es, pc, 'inter', sc.wU2GLO, 1);
            es = dv.valley.getGeneralElectricWaveVector(es, pc, k);
        case 16 % inter UG3 LA em
            ps.aborem = "em";
            ps.polar = "LA";
            es.valley = randomValley("interUG3");
            dv.valleyGuidingPrinciple(es);
            k = dv.valley.chooseStandardVectorForInelasticScattering(es, pc, 'inter', sc.wU2GLA, -1);
            es = dv.valley.getGeneralElectricWaveVector(es, pc, k);
        case 17 % inter UG3 LO em
            ps.aborem = "em";
            ps.polar = "LO";
            es.valley = randomValley("interUG3");
            dv.valleyGuidingPrinciple(es);
            k = dv.valley.chooseStandardVectorForInelasticScattering(es, pc, 'inter', sc.wU2GLO, -1);
            es = dv.valley.getGeneralElectricWaveVector(es, pc, k);
        case 18 % 
            return;
    end
    es = obj.modifyElectricWaveVector(es, pc);
    es = obj.computeEnergyAndGroupVelocity(es, pc);
    
    if ~isequal(ps.polar, "non")
        ps.vector = es.vector - vectorTemp;
        ps = dv.valley.phononWhetherBeyondBZ(ps, pc);
        ps.getFrequency(sc);
    end
    
    function value = randomValley(type)
            %>随机选择能谷
            switch type
                case "interUU"
                    valleys = [1, -1, 2, -2, 3, -3, 4, -4, 5, -5, 6, -6];
                    index = round(randNumber(0.5, 12.5));
                    value = valleys(index);
                case "interUG1"
                    value = 11;
                case "interUG3"
                    value = 13;
            end
        end
end