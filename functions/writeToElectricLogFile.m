function writeToElectricLogFile(fileID, egroup, ~)
    %>将模拟数据写入log文件
    fprintf(fileID, '%d\t', egroup.id);
    fprintf(fileID, '%.5g\t%.5g\t%.5g\t', egroup.position);
    fprintf(fileID, '%.5g\t%.5g\t%.5g\t', egroup.energy, egroup.time, egroup.perdrift);
    fprintf(fileID, '%d\t%d\n', egroup.valley, egroup.scatype);
    
%     fprintf(fileID, '%d\t%d\t', egroup.id, k);
%     fprintf(fileID, '%.5g\t%.5g\t%.5g\t', egroup.position);
%     fprintf(fileID, '%.5g\t%.5g\t%.5g\t', egroup.vector);
%     fprintf(fileID, '%.5g\t%.5g\t%.5g\t', egroup.energy, egroup.time, egroup.perdrift);
%     fprintf(fileID, '%d\t%d\n', egroup.valley, egroup.scatype);
end