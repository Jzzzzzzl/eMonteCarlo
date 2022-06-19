function assignJobsForParallel(obj, cc)
    %>为并行计算分配网格下标
    m = floor(cc.NX*cc.NY/cc.localWorkers);
    if m <= cc.localWorkers
        njobs = floor(cc.NX*cc.NY/cc.localWorkers);
    else
        njobs = floor(cc.NX*cc.NY/cc.localWorkers)+1;
    end
    obj.jobIndexs = zeros(cc.localWorkers, 2);
    for i = 1 : cc.localWorkers
        obj.jobIndexs(i, 1) = 1 + njobs * (i - 1);
        obj.jobIndexs(i, 2) = obj.jobIndexs(i, 1) + njobs - 1;
    end
    obj.jobIndexs(end, 2) = cc.NX*cc.NY;
end