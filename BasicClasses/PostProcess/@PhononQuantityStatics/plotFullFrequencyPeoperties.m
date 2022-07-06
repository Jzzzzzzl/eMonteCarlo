function plotFullFrequencyPeoperties(obj, field, cc)
    %>检验nDot及n的大小
    sumN = repmat(obj.polar, 1, 1);
    sumN.LA = ColocateField(cc);
    sumN.TA = ColocateField(cc);
    sumN.LO = ColocateField(cc);
    sumN.TO = ColocateField(cc);
    sumN.ALL = ColocateField(cc);
    
    for k = 1 : cc.NW
        sumN.LA.data = sumN.LA.data + field(k).LA.data;
        sumN.TA.data = sumN.TA.data + field(k).TA.data;
        sumN.LO.data = sumN.LO.data + field(k).LO.data;
        sumN.TO.data = sumN.TO.data + field(k).TO.data;
        sumN.ALL.data = sumN.ALL.data + field(k).LA.data + field(k).TA.data ...
                                                     + field(k).LO.data + field(k).TO.data;
    end
    
%     for k = 1 : cc.NW
%         sumN.LA.data = sumN.LA.data + field(k).LA.datax;
%         sumN.TA.data = sumN.TA.data + field(k).TA.datax;
%         sumN.LO.data = sumN.LO.data + field(k).LO.datax;
%         sumN.TO.data = sumN.TO.data + field(k).TO.datax;
%         sumN.ALL.data = sumN.ALL.data + field(k).LA.datax + field(k).TA.datax ...
%                                                      + field(k).LO.datax + field(k).TO.datax;
%     end
    
    figure
    hold on
    plot(cc.modelx.point, sumN.LA.data(:, cc.NY+1), 'LineWidth', 2)
    plot(cc.modelx.point, sumN.TA.data(:, cc.NY+1), 'LineWidth', 2)
    plot(cc.modelx.point, sumN.LO.data(:, cc.NY+1), 'LineWidth', 2)
    plot(cc.modelx.point, sumN.TO.data(:, cc.NY+1), 'LineWidth', 2)
    plot(cc.modelx.point, sumN.ALL.data(:, cc.NY+1), 'LineWidth', 2)
    legend(["LA" "TA" "LO" "TO" "ALL"])
end