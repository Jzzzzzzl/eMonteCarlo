%% 函数集文件

function Funs = Funs
    % 预处理部分
    Funs.GroupVelocityDOSTao       = @GroupVelocityDOSTao;
    Funs.MeshGrid                  = @MeshGrid;
    Funs.AllGrid                   = @AllGrid;
    Funs.Karray                    = @Karray;
    Funs.ScatterringTable          = @ScatterringTable;
    Funs.PlotScatterringRate       = @PlotScatterringRate;
    Funs.ChooseScatType            = @ChooseScatType;
    Funs.AveDopDensity           = @AveDopDensity;
    Funs.PlotDensity               = @PlotDensity;
    Funs.ComputeSuperCharge        = @ComputeSuperCharge;
    Funs.ComputeNe                 = @ComputeNe;
    Funs.ElectronConc              = @ElectronConc;
    Funs.GenerateElectron          = @GenerateElectron;
    Funs.MaxwellVelocity           = @MaxwellVelocity;
    Funs.PlotMaxwell               = @PlotMaxwell;
    Funs.Choosek                   = @Choosek;
    Funs.Random                    = @Random;
    Funs.InitializeInfor           = @InitializeInfor;
    % 计算模拟部分
    Funs.RotMatrix              = @RotMatrix;
    Funs.ComputeElecEnergy = @ComputeElecEnergy;
    Funs.ComputeElecVelocity = @ComputeElecVelocity;
    Funs.ChooseWaveVector   = @ChooseWaveVector;
    
    Funs.WhichValley             = @WhichValley;
    Funs.eBand                     = @eBand;
    Funs.eBandPlot               = @eBandPlot;
    Funs.Ifbeyondbz                = @Ifbeyondbz;
    Funs.SearchEfield              = @SearchEfield;
    Funs.ChooseFinalValley         = @ChooseFinalValley;
    Funs.ChooseFinalK              = @ChooseFinalK;
    Funs.ChooseFinalK2         = @ChooseFinalK2;
    Funs.EscatP                    = @EscatP;
    Funs.TimeForFly                = @TimeForFly;
    Funs.EnergyDecayArray            = @EnergyDecayArray;
    Funs.Localization              = @Localization;
    Funs.FlyProcess                = @FlyProcess;
    Funs.ParFunction               = @ParFunction;
    Funs.SubsectionParllel         = @SubsectionParllel;
    % 后处理部分
    Funs.ElectronMobility         = @ElectronMobility;
    Funs.ElectronDirftVelocity   = @ElectronDirftVelocity;
    Funs.DirftVelocityToTime    = @DirftVelocityToTime;
    Funs.ScatTypeDistribution   = @ScatTypeDistribution;
    
    
    Funs.ElectronInformation    = @ElectronInformation;
    Funs.ElectronEnergyDistribution = @ElectronEnergyDistribution;
    Funs.VerifyProgram              = @VerifyProgram;
    
    Funs.TotalFlyTime              = @TotalFlyTime;
    Funs.StatisticPhonon           = @StatisticPhonon;
    Funs.HeatGeneration            = @HeatGeneration;
    Funs.PlotSumnAndnDot           = @PlotSumnAndnDot;
    Funs.FarDistributionFunction   = @FarDistributionFunction;
    Funs.SolveConvection           = @SolveConvection;
    Funs.ComputeTF                 = @ComputeTF;
    Funs.SolveDiffusion            = @SolveDiffusion;
    Funs.ComputeTeff               = @ComputeTeff;
    Funs.PolarTeff                 = @PolarTeff;
    Funs.PlotTeff                  = @PlotTeff;
    Funs.ElectronTrace             = @ElectronTrace;
    Funs.AverageEnergyTime         = @AverageEnergyTime;
    Funs.AverageEnergyDisplace     = @AverageEnergyDisplace;
    Funs.PhononEmSpectrum          = @PhononEmSpectrum;
    Funs.PhononDistribution        = @PhononDistribution;
    Funs.Write2datFile             = @Write2datFile;
    
end

%###########################
%######## 预处理部分 #########
%###########################

% 网格划分
function [grid] = MeshGrid(Min, Max, N)
    % Min:最小值
    % Max:最大值
    % N:划分份数
    Public;
    
    grid = Grid;
    delta = (Max-Min)/N;
    grid.face  = zeros(N+1,1);
    grid.point = zeros(N+2,1);
    grid.face(1)   = Min;
    grid.face(N+1) = Max;
    grid.point(1)  = Min;
    grid.point(N+2)= Max;
    for k = 2:N+1
        grid.face(k)  = (k-1)*delta + grid.face(1);
        grid.point(k) = (grid.face(k) + grid.face(k-1))*0.5;
    end
    
end

% 生成所有网格
function [grid] = AllGrid()
    Macro;
    Public;
    
    grid = Allgrid;
    grid.w = MeshGrid(wMin, wMax, NW);% 频率
    
end

