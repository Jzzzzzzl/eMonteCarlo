function [ps] = phononWhetherBeyondBZone(~, ps, pc)
    %>声子波矢长度修正
    if double(ps.wavenum / pc.dGX) > 1.0
        waveNum = ps.wavenum;
        ps.vector = ps.vector - 2 * pc.dKN * ps.vector / waveNum;
    end
end