function writeToPhononLogFile(fileID, group, cc)
    %>将模拟数据写入log文件
    for i = 1 : cc.superElecs
        fprintf(fileID, '%.5g \t %.5g \t %.5g \t', group(i).position);
        fprintf(fileID, '%.5g \t %.5g \t %.5g \t', group(i).vector);
        fprintf(fileID, '%.5g \t %.5g \t', group(i).frequency, group(i).time);
        fprintf(fileID, '%s \t %s \n', group(i).aborem, group(i).polar);
    end
end