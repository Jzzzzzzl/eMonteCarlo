function [k] = chooseStandardVectorForElasticScattering(obj, es, pc, type)
    %>选择弹性散射末态电子标准波矢
    switch type
        case 'ap'
            %>声学压电散射角
            theta = obj.thetaAP;
        case 'ii'
            %>电离杂质散射角
            theta = obj.thetaII;
        case 'intra'
            %>谷内弹性散射角
            theta = randNumber(0, pi);
    end
    k = obj.generateStandardElectricWaveVector(es, pc, theta);
end