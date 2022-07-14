function statisticsScatteringTypeDistribution(obj)
    %>散射种类分布
    obj.snumbers = zeros(4, 2);
    %>电离杂质散射
    obj.snumbers(1, 1) = sum(obj.scatNums(1, 1));
    %>声学波吸收形变势散射
    obj.snumbers(2, 1) = sum(obj.scatNums(2:3, 1));
    %>声学波发射形变势散射
    obj.snumbers(2, 2) = sum(obj.scatNums(10:11, 1));
    %>f型吸收声子谷间散射
    obj.snumbers(3, 1) = sum(obj.scatNums(4:6, 1));
    %>f型发射声子谷间散射
    obj.snumbers(3, 2) = sum(obj.scatNums(12:14, 1));
    %>g型吸收声子谷间散射
    obj.snumbers(4, 1) = sum(obj.scatNums(7:9, 1));
    %>g型发射声子谷间散射
    obj.snumbers(4, 2) = sum(obj.scatNums(15:17, 1));
    
    figure
    bar(obj.snumbers,'stacked')
    set(gca,'xticklabel',{'impurity', 'intra', 'interf', 'interg'})
end