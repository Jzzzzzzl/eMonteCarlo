function initializePhononIndexStorage(obj)
    % 
    FrequncyStatics = struct("pop", {0}, "num", {0});
    obj.phLAab = repmat(FrequncyStatics, obj.NW, 1);
    obj.phLAem = repmat(FrequncyStatics, obj.NW, 1);
    obj.phTAab = repmat(FrequncyStatics, obj.NW, 1);
    obj.phTAem = repmat(FrequncyStatics, obj.NW, 1);
    obj.phLOab = repmat(FrequncyStatics, obj.NW, 1);
    obj.phLOem = repmat(FrequncyStatics, obj.NW, 1);
    obj.phTOab = repmat(FrequncyStatics, obj.NW, 1);
    obj.phTOem = repmat(FrequncyStatics, obj.NW, 1);
    obj.phALLab = repmat(FrequncyStatics, obj.NW, 1);
    obj.phALLem = repmat(FrequncyStatics, obj.NW, 1);
end