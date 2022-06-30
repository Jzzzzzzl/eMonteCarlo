function statisticsScatteringTypeDistribution(obj, cc)
    %>散射种类分布
    obj.snumbers = zeros(4, 2);
    for i = 1 : cc.superElecs
        %电离杂质散射
        index1 = obj.scatypes(i, :) == 1;
        %声学波吸收形变势散射
        index2 = obj.scatypes(i, :) >=2 & obj.scatypes(i, :) <=3;
        %声学波发射形变势散射
        index3 = obj.scatypes(i, :) >=10 & obj.scatypes(i, :) <=11;
        %f型吸收声子谷间散射
        index4 = obj.scatypes(i, :) >=4 & obj.scatypes(i, :) <=6;
        %f型发射声子谷间散射
        index5 = obj.scatypes(i, :) >=12 & obj.scatypes(i, :) <=14;
        %g型吸收声子谷间散射
        index6 = obj.scatypes(i, :) >=7 & obj.scatypes(i, :) <=9;
        %g型发射声子谷间散射
        index7 = obj.scatypes(i, :) >=15 & obj.scatypes(i, :) <=17;
        
        obj.snumbers(1,1) = obj.snumbers(1,1) + sum(double(index1));
        obj.snumbers(2,1) = obj.snumbers(2,1) + sum(double(index2));
        obj.snumbers(2,2) = obj.snumbers(2,2) + sum(double(index3));
        obj.snumbers(3,1) = obj.snumbers(3,1) + sum(double(index4));
        obj.snumbers(3,2) = obj.snumbers(3,2) + sum(double(index5));
        obj.snumbers(4,1) = obj.snumbers(4,1) + sum(double(index6));
        obj.snumbers(4,2) = obj.snumbers(4,2) + sum(double(index7));
    end
    obj.snumbers = obj.snumbers / (cc.superElecs * cc.noFly);
    figure
    bar(obj.snumbers,'stacked')
    set(gca,'xticklabel',{'impurity', 'intra', 'interf', 'interg'})
end