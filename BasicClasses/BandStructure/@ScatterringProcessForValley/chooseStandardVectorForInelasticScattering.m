function [k] = chooseStandardVectorForInelasticScattering(obj, es, pc, type, frequency, flag)
    %>选择非弹性散射末态电子标准波矢
    %> 参数说明：
    %      type：'intra'/'inter'/'po'
    %      flag：吸收(+1)或发射(-1)
    switch type
        case 'a'
            %>谷内散射
            theta = randNumber(0, pi);
        case 'e'
            %>谷间散射
            theta = randNumber(0, pi);
        case 'p'
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