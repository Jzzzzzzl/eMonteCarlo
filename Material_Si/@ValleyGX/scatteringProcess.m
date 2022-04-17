function [es, ps] = scatteringProcess(obj, dv, es, ps, sc, pc)
    %>针对不同散射类型计算电子声子散射过程
    ps.time = es.time;
    vectorTemp = es.vector;
    ps.position = es.position;
    switch es.scatype
        case 1 % ionized-impurity
            k = obj.chooseStandardVectorForElasticScattering(es, pc, 'ii');
            es = obj.getGeneralElectricWaveVector(es, pc, k);
        case 2 % intra_ab_LA
            ps.aborem = "ab";
            ps.polar = "LA";
            k = obj.chooseStandardVectorForInelasticScattering(es, pc, 'intra', sc.omegaLA(obj.qAB), 1);
            es = obj.getGeneralElectricWaveVector(es, pc, k);
        case 3 % intra_ab_TA
            ps.aborem = "ab";
            ps.polar = "TA";
            k = obj.chooseStandardVectorForInelasticScattering(es, pc, 'intra', sc.omegaTA(obj.qAB), 1);
            es = obj.getGeneralElectricWaveVector(es, pc, k);
        case 4 % intra_em_LA
            ps.aborem = "em";
            ps.polar = "LA";
            while sc.omegaLA(obj.qEM)*pc.hbar >= es.energy; obj.qEM = obj.qEM * 0.8; end
            k = obj.chooseStandardVectorForInelasticScattering(es, pc, 'intra', sc.omegaLA(obj.qEM), -1);
            es = obj.getGeneralElectricWaveVector(es, pc, k);
        case 5 % intra_em_TA
            ps.aborem = "em";
            ps.polar = "TA";
            while sc.omegaTA(obj.qEM)*pc.hbar >= es.energy; obj.qEM = obj.qEM * 0.8; end
            k = obj.chooseStandardVectorForInelasticScattering(es, pc, 'intra', sc.omegaTA(obj.qEM), -1);
            es = obj.getGeneralElectricWaveVector(es, pc, k);
        case 6 % inter_g_ab_LA
            ps.aborem = "ab";
            ps.polar = "LA";
            es.valley = randomValley(es, "interg");
            dv.valleyGuidingPrinciple(es);
            k = dv.valley.chooseStandardVectorForInelasticScattering(es, pc, 'inter', sc.omegaLA(pc.qg), 1);
            es = dv.valley.getGeneralElectricWaveVector(es, pc, k);
        case 7 % inter_g_ab_TA
            ps.aborem = "ab";
            ps.polar = "TA";
            es.valley = randomValley(es, "interg");
            dv.valleyGuidingPrinciple(es);
            k = dv.valley.chooseStandardVectorForInelasticScattering(es, pc, 'inter', sc.omegaTA(pc.qg), 1);
            es = dv.valley.getGeneralElectricWaveVector(es, pc, k);
        case 8 % inter_g_ab_LO
            ps.aborem = "ab";
            ps.polar = "LO";
            es.valley = randomValley(es, "interg");
            dv.valleyGuidingPrinciple(es);
            k = dv.valley.chooseStandardVectorForInelasticScattering(es, pc, 'inter', sc.omegaLO(pc.qg), 1);
            es = dv.valley.getGeneralElectricWaveVector(es, pc, k);
        case 9 % inter_f_ab_LA
            ps.aborem = "ab";
            ps.polar = "LA";
            es.valley = randomValley(es, "interf");
            dv.valleyGuidingPrinciple(es);
            k = dv.valley.chooseStandardVectorForInelasticScattering(es, pc, 'inter', sc.omegaLA(pc.qf), 1);
            es = dv.valley.getGeneralElectricWaveVector(es, pc, k);
        case 10 % inter_f_ab_TA
            ps.aborem = "ab";
            ps.polar = "TA";
            es.valley = randomValley(es, "interf");
            dv.valleyGuidingPrinciple(es);
            k = dv.valley.chooseStandardVectorForInelasticScattering(es, pc, 'inter', sc.omegaTA(pc.qf), 1);
            es = dv.valley.getGeneralElectricWaveVector(es, pc, k);
        case 11 % inter_f_ab_TO
            ps.aborem = "ab";
            ps.polar = "TO";
            es.valley = randomValley(es, "interf");
            dv.valleyGuidingPrinciple(es);
            k = dv.valley.chooseStandardVectorForInelasticScattering(es, pc, 'inter', sc.omegaTO(pc.qf), 1);
            es = dv.valley.getGeneralElectricWaveVector(es, pc, k);
        case 12 % inter_g_em_LA
            ps.aborem = "em";
            ps.polar = "LA";
            es.valley = randomValley(es, "interg");
            dv.valleyGuidingPrinciple(es);
            k = dv.valley.chooseStandardVectorForInelasticScattering(es, pc, 'inter', sc.omegaLA(pc.qg), -1);
            es = dv.valley.getGeneralElectricWaveVector(es, pc, k);
        case 13 % inter_g_em_TA
            ps.aborem = "em";
            ps.polar = "TA";
            es.valley = randomValley(es, "interg");
            dv.valleyGuidingPrinciple(es);
            k = dv.valley.chooseStandardVectorForInelasticScattering(es, pc, 'inter', sc.omegaTA(pc.qg), -1);
            es = dv.valley.getGeneralElectricWaveVector(es, pc, k);
        case 14 % inter_g_em_LO
            ps.aborem = "em";
            ps.polar = "LO";
            es.valley = randomValley(es, "interg");
            dv.valleyGuidingPrinciple(es);
            k = dv.valley.chooseStandardVectorForInelasticScattering(es, pc, 'inter', sc.omegaLO(pc.qg), -1);
            es = dv.valley.getGeneralElectricWaveVector(es, pc, k);
        case 15 % inter_f_em_LA
            ps.aborem = "em";
            ps.polar = "LA";
            es.valley = randomValley(es, "interf");
            dv.valleyGuidingPrinciple(es);
            k = dv.valley.chooseStandardVectorForInelasticScattering(es, pc, 'inter', sc.omegaLA(pc.qf), -1);
            es = dv.valley.getGeneralElectricWaveVector(es, pc, k);
        case 16 % inter_f_em_TA
            ps.aborem = "em";
            ps.polar = "TA";
            es.valley = randomValley(es, "interf");
            dv.valleyGuidingPrinciple(es);
            k = dv.valley.chooseStandardVectorForInelasticScattering(es, pc, 'inter', sc.omegaTA(pc.qf), -1);
            es = dv.valley.getGeneralElectricWaveVector(es, pc, k);
        case 17 % inter_f_em_TO
            ps.aborem = "em";
            ps.polar = "TO";
            es.valley = randomValley(es, "interf");
            dv.valleyGuidingPrinciple(es);
            k = dv.valley.chooseStandardVectorForInelasticScattering(es, pc, 'inter', sc.omegaTO(pc.qf), -1);
            es = dv.valley.getGeneralElectricWaveVector(es, pc, k);
        case 18 % 
            return;
    end
    es = obj.modifyElectricWaveVector(es, pc);
    es = dv.valley.computeEnergyAndGroupVelocity(es, pc);
    
    if ~isequal(ps.polar, "non")
        ps.vector = es.vector - vectorTemp;
        ps = dv.valley.phononWhetherBeyondBZ(ps, pc);
        ps.getFrequency(sc);
    end
    
    function value = randomValley(es, type)
        %>随机选择能谷
        switch type
            case "interf"
                valley0 = abs(es.valley);
                valleys1 = [2, -2, 3, -3];
                valleys2 = [1, -1, 3, -3];
                valleys3 = [1, -1, 2, -2];
                index = round(randNumber(0.5, 4.5));
                switch valley0
                    case 1
                        value = valleys1(index);
                    case 2
                        value = valleys2(index);
                    case 3
                        value = valleys3(index);
                end
            case "interg"
                value = -1*es.valley;
        end
    end
end