function assignJobsForParallel(obj)
    %>为并行计算分配网格下标
    %>结构区域CSR下标划分
    m = floor(obj.NX*obj.NY/obj.localWorkers);
    if m <= obj.localWorkers
        njobs = floor(obj.NX*obj.NY/obj.localWorkers);
    else
        njobs = floor(obj.NX*obj.NY/obj.localWorkers)+1;
    end
    obj.pjobIndexs = zeros(obj.localWorkers, 2);
    for i = 1 : obj.localWorkers
        obj.pjobIndexs(i, 1) = 1 + njobs * (i - 1);
        obj.pjobIndexs(i, 2) = obj.pjobIndexs(i, 1) + njobs - 1;
    end
    obj.pjobIndexs(end, 2) = obj.NX*obj.NY;
    %>频率区域下标划分
    m = floor(obj.NW/obj.localWorkers);
    if m <= obj.localWorkers
        njobs = floor(obj.NW/obj.localWorkers);
    else
        njobs = floor(obj.NW/obj.localWorkers)+1;
    end
    obj.fjobIndexs = zeros(obj.localWorkers, 2);
    for i = 1 : obj.localWorkers
        obj.fjobIndexs(i, 1) = 1 + njobs * (i - 1);
        obj.fjobIndexs(i, 2) = obj.fjobIndexs(i, 1) + njobs - 1;
    end
    obj.fjobIndexs(end, 2) = obj.NW;
    %>电子ID划分
    m = floor(obj.superElecs/obj.localWorkers);
    if m <= obj.localWorkers
        njobs = floor(obj.superElecs/obj.localWorkers);
    else
        njobs = floor(obj.superElecs/obj.localWorkers)+1;
    end
    obj.ejobIndexs = zeros(obj.localWorkers, 2);
    for i = 1 : obj.localWorkers
        obj.ejobIndexs(i, 1) = 1 + njobs * (i - 1);
        obj.ejobIndexs(i, 2) = obj.ejobIndexs(i, 1) + njobs - 1;
    end
    obj.ejobIndexs(end, 2) = obj.superElecs;
end