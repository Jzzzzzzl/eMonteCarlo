function writeToElectricLogFile(fileID, group, cc)
    %>将模拟数据写入log文件
    for i = 1 : cc.superElecs
        fprintf(fileID, '%.5g \t %.5g \t %.5g \t', group(i).position);
        fprintf(fileID, '%.5g \t %.5g \t %.5g \t', group(i).vector);
        fprintf(fileID, '%.5g \t %.5g \t %.5g \t', group(i).energy, group(i).time, group(i).perdrift);
        fprintf(fileID, '%d \t %d \n', group(i).valley, group(i).scatype);
    end
end