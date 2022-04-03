function elasticIntravalleyAcousticScatteringRate(obj, dv, pc, cc)
    %>生成谷内声学散射句柄函数（弹性）
    %>     参数说明：
    %>     D：形变势常量
    % ======================================================================
    obj.elasticIntraAcoustic = @(D) sqrt(2)*dv.bs.md^(3/2)*pc.kb*cc.envTemp*D^2 ...
                                      / (pi*pc.hbar^4*pc.u^2*pc.rho) ...
                                      * sqrt(dv.bs.gamma)*(1+2*dv.bs.alpha*dv.bs.epsilon/pc.e) ...
                                      * sqrt(1+dv.bs.alpha*dv.bs.epsilon/pc.e);
end