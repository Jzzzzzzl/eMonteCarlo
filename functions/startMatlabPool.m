function [] = startMatlabPool(workers)
    %>开启并行池
    poolobj = gcp('nocreate');
    if isempty(poolobj)
        parpool(workers);
    else
        poolsize = poolobj.NumWorkers;
        disp(['并行环境已启动，使用核数：' num2str(poolsize)])
    end
end