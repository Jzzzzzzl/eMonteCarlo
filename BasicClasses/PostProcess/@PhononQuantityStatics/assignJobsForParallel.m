function assignJobsForParallel(obj, cc)
    %>为并行计算分配网格下标
    %>结构区域CSR下标任务划分
    if cc.NX*cc.NY <= cc.localWorkers || ...
        cc.NW <= cc.localWorkers
        error("网格划分份数太少了！")
    end
    m = floor(cc.NX*cc.NY/cc.localWorkers);
    if m <= cc.localWorkers
        njobs = floor(cc.NX*cc.NY/cc.localWorkers);
    else
        njobs = floor(cc.NX*cc.NY/cc.localWorkers)+1;
    end
    obj.pjobIndexs = zeros(cc.localWorkers, 2);
    for i = 1 : cc.localWorkers
        obj.pjobIndexs(i, 1) = 1 + njobs * (i - 1);
        obj.pjobIndexs(i, 2) = obj.pjobIndexs(i, 1) + njobs - 1;
    end
    obj.pjobIndexs(end, 2) = cc.NX*cc.NY;
    %>频率区域下标任务划分
    m = floor(cc.NW/cc.localWorkers);
    if m <= cc.localWorkers
        njobs = floor(cc.NW/cc.localWorkers);
    else
        njobs = floor(cc.NW/cc.localWorkers)+1;
    end
    obj.fjobIndexs = zeros(cc.localWorkers, 2);
    for i = 1 : cc.localWorkers
        obj.fjobIndexs(i, 1) = 1 + njobs * (i - 1);
        obj.fjobIndexs(i, 2) = obj.fjobIndexs(i, 1) + njobs - 1;
    end
    obj.fjobIndexs(end, 2) = cc.NW;
end