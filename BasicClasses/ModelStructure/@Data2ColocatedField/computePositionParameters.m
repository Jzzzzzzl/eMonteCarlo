function computePositionParameters(obj, es)
    %>计算电子所在位置的参数
    %>必须保证index1和index2为内部节点
    index1 = find(es.position(1) <= obj.modelx.face, 1);
    if eq(index1, 1)
        index1 = index1 + 1;
    end
    if isempty(index1)
        index1 = obj.NX + 1;
    end
    index2 = find(es.position(2) <= obj.modely.face, 1);
    if eq(index2, 1)
        index2 = index2 + 1;
    end
    if isempty(index2)
        index2 = obj.NY + 1;
    end
    if ~isempty(obj.xField)
        valuex = obj.xField.data(index1, index2);
        valuey = obj.yField.data(index1, index2);
    elseif ~isempty(obj.eFieldInput)
        %>阶跃电场查找
        index = find(obj.eFieldInput(:, 1) >= es.time, 1);
        valuex = obj.eFieldInput(index, 2);
        valuey = 0;
    else
        error("无有效电场信息！")
    end
    es.devField = [valuex, valuey, 0];
    es.devTem = obj.deviceTemp.data(index1, index2);
    es.devDop = obj.dopDensity.data(index1, index2);
    es.devCon = obj.eleConc.data(index1, index2);
end