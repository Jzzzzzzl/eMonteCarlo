function scatTypeDistribution(obj, sh, cc)
    %>散射种类分布
    numbers = zeros(7, 2);
    for i = 1 : cc.superElecs
        types = [sh.eHistory(i,:).scatype];
        %>电离杂质散射
        index1 = types == 1;
        %>声学压电散射
        index2 = types == 2;
        %>谷内散射
        index3 = types == 3;
        %>极性光学吸收散射
        index4 = types == 4;
        %>极性光学发射散射
        index5 = types == 5;
        %>UU谷间吸收
        index6 = types >=6 & types <=7;
        %>UU谷间发射
        index7 = types >=8 & types <=9;
        %>UG1谷间吸收
        index8 = types >=10 & types <=11;
        %>UG1谷间发射
        index9 = types >=12 & types <=13;
        %>UG3谷间吸收
        index10 = types >=14 & types <=15;
        %>UG3谷间发射
        index11 = types >=16 & types <=17;
        
        numbers(1,1) = numbers(1,1) + sum(double(index1));
        numbers(2,1) = numbers(2,1) + sum(double(index2));
        numbers(3,1) = numbers(3,1) + sum(double(index3));
        numbers(4,1) = numbers(4,1) + sum(double(index4));
        numbers(4,2) = numbers(4,2) + sum(double(index5));
        numbers(5,1) = numbers(5,1) + sum(double(index6));
        numbers(5,2) = numbers(5,2) + sum(double(index7));
        numbers(6,1) = numbers(6,1) + sum(double(index8));
        numbers(6,2) = numbers(6,2) + sum(double(index9));
        numbers(7,1) = numbers(7,1) + sum(double(index10));
        numbers(7,2) = numbers(7,2) + sum(double(index11));
    end
    numbers = numbers / (cc.superElecs * cc.noFly);
    figure
    bar(numbers,'stacked')
    set(gca,'xticklabel',{'impurity', 'piezoelectric', 'intra', 'polar', ...
                               'UtoU', 'UtoG1', 'UtoG3'})
end