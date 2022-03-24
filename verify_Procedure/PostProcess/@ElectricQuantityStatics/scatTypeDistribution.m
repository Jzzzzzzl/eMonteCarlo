function [numbers] = scatTypeDistribution(~, sh, cc)
    %>散射种类分布
    numbers = zeros(4, 2);
    for i = 1 : cc.superElecs
        types = [sh.eHistory(i,:).scatype];
        %电离杂质散射
        index1 = types == 1;
        %声学波吸收形变势散射
        index2 = types >=2 & types <=3;
        %声学波发射形变势散射
        index3 = types >=4 & types <=5;
        %f型吸收声子谷间散射
        index4 = types >=9 & types <=11;
        %f型发射声子谷间散射
        index5 = types >=15 & types <=17;
        %g型吸收声子谷间散射
        index6 = types >=6 & types <=8;
        %g型发射声子谷间散射
        index7 = types >=12 & types <=14;

        numbers(1,1) = numbers(1,1) + sum(double(index1));
        numbers(2,1) = numbers(2,1) + sum(double(index2));
        numbers(2,2) = numbers(2,2) + sum(double(index3));
        numbers(3,1) = numbers(3,1) + sum(double(index4));
        numbers(3,2) = numbers(3,2) + sum(double(index5));
        numbers(4,1) = numbers(4,1) + sum(double(index6));
        numbers(4,2) = numbers(4,2) + sum(double(index7));
    end
    numbers = numbers / (cc.superElecs * cc.noFly);
    figure
    bar(numbers,'stacked')
    set(gca,'xticklabel',{'impurity', 'intra', 'interf', 'interg'})
end