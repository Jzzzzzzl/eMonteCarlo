function [k] = chooseStandardVectorForInelasticScattering(obj, es, pc, type, frequency, flag)
    %>选择非弹性散射末态电子标准波矢
    switch type
        case 'intra'
            %>谷内散射
            theta = randNumber(0, pi);
        case 'inter'
            %>谷间散射
            theta = randNumber(0, pi);
        case 'po'
            %>极化光学
            if flag == 1
                theta = obj.thetaPOab(frequency);
            else
                theta = obj.thetaPOem(frequency);
            end
    end
    phononEnergy = double(pc.hbar * frequency);
    es.energy = es.energy + flag * phononEnergy;
    k = obj.generateStandardElectricWaveVector(es, pc, theta);
end