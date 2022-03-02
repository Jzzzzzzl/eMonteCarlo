%% 这里存放色散曲线和其他一些函数

syms q;

omegaLA = 0.000e13 + 8.861e3*q - 1.931e-7*q.^2;
omegaTA = 0.000e13 + 5.993e3*q - 3.165e-7*q.^2;
omegaLO = 9.473e13 + 5.876e2*q - 1.950e-7*q.^2;
omegaTO = 9.824e13 - 2.547e3*q + 1.140e-7*q.^2;

% 计算各极化支定义域
wMinLA = double(subs(omegaLA,q,0));
wMaxLA = double(subs(omegaLA,q,dGX));
wMinTA = double(subs(omegaTA,q,0));
wMaxTA = double(subs(omegaTA,q,dGX));
wMaxLO = double(subs(omegaLO,q,0));
wMinLO = double(subs(omegaLO,q,dGX));
wMaxTO = double(subs(omegaTO,q,0));
wMinTO = double(subs(omegaTO,q,dGX));

%计算谷间散射对应频率
wgTA = double(subs(omegaTA, qg));
wgLA = double(subs(omegaLA, qg));
wgTO = double(subs(omegaTO, qg));
wgLO = double(subs(omegaLO, qg));
wfTA = double(subs(omegaTA, qf));
wfLA = double(subs(omegaLA, qf));
wfTO = double(subs(omegaTO, qf));
wfLO = double(subs(omegaLO, qf));

