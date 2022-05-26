function [] = writeDataToFile(filename, cc, datax, datay)
    %>
    fid = fopen([cc.filePath 'postDatas/' filename], 'w+');
    if nargin == 3
        m = size(datax);
        for i = 1 : m(1)
            for j = 1 : m(2)-1
                fprintf(fid, '%.5f\t', datax(i, j));
            end
            fprintf(fid, '%.5f\n', datax(i, end));
        end
    elseif nargin == 4
        m = size(datax);
        n = size(datay);
        if m(1) == n(1)+2
            for i = 1 : n(1)
                fprintf(fid, '%.5g\t', datax(i+1));
                fprintf(fid, '%.5g\n', datay(i));
            end
        else
            disp("数据大小对不上！")
        end
    end
    fclose(fid);
end