% 散射表
function [scatTable] = ScatterringTable(energy)
    % energy:电子能量值
    
    % type = 1---------------e-impurity
    % type = 2---------------intra_LA
    % type = 3---------------intra_TA
    % type = 4---------------inter_g_ab_TA
    % type = 5---------------inter_g_ab_LA
    % type = 6---------------inter_g_ab_LO
    % type = 7---------------inter_f_ab_TA
    % type = 8---------------inter_f_ab_LA
    % type = 9---------------inter_f_ab_TO
    % type = 10--------------inter_g_em_TA
    % type = 11--------------inter_g_em_LA
    % type = 12--------------inter_g_em_LO
    % type = 13--------------inter_f_em_TA
    % type = 14--------------inter_f_em_LA
    % type = 15--------------inter_f_em_TO
    Macro;
    ScatterringCurve;
    
    % 三种散射的句柄函数
    % 电离杂质散射(弹性近似)
    b = @(epsilon, ni) e^2*hbar^2*ni/(8*epsilon0*epsilonSi*kb*T*md*epsilon);
    P_impurity = @(epsilon, ni) sqrt(2)*pi*ni*e^4/((4*pi*epsilon0*epsilonSi)^2*md^(1/2))*epsilon^(-3/2)/...
                                         (4*b(epsilon, ni)*(1+b(epsilon, ni)))*xsForimpurity;
    % 声学波形变势散射(弹性近似)
    P_intra = @(epsilon, D, u) 2^(1/2)*md^(3/2)*kb*T*D^2/(pi*hbar^4*u^2*rou)*epsilon.^(1/2);
    % 谷间散射(非弹性近似)
    P_inter_ab = @(epsilon, DK, Zf, wi) DK^2*md^(3/2)*Zf/(2^(1/2)*pi*rou*hbar^3*wi)*...
                                                    (1/(exp(hbar*wi/(kb*T))-1))*real(sqrt(epsilon+hbar*wi));
    P_inter_em = @(epsilon, DK, Zf, wi) DK^2*md^(3/2)*Zf/(2^(1/2)*pi*rou*hbar^3*wi)*...
                                                     (1+1/(exp(hbar*wi/(kb*T))-1))*real(sqrt(epsilon-hbar*wi));
    % 计算散射率
    scatTable = zeros(nofScat,1);
    scatTable(1) = P_impurity(energy, DopDensity);
    scatTable(2) = P_intra(energy, DLA, ul);
    scatTable(3) = P_intra(energy, DTA, ut);
    scatTable(4) = P_inter_ab(energy, gDKTA, 1, wgTA);
    scatTable(5) = P_inter_ab(energy, gDKLA, 1, wgLA);
    scatTable(6) = P_inter_ab(energy, gDKLO, 1, wgLO);
    scatTable(7) = P_inter_ab(energy, fDKTA, 4, wfTA);
    scatTable(8) = P_inter_ab(energy, fDKLA, 4, wfLA);
    scatTable(9) = P_inter_ab(energy, fDKTO, 4, wfTO);
    scatTable(10)= P_inter_em(energy, gDKTA, 1, wgTA);
    scatTable(11)= P_inter_em(energy, gDKLA, 1, wgLA);
    scatTable(12)= P_inter_em(energy, gDKLO, 1, wgLO);
    scatTable(13)= P_inter_em(energy, fDKTA, 4, wfTA);
    scatTable(14)= P_inter_em(energy, fDKLA, 4, wfLA);
    scatTable(15)= P_inter_em(energy, fDKTO, 4, wfTO);
    
end

