function statisticsScatteringTypeDistribution(obj, cc, type)
    %>散射种类分布
    obj.snumbers = zeros(7, 2);
    switch type
        case 'G1'
            index = 2;
            legends = {'impurity', 'piezoelectric', 'intra', 'polar', ...
                           'G1toU', 'G1toG3', 'non'};
        case 'G3'
            index = 3;
            legends = {'impurity', 'piezoelectric', 'intra', 'polar', ...
                           'G3toU', 'G3toG1', 'non'};
        case 'U'
            index = 1;
            legends = {'impurity', 'piezoelectric', 'intra', 'polar', ...
                           'UtoU', 'UtoG1', 'UtoG3'};
    end
    %>电离杂质散射
    obj.snumbers(1, 1) = sum(obj.scatNums(1, index));
    %>压电散射
    obj.snumbers(2, 1) = sum(obj.scatNums(2, index));
    %>谷内弹性散射
    obj.snumbers(3, 1) = sum(obj.scatNums(3, index));
    %>极化光学吸收散射
    obj.snumbers(4, 1) = sum(obj.scatNums(4, index));
    %>极化光学发射散射
    obj.snumbers(4, 2) = sum(obj.scatNums(5, index));
    %>G1toU/G3toU/UtoU吸收声子散射
    obj.snumbers(5, 1) = sum(obj.scatNums(6, index));
    %>G1toU/G3toU/UtoU发射声子散射
    obj.snumbers(5, 2) = sum(obj.scatNums(7, index));
    %>G1toG3/G3toG1/UtoG1吸收声子散射
    obj.snumbers(6, 1) = sum(obj.scatNums(8, index));
    %>G1toG3/G3toG1/UtoG1发射声子散射
    obj.snumbers(6, 2) = sum(obj.scatNums(9, index));
    %>non/non/UtoG3吸收声子散射
    obj.snumbers(7, 1) = sum(obj.scatNums(10, index));
    %>non/non/UtoG3发射声子散射
    obj.snumbers(7, 2) = sum(obj.scatNums(11, index));
    
    figure
    bar(obj.snumbers,'stacked')
    set(gca,'xticklabel' ,legends)
    title(type)
    
    %>写入文件
    writeDataToFile1D([type, 'ScaType'], cc, obj.snumbers(:, 1), obj.snumbers(:, 2));
end