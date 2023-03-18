function assignJobsForParallel(obj)
    %>为并行计算分配网格下标
    
    %>结构区域CSR下标划分
    obj.pjobIndexs = cutJobs(obj.NX*obj.NY, obj.localWorkers);
    %>频率区域下标划分
    obj.fjobIndexs = cutJobs(obj.NW, obj.localWorkers);
    %>电子ID划分
    obj.ejobIndexs = cutJobs(obj.superElecs, obj.localWorkers);
    
    function [result] = cutJobs(jobs, workers)
        %>任务划分
        if jobs < workers && jobs ~= 1
            error("任务太少，不足以并行！")
        end
        m = mod(jobs, workers);
        if m == 0
            njobs = floor(jobs/workers);
        else
            njobs = floor(jobs/workers)+1;
        end
        result = zeros(workers, 2);
        for i = 1 : workers
            result(i, 1) = 1 + njobs * (i - 1);
            result(i, 2) = result(i, 1) + njobs - 1;
        end
        result(end, 2) = jobs;
    end
end