% 散射率画图
function [scatTable] = PlotScatterringRate(energy)
    % energy:电子能量列表
    Macro;
    
    scatTable = zeros(length(energy),nofScat+1);
    for i = 1:length(energy)
        scatTable(i,1:end-1) = deal(ScatterringTable(energy(i))');
        scatTable(i,end) = sum(scatTable(i,1:end-1));
    end
    figure
    for j = 1:nofScat+1
        slg = loglog(energy/e*1000, scatTable(:,j));
        slg.LineWidth = 3;
        hold on
    end
    legend("e-impurity","intra LA","intra TA","inter g ab TA","inter g ab LA",...
              "inter g ab LO","inter f ab TA","inter f ab LA","inter f ab TO",...
              "inter g em TA","inter g em LA","inter g em LO","inter f em TA",...
              "inter f em LA","inter f em TO","total")
    xlabel('meV');
    ylabel('s^{-1}')
    
end

% 计算散射类型
function [type] = ChooseScatType(scatTableAll)
    % scatTableAll:散射表
    Macro;
    
    r = rand(1)*scatTableAll(end);
    type = find(scatTableAll > r, 1);
    
end

% 随机在某位置上生成电子
function [particle] = GenerateElectron(lb,rb,energy)
    % lb:左边界
    % rb:右边界
    % energy:电子能量值
    Macro;
    Public;
    
    particle = Electron;
    % 随机生成位置
    particle.energy = energy;
    particle.r(1) = Random(lb, rb);
    particle.r(2) = 0;
    particle.r(3) = 0;
    % 随机生成能谷
    valleys = [1 -1 2 -2 3 -3];
    index = round(Random(0.5, 6.5));
    particle.valley = valleys(index);
    % 随机生成波矢
    particle = ChooseWaveVector(particle);
    % 计算初始速度
    particle.v = ComputeElecVelocity(particle);
    
end

% 返回一个在num1和num2之间的随机数
function [value] = Random(num1,num2)
    % num1与num2顺序无所谓
    
    if num2 > num1
        b = num2;
        a = num1;
    elseif num2 < num1
        b = num1;
        a = num2;
    else
        value = num1;
        return;
    end
    value = b+1;
    while value<=a || value>=b
        value = a+(b-a)*rand(1);
    end
    
end

% 初始化电子群信息
function [electrons] = InitializeInfor(electrons)
    % electrons:电子信息结构体
    Macro;
    
    for i = 1:SuperElecs
        electrons(i) = GenerateElectron(0,0,EnergyInit);
    end
    
end

%###########################
%####### 计算模拟部分 #########
%###########################

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  1  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 说明：后面要实现三维能带模拟
% (1)电子能带计算以第一导带底为原点,使用有效质量近似进行计算;
% (2)Ifbeyondbz只考虑了电子在X面超出的情况,这主要是考虑到电子主要集中在各个谷内
%    而声子则是在波矢反方向直接加上倒格矢,这纯粹是为了简单考虑;
% (3)插值电场强度不使用spline是因为速度太慢;
% (4)EscatP中的代号:LA(1);TA(2);LO(3);TO(4)  'em'(0);'ab'(1)
% (5)计算飞行时间是依据总散射率来进行的,但gammaMax的值可以设定,不必严格等于散射表末值
% (6)人为局域化是依据电子位置和能量来进行的,位置要在热点附近且能量要高于EnergyCut
% (7)局域化是通过flag参数来考虑的,因为在局域化中电子波矢不要被电场改变,且时间还要记录

% 旋转矩阵
function [Rrot] = RotMatrix(theta, type)
    % 在符合右手法则的坐标系中顺时针旋转
    
    switch type
        case 'x'
            Rrot = [1 0 0;0 cos(theta) -sin(theta);0 sin(theta) cos(theta)];
        case 'y'
            Rrot = [cos(theta) 0 sin(theta);0 1 0;-sin(theta) 0 cos(theta)];
        case 'z'
            Rrot = [cos(theta) -sin(theta) 0;sin(theta) cos(theta) 0;0 0 1];
    end
    
end

% 能量计算
function [energy] = ComputeElecEnergy(particle)
    % 
    Macro;
    
    switch particle.valley
        case 1
            kk = particle.k*RotMatrix(pi/2, 'y');
        case -1
            kk = particle.k*RotMatrix(-pi/2, 'y');
        case 2
            kk = particle.k*RotMatrix(-pi/2, 'x');
        case -2
            kk = particle.k*RotMatrix(pi/2, 'x');
        case 3
            kk = particle.k*RotMatrix(0, 'x');
        case -3
            kk = particle.k*RotMatrix(pi, 'x');
    end
    k0 = kk - [0, 0, 0.85] * dGX;
    energy = inParabolicFactor*hbar^2*(k0(1)^2/mt + k0(2)^2/mt + k0(3)^2/ml)/2;
    if energy > EnergyMax
        energy = EnergyMax;
    end
    
end

% 速度计算
function [velocity] = ComputeElecVelocity(particle)
    % 
    Macro;
    
    switch particle.valley
        case 1
            kk = particle.k*RotMatrix(pi/2, 'y');
        case -1
            kk = particle.k*RotMatrix(-pi/2, 'y');
        case 2
            kk = particle.k*RotMatrix(-pi/2, 'x');
        case -2
            kk = particle.k*RotMatrix(pi/2, 'x');
        case 3
            kk = particle.k*RotMatrix(0, 'x');
        case -3
            kk = particle.k*RotMatrix(pi, 'x');
    end
    k0 = kk - [0, 0, 0.85] * dGX;
    vx = inParabolicFactor*hbar * k0(1) / mt;
    vy = inParabolicFactor*hbar * k0(2) / mt;
    
%     load dE.mat
%     pp = spline(dE(:,1),dE(:,2),abs(kk(3))); %#ok<*USENS>
%     vz = kk(3)/abs(kk(3))*pp;
    
    
    vz = inParabolicFactor*hbar * k0(3) / ml;
%     if abs(vx) > driftVelocity
%         vx = vx/abs(vx)*driftVelocity;
%     end
%     if abs(vy) > driftVelocity
%         vy = vy/abs(vy)*driftVelocity;
%     end
%     if abs(vz) > driftVelocity
%         vz = vz/abs(vz)*driftVelocity;
%     end
    vv = [vx, vy, vz];
    switch particle.valley
        case 1
            velocity = vv*RotMatrix(-pi/2, 'y');
        case -1
            velocity = vv*RotMatrix(pi/2, 'y');
        case 2
            velocity = vv*RotMatrix(pi/2, 'x');
        case -2
            velocity = vv*RotMatrix(-pi/2, 'x');
        case 3
            velocity = vv*RotMatrix(0, 'x');
        case -3
            velocity = vv*RotMatrix(-pi, 'x');
    end
    
end

% 随机选择指定能量的电子波矢
function [particle] = ChooseWaveVector(particle)
    % 
    Macro;
    
    n = 10; %椭球点密集程度
    energy = particle.energy/inParabolicFactor;
    rx = real(sqrt(2 * energy * mt) / hbar);
    ry = real(sqrt(2 * energy * mt) / hbar);
    rz = real(sqrt(2 * energy * ml) / hbar);
    [x1, y1, z1] = ellipsoid(0,0,0,rx,ry,rz,n);
    
    while true
        suiji_x = round(rand(1)*(n - 1)) + 1;
        suiji_y = round(rand(1)*(n - 1)) + 1;
        x = x1(suiji_x, suiji_y);
        y = y1(suiji_x, suiji_y);
        z = z1(suiji_x, suiji_y);
        kk = [x, y, z] + [0, 0,  0.85] * dGX;
        switch particle.valley
            case 1
                particle.k = kk*RotMatrix(-pi/2, 'y');
            case -1
                particle.k = kk*RotMatrix(pi/2, 'y');
            case 2
                particle.k = kk*RotMatrix(pi/2, 'x');
            case -2
                particle.k = kk*RotMatrix(-pi/2, 'x');
            case 3
                particle.k = kk*RotMatrix(0, 'x');
            case -3
                particle.k = kk*RotMatrix(-pi, 'x');
        end
        if double(max(abs(particle.k))/dGX) < 1.0
            break;
        end
    end
    
end






% 判断所在能谷
function [value] = WhichValley(electron)
    % electron:电子结构体
    
    [~, index] = max(abs(electron.k));
    item = electron.k(index) / abs(electron.k(index));
    value = index*item;
    
end

% 电子能带画图
function [energyGX] = eBandPlot(num)
    % num:k点数量
    Macro;
    Public;
    
    energyGX = zeros(num,2);
    k = linspace(0,1,num);
    elec = Electron;
    elec.valley = 1;
    for i = 1:num
        elec.k = [k(i) 0 0]*dGX;
        energyGX(i,1) = elec.k(1)/dGX;
        energyGX(i,2) = ComputeElecEnergy(elec)/e;
    end
    figure
    plot(energyGX(:,1),energyGX(:,2))
    xlabel("k/dGX")
    ylabel("Energy/(eV)")
    
end

% 判断是否超出第一布里渊区,并对波矢进行修正
function [particle] = Ifbeyondbz(particle,type)
    % particle:单个粒子结构体
    % type:0代表电子,其他代表声子
    Macro;
    
    switch type
        case 0
            if double(max(abs(particle.k)) / dGX) <= 1.0
                return;
            end
            particle.valley = WhichValley(particle);
            switch particle.valley
                case 1
                    particle.k(1) = particle.k(1) - 2*dGX;
                case -1
                    particle.k(1) = particle.k(1) + 2*dGX;
                case 2
                    particle.k(2) = particle.k(2) - 2*dGX;
                case -2
                    particle.k(2) = particle.k(2) + 2*dGX;
                case 3
                    particle.k(3) = particle.k(3) - 2*dGX;
                case -3
                    particle.k(3) = particle.k(3) + 2*dGX;
            end
            particle.valley = WhichValley(particle);
        otherwise
            if double(particle.q / bzR) > 1.0
                particle.k(1) = particle.k(1) - 2*dGX*particle.k(1) / particle.q;
                particle.k(2) = particle.k(2) - 2*dGX*particle.k(2) / particle.q;
                particle.k(3) = particle.k(3) - 2*dGX*particle.k(3) / particle.q;
            end
            particle.q = sqrt(sum(particle.k.^2));
    end
    
end

% 随机选择谷间散射后的能谷
function [value] = ChooseFinalValley(valley,type)
    % valley:电子所在能谷
    % type:谷间散射类型
    
    switch type
        case 'i'
            a = [1, -1, 2, -2, 3, -3];
            index = round(Random(0.5, 6.5));
            value = a(index);
        case 'f'
            valley = abs(valley);
            a = [2, -2, 3, -3];
            b = [1, -1, 3, -3];
            c = [1, -1, 2, -2];
            index = round(Random(0.5, 4.5));
            switch valley
                case 1
                    value = a(index);
                case 2
                    value = b(index);
                case 3
                    value = c(index);
            end
        case 'g'
            value = -1*valley;
    end
    
end

% 谷间散射末态波矢迭代选择,根据能量守恒
function [particle,phonon] = ChooseFinalK(particle,phonon,type1,type2,type3)
    % particle:电子结构体
    % phonon:声子结构体
    % type1:谷间散射类型
    % type2:吸收发射类型
    % type3:声子极化类型
    Macro;
    ScatterringCurve;
    
    maxitem = 20;
    allowedError = 0.1;
    item = 1;
    error = 1;
    % 谷间散射判断
    switch type1
        case 'f'
            qq = qf;
        case 'g'
            qq = qg;
    end
    % 吸收发射判断
    switch type2
        case 'ab'
            flag = 1;
        case 'em'
            flag = -1;
    end
    % 极化支判断
    switch type3
        case 'LA'
            hanshu = omegaLA;
        case 'TA'
            hanshu = omegaTA;
        case 'LO'
            hanshu = omegaLO;
        case 'TO'
            hanshu = omegaTO;
    end
    kStart = particle.k;
    frequency = double(subs(hanshu, qq));
    phononEnergy = double(hbar*frequency);
    particle.energy = particle.energy + flag*phononEnergy;
    particle.valley = ChooseFinalValley(particle.valley,type1);
    while item < maxitem && error > allowedError
        particle = ChooseWaveVector(particle);
        phonon.k = particle.k - kStart;
        phonon.q = sqrt(sum(phonon.k.^2));
        phonon = Ifbeyondbz(phonon,1);
        phonon.w = double(subs(hanshu, phonon.q));
        phonon.energy = double(hbar*phonon.w);
        error = abs((phonon.energy-phononEnergy)/phonon.energy);
        item = item + 1;
    end
    
end

% 电离杂质散射电子波矢的选择
function [particle] = ChooseFinalK2(particle)
    % 
    
    error = 0.1;
    nums = 20;
    
    velocity1 = particle.v;
    item1 = sqrt(sum(velocity1.^2));
    particle.valley = ChooseFinalValley(particle.valley,'i');
    for i = 1:nums
        particle = ChooseWaveVector(particle);
        particle.v = ComputeElecVelocity(particle);
        velocity2 = particle.v;
        item2 = sqrt(sum(velocity2.^2));
        theta = acos(sum(velocity1.*velocity2)/(item1*item2));
        situ1 = theta >pi/2 & theta < pi;
        situ2 = abs(item1 - item2)/item1;
        if situ1 && situ2 < error
            break;
        end
    end
    
    
    
end

% 针对不同散射类型计算电子声子散射过程
function [particle,phonon] = EscatP(type,particle,phonon)
    % type:散射类型
    % particle:某一电子结构体
    % phonon:声子存储变量
    Macro;
    ScatterringCurve;
    
    switch type
        case 1 % e-impurity
            particle.energy = particle.energy;
            particle = ChooseFinalK2(particle);
        case 2 % intra_LA
            particle.energy = particle.energy;
            particle = ChooseWaveVector(particle);
        case 3 % intra_TA
            particle.energy = particle.energy;
            particle = ChooseWaveVector(particle);
        case 4 % inter_g_ab_TA
            [particle,phonon] = ChooseFinalK(particle,phonon,'g','ab','TA');
            phonon.type = 1;
            phonon.polarization = 2;
            phonon.r = particle.r;
            phonon.time = particle.time;
        case 5 % inter_g_ab_LA
            [particle,phonon] = ChooseFinalK(particle,phonon,'g','ab','LA');
            phonon.type = 1;
            phonon.polarization = 1;
            phonon.r = particle.r;
            phonon.time = particle.time;
        case 6 % inter_g_ab_LO
            [particle,phonon] = ChooseFinalK(particle,phonon,'g','ab','LO');
            phonon.type = 1;
            phonon.polarization = 3;
            phonon.r = particle.r;
            phonon.time = particle.time;
        case 7 % inter_f_ab_TA
            [particle,phonon] = ChooseFinalK(particle,phonon,'f','ab','TA');
            phonon.type = 1;
            phonon.polarization = 2;
            phonon.r = particle.r;
            phonon.time = particle.time;
        case 8 % inter_f_ab_LA
            [particle,phonon] = ChooseFinalK(particle,phonon,'f','ab','LA');
            phonon.type = 1;
            phonon.polarization = 1;
            phonon.r = particle.r;
            phonon.time = particle.time;
        case 9 % inter_f_ab_TO
            [particle,phonon] = ChooseFinalK(particle,phonon,'f','ab','TO');
            phonon.type = 1;
            phonon.polarization = 4;
            phonon.r = particle.r;
            phonon.time = particle.time;
        case 10 % inter_g_em_TA
            [particle,phonon] = ChooseFinalK(particle,phonon,'g','em','TA');
            phonon.type = 0;
            phonon.polarization = 2;
            phonon.r = particle.r;
            phonon.time = particle.time;
        case 11 % inter_g_em_LA
            [particle,phonon] = ChooseFinalK(particle,phonon,'g','em','LA');
            phonon.type = 0;
            phonon.polarization = 1;
            phonon.r = particle.r;
            phonon.time = particle.time;
        case 12 % inter_g_em_LO
            [particle,phonon] = ChooseFinalK(particle,phonon,'g','em','LO');
            phonon.type = 0;
            phonon.polarization = 3;
            phonon.r = particle.r;
            phonon.time = particle.time;
        case 13 % inter_f_em_TA
            [particle,phonon] = ChooseFinalK(particle,phonon,'f','em','TA');
            phonon.type = 0;
            phonon.polarization = 2;
            phonon.r = particle.r;
            phonon.time = particle.time;
        case 14 % inter_f_em_LA
            [particle,phonon] = ChooseFinalK(particle,phonon,'f','em','LA');
            phonon.type = 0;
            phonon.polarization = 1;
            phonon.r = particle.r;
            phonon.time = particle.time;
        case 15 % inter_f_em_TO
            [particle,phonon] = ChooseFinalK(particle,phonon,'f','em','TO');
            phonon.type = 0;
            phonon.polarization = 4;
            phonon.r = particle.r;
            phonon.time = particle.time;
        case 16 % 
            return;
    end
    % 更新电子所在能谷
%     particle.valley = WhichValley(particle);
    
end

% 计算飞行时间
function [tf] = TimeForFly(GammaMax)
    % GammaMax:最大散射率
    
    tf = -log(Random(0.2,1)) / GammaMax;
    
end

% 单个电子飞行过程
function [electron] = FlyProcess(electron,tf)
    % electron:单个电子信息
    % tf:自由飞行时间
    Macro;
    
    % 自由飞行段
    electron.k(1) = electron.k(1) + (-e)*electricField*tf/hbar;
    electron = Ifbeyondbz(electron, 0);
    electron.valley = WhichValley(electron);
    electron.energy = ComputeElecEnergy(electron);
    electron.v = ComputeElecVelocity(electron);
    electron.r = electron.r + electron.v*tf;
    electron.time = electron.time + tf;
    
end

% 并行计算
function [phistory,electrons] = ParFunction(electrons)
    % electrons:电子信息结构体
    Public;
    
    num = size(electrons);
    phistory = repmat(Phonon, num(1), 1);
    parfor i = 1:num(1)
        % 散射段
        scatTable = ScatterringTable(electrons(i).energy);
        scatTableAll = cumsum(scatTable);
        type = ChooseScatType(scatTableAll);
        electrons(i).type = type;
        [electrons(i),phistory(i)] = EscatP(type,electrons(i),phistory(i));
        % 自由飞行段
        tf = TimeForFly(scatTableAll(end));
        electrons(i) = FlyProcess(electrons(i),tf);
    end
    
end

% 模拟电子运动
function [pHistory,eHistory,electrons] = SubsectionParllel(electrons,eHistory,pHistory)
    % electrons:电子信息结构体
    % eHistory:电子历史信息
    % pHistory:声子历史信息
    Macro;
    
    tic
    for k = 1:noFly
        % 飞行完成后保存电子信息
        [phistory,electrons] = ParFunction(electrons);
        eHistory(:,k) = electrons;
        pHistory(:,k) = phistory;
        % 输出计算进度
        ComputeProgress(k);
    end
    toc
    
end

% 输出计算进度
function [] = ComputeProgress(k)
    % k:当前计算飞行数
    Macro;
    
    if mod(k, noFly/100) == 0
        disp(['计算进度： ', num2str(k/noFly*100), '%']);
    end
    
end

%###########################
%######## 后处理部分 #########
%###########################

% 计算平均总飞行时间
function [totalTime] = TotalFlyTime(eHistory)
    % eHistory:电子历史信息
    Macro;
    
    time = zeros(SuperElecs, 1);
    for i = 1:SuperElecs
        time(i) = eHistory(i,end).time;
    end
    totalTime = sum(time)/SuperElecs;
    disp(['总模拟时间： ', num2str(totalTime), '  s']);
    
end

% 计算迁移率
function [miu] = ElectronMobility(eHistory)
    % eHistory:电子历史信息
    Macro;
    
    taon = zeros(SuperElecs,1);
    for i = 1:SuperElecs
        taon(i) = eHistory(i,end).time / noFly;
    end
    avetao = sum(taon)/SuperElecs;
    miu = e*avetao/md*1e4;
    disp(['电子迁移率为：', num2str(miu), '  cm^2/(V*s)']);
    
end

% % 计算漂移速度
% function [dirftvelocity] = ElectronDirftVelocity(eHistory)
%     % eHistory:电子历史信息
%     Macro;
%     
%     aveDirftv = zeros(SuperElecs,1);
%     for i = 1:SuperElecs
%         xdisplace = zeros(noFly,1);
%         time = zeros(noFly,1);
%         for j = 1:noFly
%             xdisplace(j) = eHistory(i,j).r(1);
%             time(j) = eHistory(i,j).time;
%         end
%         p = polyfit(time,xdisplace,1);
%         aveDirftv(i) = p(1);
%     end
%     dirftvelocity = sum(aveDirftv)/SuperElecs;
%     disp(['电子漂移速度为：', num2str(dirftvelocity), '  m/s']);
%     
% end

% 计算漂移速度
function [dirftvelocity] = ElectronDirftVelocity(eHistory)
    % eHistory:电子历史信息
    Macro;
    
    avevelocity = zeros(SuperElecs,1);
    for i = 1:SuperElecs
        velocity = 0;
        for j = 1:noFly
            velocity = velocity + eHistory(i,j).v(1);
        end
        avevelocity(i) = velocity/noFly;
    end
    dirftvelocity = sum(avevelocity)/SuperElecs;
    disp(['电子漂移速度为：', num2str(dirftvelocity*100), '  cm/s']);
    
end

% 漂移速度随时间变化
function [] = DirftVelocityToTime(eHistory)
    % 
    Macro;
    
%     tMax = TotalFlyTime(eHistory);
    tMax = 1e-11;
    tgrid = MeshGrid(0, tMax, Nt);
    
    
    velocity = zeros(SuperElecs,noFly);
    times = zeros(SuperElecs,noFly);
    for i = 1:SuperElecs
        for j = 1:noFly
            velocity(i,j) = eHistory(i,j).v(1);
            times(i,j)  = eHistory(i,j).time;
        end
    end
    
    aveVelocity = zeros(Nt,2);
    for t = 1:Nt
        Velocity = 0;
        num = 0;
        for i = 1:SuperElecs
            index = find(tgrid.face(t) <= times(i,:),1);
            if isempty(index)
                index = noFly;
%                 continue;
            end
            num = num + 1;
            Velocity = Velocity + sum(velocity(i,1:index))/index;
        end
        aveVelocity(t,1) = tgrid.point(t+1);
        aveVelocity(t,2) = Velocity / num;
    end
    figure
%     slg = semilogy(aveVelocity(:,1)*1e12,aveVelocity(:,2)*100);
    slg = plot(aveVelocity(:,1)*1e12,aveVelocity(:,2)*100);
    slg.LineWidth = 2;
    xlabel('ps');ylabel('cm/s');
    legend("drift velocity")
    
end

% 散射种类分布
function [] = ScatTypeDistribution(eHistory)
    % 
    Macro;
    
    numbers = zeros(4,2);
    for i = 1:SuperElecs
        types = [eHistory(i,:).type];
        % 电离杂质散射
        index1 = types == 1;
        % 声学波形变势散射
        index2 = types >=2 & types <=3;
        % f型吸收声子谷间散射
        index3 = types >=7 & types <=9;
        % f型发射声子谷间散射
        index4 = types >=13 & types <=15;
        % g型吸收声子谷间散射
        index5 = types >=4 & types <=6;
        % g型发射声子谷间散射
        index6 = types >=10 & types <=12;
        
        numbers(1,1) = numbers(1,1) + sum(double(index1));
        numbers(2,1) = numbers(2,1) + sum(double(index2));
        numbers(3,1) = numbers(3,1) + sum(double(index3));
        numbers(3,2) = numbers(3,2) + sum(double(index4));
        numbers(4,1) = numbers(4,1) + sum(double(index5));
        numbers(4,2) = numbers(4,2) + sum(double(index6));
    end
    numbers = numbers/(SuperElecs*noFly);
    figure
    bar(numbers,'stacked')
    
end


% 电子能量分布
function [enumber] = ElectronEnergyDistribution(eMin,eMax,enum,eHistory)
    % eMin:能量下限
    % eMax:能量上限
    % enum:能量区间划分数
    % eHistory:电子历史信息
    Macro;
    
    egrid = MeshGrid(eMin, eMax, enum);
    energys = zeros(SuperElecs*noFly,1);
    for i = 1:SuperElecs
        for j = 1:noFly
            energys(j+(i-1)*noFly) = eHistory(i,j).energy/e;
        end
    end
    enumber = zeros(enum,2);
    for i = 1:enum
        index = energys >= egrid.face(i) & energys < egrid.face(i+1);
        enumber(i,1) = egrid.point(i+1);
        enumber(i,2) = sum(double(index));
    end
    figure
    bar(enumber(:,1), enumber(:,2));
    xlabel('electron energy(eV)');
    legend('Electron Energy Distribution');
    
end

% 验证内容
function [] = VerifyProgram(type)
    % type:验证类型
    Macro;
    Public;
    
    switch type
        case 1
            nums = 200;
            error = 0.001;
            elec = Electron;
            for i = 1:nums
                elec.k = [rand(1) rand(1) rand(1)]*dGX;
                elec.valley = WhichValley(elec);
                elec.energy = ComputeElecEnergy(elec);
                item = elec.energy;
                elec = ChooseWaveVector(elec);
                elec.energy = ComputeElecEnergy(elec);
                if abs((elec.energy - item)/item) > error
                    disp("能量正反验证错误！出错电子信息为：")
                    ElectronInformation(elec);
                    break;
                end
            end
            if i == nums
                disp("电子波矢选择与能量计算正反验证无误")
            end
    end
    
    
end

% 显示电子信息
function [] = ElectronInformation(electron)
    % electron:电子结构体
    Macro;
    
    disp(['电子所在位置为：', num2str(electron.r(1)*1e9), '  nm'])
    disp(['电子所在时刻为：', num2str(electron.time*1e12), '  ps'])
    disp(['波矢相对大小为：', num2str(electron.k/dGX)])
    disp(['电子所在能谷为：', num2str(electron.valley)])
    disp(['电子能量为：', num2str(electron.energy/e), '  eV'])
    
end

% 单电子轨迹图
function [] = ElectronTrace(eHistory,num,name)
    % eHistory:电子历史信息
    % num:超电子序号
    % name:画图类型
    Macro;
    
    switch name
        case 'k'
            k = zeros(noFly,3);
            times = zeros(noFly,1);
            for i = 1:noFly
                times(i) = eHistory(num,i).time;
                k(i,:) = eHistory(num,i).k;
            end
            figure
            plot3(k(:,1),k(:,2),k(:,3),'*')
            xlabel('kx');ylabel('ky');zlabel('kz');
            legend("k-space")
        case 'r'
            positions = zeros(noFly,1);
            times = zeros(noFly,1);
            for i = 1:noFly
                times(i) = eHistory(num,i).time;
                positions(i) = eHistory(num,i).r(1);
            end
            figure
            plot(times*1e12,positions*1e9,'-')
            xlabel('ps');ylabel('nm');
            legend("real-space")
        case 'e'
            positions = zeros(noFly,1);
            energys = zeros(noFly,1);
            for i = 1:noFly
                positions(i) = eHistory(num,i).r(1);
                energys(i) = eHistory(num,i).energy;
            end
            figure
            plot(positions*1e9,energys/e,'-')
            xlabel('nm');ylabel('eV');
            legend("electron energy")
    end
    
end

% 求电子平均能量随时间的变化关系图
function [aveEnergy] = AverageEnergyTime(eHistory)
    % grid:网格结构体
    % eHistory:电子历史信息
    Macro;
    
%     tMax = TotalFlyTime(eHistory);
    tMax = 0.5e-11;
    tgrid = MeshGrid(0, tMax, Nt);
    aveEnergy = zeros(Nt,2);
    
    energy = zeros(SuperElecs,noFly);
    times = zeros(SuperElecs,noFly);
    for i = 1:SuperElecs
        for j = 1:noFly
            energy(i,j) = eHistory(i,j).energy;
            times(i,j)  = eHistory(i,j).time;
        end
    end
    
    for t = 1:Nt
        Energy = 0;
        num = 0;
        for i = 1:SuperElecs
            index = find(tgrid.face(t) <= times(i,:),1);
            if isempty(index)
                continue;
            end
            num = num + 1;
            Energy = Energy + energy(i,index);
        end
        aveEnergy(t,1) = tgrid.point(t+1);
        aveEnergy(t,2) = Energy / (num*e);
    end
    figure
%     slg = semilogy(aveEnergy(:,1)*1e12,aveEnergy(:,2));
    slg = plot(aveEnergy(:,1)*1e12,aveEnergy(:,2));
    slg.LineWidth = 2;
    xlabel('ps');ylabel('eV');
    legend("average elevtron energy")
    
end

% 统计各个频率段的声子群
function [frequency,phonons] = StatisticPhonon(grid,pHistory)
    % grid:网格
    % pHistory:声子历史信息
    Macro;
    Public;
    
    frequency = repmat(Frequency, NW, 1);
    wPhonon = zeros(SuperElecs*noFly,1);
    times = zeros(SuperElecs*noFly,1);
    polars = zeros(SuperElecs*noFly,1);
    types = zeros(SuperElecs*noFly,1);
    phonons = repmat(Phonon,SuperElecs*noFly,1);
    % 提取声子信息
    for i = 1:SuperElecs
        wPhonon((i-1)*noFly+1:i*noFly) = deal([pHistory(i,:).w]');
        times((i-1)*noFly+1:i*noFly)   = deal([pHistory(i,:).time]');
        types((i-1)*noFly+1:i*noFly)   = deal([pHistory(i,:).type]');
        polars((i-1)*noFly+1:i*noFly)  = deal([pHistory(i,:).polarization]');
        phonons((i-1)*noFly+1:i*noFly) = deal(pHistory(i,:)');
    end
    % index1用于剔除零值
    index1 = polars ~= 0;
    % index2用于筛选发射声子
    index2 = types == 0;
    for k = 1:NW
        index3 = wPhonon > grid.w.face(k) & wPhonon < grid.w.face(k+1);
        index = index1 & index2 & index3;
        % frequency(k).pop中存储单个频率段对应的声子群在pHistory中的标号
        frequency(k).pop = find(index);
        % frequency(k).num中存储单个频率段对应的声子数目
        frequency(k).num = length(frequency(k).pop);
    end

end

% 求声子发射谱
function [wNum] = PhononEmSpectrum(grid,frequency)
    % grid:网格
    % frequency:声子统计信息
    Macro;
    
    wNum = zeros(NW,2);
    for k = 1:NW
        wNum(k,1) = frequency(k).num;
        wNum(k,2) = hbar*grid.w.point(k+1)/e*1000;
    end
    figure
    slg = plot(wNum(:,1),wNum(:,2));
    slg.LineWidth = 2;
    xlabel('.a.u');ylabel('meV');
    legend("phonon emission numbers")
    
end

% 输出dat文件
function [] = Write2datFile(name,xname,yname,xvalue,yvalue)
    % name:文件名
    % xname:横坐标名称
    % yname:纵坐标名称
    % xvalue:横轴变量值
    % yvalue:纵轴变量值
    Macro;
    
    fid = fopen(name, 'w+');
    fprintf(fid, '%s%s%s%s\n', 'variables = ', xname, " ", yname);
    
    for k = 1:length(xvalue)
        fprintf(fid, '%.2f\t', xvalue(k));
        fprintf(fid, '%.2f\n', yvalue(k));
    end
    fclose(fid);
    
end

% 电子热运动速度根据Maxwell分布计算
function [value] = MaxwellVelocity()
    Macro;
    
    f = @(vv) DopDensity*(m/(2*pi*kb*T))^(3/2)*exp(-m*vv.^2/(2*kb*T));
    fMax = f(0);
    fx = 0;
    fC = 1;
    while fx <= fC
        fC = fMax*rand(1);
        velocity = rand(1)*driftVelocity;
        fx = f(velocity);
    end
    phi = Random(0,pi);
    theta = Random(0,2*pi);
    vz = velocity*cos(phi);
    vx = velocity*sin(phi)*cos(theta);
    vy = velocity*sin(phi)*sin(theta);
    value = [vx, vy, vz];
    
end

% Maxwell分布画图
function [] = PlotMaxwell(vMin,vMax,num1,num2)
    % vMin:速度区间最小值
    % vMax:速度区间最大值
    % num1:统计数量
    % num2:速度区间划分数量
    
    v = zeros(num1,1);
    vnum = zeros(num2,1);
    vgrid = MeshGrid(vMin, vMax, num2);
    for i = 1:num1
        item = MaxwellVelocity();
        v(i) = sqrt(sum(item.^2));
    end
    for i = 1:num2
        index = v >= vgrid.face(i) & v < vgrid.face(i+1);
        vnum(i) = sum(double(index));
    end
    vpa(sum(v)/num1,3)
    figure
    bar(vgrid.point(2:num2+1), vnum);
    xlabel('electron velocity(m/s)');
    legend('Maxwell Velocity Distribution');
    
end
























