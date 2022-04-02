function [ps] = phononWhetherBeyondBZone(~, ps, pc)
    %>声子波矢长度修正
    if double(ps.wavenum / pc.dGL) > 1.0
        waveNum = ps.wavenum;
        ps.vector(1) = ps.vector(1) - 2 * pc.dKN * ps.vector(1) / waveNum;
        ps.vector(2) = ps.vector(2) - 2 * pc.dKN * ps.vector(2) / waveNum;
        ps.vector(3) = ps.vector(3) - 2 * pc.dKN * ps.vector(3) / waveNum;
    end
end