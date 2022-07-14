function writeToPhononLogFile(fileID, pgroup)
    %>将模拟数据写入log文件
    if pgroup.polar ~= -1
        fprintf(fileID, '%.5g\t%.5g\t%.5g\t', pgroup.position);
        fprintf(fileID, '%.5g\t%.5g\t%.5g\t', pgroup.vector);
        fprintf(fileID, '%.5g\t%.5g\t', pgroup.frequency, pgroup.time);
        fprintf(fileID, '%d\t%d\n', pgroup.aborem, pgroup.polar);
    end
end