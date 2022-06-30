function [k] = chooseStandardVectorForElasticScattering(obj, es, pc, type)
    %>选择弹性散射末态电子标准波矢
    %> 参数说明：
    %     type：'ap'/'ii'/'intra'
    switch type
        case 'a'
            %>声学压电散射角
            theta = obj.thetaAPiezo;
        case 'i'
            %>电离杂质散射角
            theta = obj.thetaIImpu;
        case 't'
            %>谷内弹性散射角
            theta = randNumber(0, pi);
    end
    k = obj.generateStandardElectricWaveVector(es, pc, theta);
end