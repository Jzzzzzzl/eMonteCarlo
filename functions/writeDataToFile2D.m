function [] = writeDataToFile2D(filename, cc, datax, datay, dataz)
    %>输出数据到文件
    fid = fopen([cc.filePath 'postDatas/' filename], 'w+');
    
    if ~isvector(datax) || ~isvector(datay)
        error("输入非向量！")
    end
    m = size(datax);
    n = size(datay);
    p = size(dataz);
    if m(1) == p(1) && n(1) == p(2)
        for i = 1 : m(1)
            for j = 1 : n(1)
                fprintf(fid, '%.5g\t', datax(i));
                fprintf(fid, '%.5g\t', datay(j));
                fprintf(fid, '%.5g\n', dataz(i, j));
            end
        end
    else
        disp("数据大小对不上！")
    end
    fclose(fid);
end