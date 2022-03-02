%% 这里存放色散曲线和其他一些函数

syms q;

omegaLA = 0.00*10^13 + 9.01*10^3*q - 2.00*10^(-7)*q.^2;
omegaTA = 0.00*10^13 + 5.23*10^3*q - 2.26*10^(-7)*q.^2;
omegaLO = 9.88*10^13 + 0.00*10^3*q - 1.60*10^(-7)*q.^2;
omegaTO = 10.2*10^13 - 2.57*10^3*q + 1.11*10^(-7)*q.^2;

wMinLA = double(subs(omegaLA,q,0));
wMaxLA = double(subs(omegaLA,q,dGX));
wMinTA = double(subs(omegaTA,q,0));
wMaxTA = double(subs(omegaTA,q,dGX));
wMaxLO = double(subs(omegaLO,q,0));
wMinLO = double(subs(omegaLO,q,dGX));
wMaxTO = double(subs(omegaTO,q,0));
wMinTO = double(subs(omegaTO,q,dGX));






