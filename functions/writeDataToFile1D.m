function [] = writeDataToFile1D(filename, cc, datax, datay)
    %>输出数据到文件
    fid = fopen([cc.filePath 'postDatas/' filename], 'w+');
    
    if ~isvector(datax)
        error("datax非向量！")
    end
    m = size(datax);
    n = size(datay);
    if m(1) == n(1)
        for i = 1 : m(1)
            fprintf(fid, '%.5g\t', datax(i));
            for j = 1 : n(2)
                fprintf(fid, '%.5g\t', datay(i, j));
            end
            fprintf(fid, '\n');
        end
    else
        disp("数据大小对不上！")
    end
    fclose(fid);
end