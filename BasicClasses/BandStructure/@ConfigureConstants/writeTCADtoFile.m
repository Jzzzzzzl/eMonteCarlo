function writeTCADtoFile(obj)
    %>将TCAD数据写入文件
    if isempty(obj.filePath)
        error("文件路性为空！")
    end
    %>分一维写入与二维写入
    if obj.NY == 1
        X = obj.modelx.point(2:end-1)*1e9;
        writeDataToFile1D('potential', obj, X, obj.potential.data(2:end-1, obj.NY+1));
        writeDataToFile1D('latticeTem', obj, X, obj.potential.data(2:end-1, obj.NY+1));
        writeDataToFile1D('jouleHeat', obj, X, obj.potential.data(2:end-1, obj.NY+1));
        writeDataToFile1D('conducBand', obj, X, obj.potential.data(2:end-1, obj.NY+1));
        writeDataToFile1D('eMobility', obj, X, obj.potential.data(2:end-1, obj.NY+1));
        writeDataToFile1D('dopDensity', obj, X, obj.potential.data(2:end-1, obj.NY+1));
        writeDataToFile1D('eleConc', obj, X, obj.potential.data(2:end-1, obj.NY+1));
        writeDataToFile1D('xField', obj, X, obj.potential.data(2:end-1, obj.NY+1));
        writeDataToFile1D('yField', obj, X, obj.potential.data(2:end-1, obj.NY+1));
        writeDataToFile1D('xyField', obj, X, obj.potential.data(2:end-1, obj.NY+1));
    else
        X = obj.modelx.face(1:end-1)*1e9;
        Y = obj.modely.face(1:end-1)*1e9;
        writeDataToFile2D('potential', obj, X, Y, obj.potential.data(2:end-1, 2:end-1));
        writeDataToFile2D('latticeTem', obj, X, Y, obj.latticeTem.data(2:end-1, 2:end-1));
        writeDataToFile2D('jouleHeat', obj, X, Y, obj.jouleHeat.data(2:end-1, 2:end-1));
        writeDataToFile2D('conducBand', obj, X, Y, obj.conducBand.data(2:end-1, 2:end-1));
        writeDataToFile2D('eMobility', obj, X, Y, obj.eMobility.data(2:end-1, 2:end-1));
        writeDataToFile2D('dopDensity', obj, X, Y, obj.dopDensity.data(2:end-1, 2:end-1));
        writeDataToFile2D('eleConc', obj, X, Y, obj.eleConc.data(2:end-1, 2:end-1));
        writeDataToFile2D('xField', obj, X, Y, obj.xField.data(2:end-1, 2:end-1));
        writeDataToFile2D('yField', obj, X, Y, obj.yField.data(2:end-1, 2:end-1));
        writeDataToFile2D('xyField', obj, X, Y, obj.xyField.data(2:end-1, 2:end-1));
    end
end