function ionizedImpurityScatteringRate(obj, pc, cc)
    %> 电离杂质散射(弹性近似)
    n = cc.dopDensity;
    b = @(E) pc.e^2*pc.hbar^2 * n / ...
                    (8*pc.epsilon0*pc.epsilon*pc.kb*cc.envTemp*obj.md * E);
    obj.ionizedImpurityScatRate = @(E) sqrt(2)*pi * n * pc.e^4 ...
                                             / ((4*pi*pc.epsilon0*pc.epsilon)^2*obj.md^(1/2)) ...
                                             * E^(-3/2) / (4*b(E)*(1+b(E)))*obj.xsForimpurity;
    
end