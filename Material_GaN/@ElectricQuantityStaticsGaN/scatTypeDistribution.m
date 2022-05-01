function scatTypeDistribution(obj, cc, type)
    %>散射种类分布
    snumbers = zeros(7, 2);
    switch type
        case 'G1'
            valleyMin = 11;
            valleyMax = 11;
            legends = {'impurity', 'piezoelectric', 'intra', 'polar', ...
                           'G1toU', 'G1toG3', 'non'};
        case 'G3'
            valleyMin = 13;
            valleyMax = 13;
            legends = {'impurity', 'piezoelectric', 'intra', 'polar', ...
                           'G3toU', 'G3toG1', 'non'};
        case 'U'
            valleyMin = -6;
            valleyMax = 6;
            legends = {'impurity', 'piezoelectric', 'intra', 'polar', ...
                           'UtoU', 'UtoG1', 'UtoG3'};
    end
    for i = 1 : cc.superElecs
        index0 = obj.valleys(i, 1:cc.noFly-1) >= valleyMin & ...
                    obj.valleys(i, 1:cc.noFly-1) <= valleyMax;
        %>电离杂质散射
        index1 = obj.scatypes(i, 2:cc.noFly) == 1;
        %>声学压电散射
        index2 = obj.scatypes(i, 2:cc.noFly) == 2;
        %>谷内散射
        index3 = obj.scatypes(i, 2:cc.noFly) == 3;
        %>极性光学吸收散射
        index4 = obj.scatypes(i, 2:cc.noFly) == 4;
        %>极性光学发射散射
        index5 = obj.scatypes(i, 2:cc.noFly) == 5;
        %>谷间吸收光学
        index6 = obj.scatypes(i, 2:cc.noFly) ==6;
        %>谷间发射光学
        index7 = obj.scatypes(i, 2:cc.noFly) ==7;
        %>谷间吸收光学
        index8 = obj.scatypes(i, 2:cc.noFly) ==8;
        %>谷间发射光学
        index9 = obj.scatypes(i, 2:cc.noFly) ==9;
        %>谷间吸收光学
        index10 = obj.scatypes(i, 2:cc.noFly) ==10;
        %>谷间发射光学
        index11 = obj.scatypes(i, 2:cc.noFly) ==11;
        
        snumbers(1,1) = snumbers(1,1) + sum(double(index1 & index0));
        snumbers(2,1) = snumbers(2,1) + sum(double(index2 & index0));
        snumbers(3,1) = snumbers(3,1) + sum(double(index3 & index0));
        snumbers(4,1) = snumbers(4,1) + sum(double(index4 & index0));
        snumbers(4,2) = snumbers(4,2) + sum(double(index5 & index0));
        snumbers(5,1) = snumbers(5,1) + sum(double(index6 & index0));
        snumbers(5,2) = snumbers(5,2) + sum(double(index7 & index0));
        snumbers(6,1) = snumbers(6,1) + sum(double(index8 & index0));
        snumbers(6,2) = snumbers(6,2) + sum(double(index9 & index0));
        snumbers(7,1) = snumbers(7,1) + sum(double(index10 & index0));
        snumbers(7,2) = snumbers(7,2) + sum(double(index11 & index0));
    end
    snumbers = snumbers / (cc.superElecs * cc.noFly);
    figure
    bar(snumbers,'stacked')
    set(gca,'xticklabel' ,legends)
    title(type)
end