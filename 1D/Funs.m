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
    Funs.GaussDopDensity           = @GaussDopDensity;
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
    Funs.eBand                     = @eBand;
    Funs.Ifbeyondbz                = @Ifbeyondbz;
    Funs.SearchEfield              = @SearchEfield;
    Funs.ChooseFinalValley         = @ChooseFinalValley;
    Funs.ChooseFinalK              = @ChooseFinalK;
    Funs.EscatP                    = @EscatP;
    Funs.TimeForFly                = @TimeForFly;
    Funs.EnergyDecayArray            = @EnergyDecayArray;
    Funs.Localization              = @Localization;
    Funs.FlyProcess                = @FlyProcess;
    Funs.ParFunction               = @ParFunction;
    Funs.SubsectionParllel         = @SubsectionParllel;
    % 后处理部分
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 预处理部分 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  1  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 说明：可使用VASP计算色散关系
% (1)使用的是拟合的二阶色散关系;
% (2)考虑了U散射/边界散射;
% (3)使用spline插值;

% 求态密度表/群速度表/弛豫时间
function [gv, dos, tao] = GroupVelocityDOSTao(grid)
    % grid:网格结构体
    Macro;
    Public;
    ScatterringCurve;

    dos = Polar;
    tao = Polar;
    gv  = Polar;
    % 初始化
    tao.LA = zeros(NW+2,1);
    tao.TA = zeros(NW+2,1);
    tao.LO = zeros(NW+2,1);
    tao.TO = zeros(NW+2,1);
    dos.LA = zeros(NW+2,1);
    dos.TA = zeros(NW+2,1);
    dos.LO = zeros(NW+2,1);
    dos.TO = zeros(NW+2,1);
    gv.LA  = zeros(NW+2,1);
    gv.TA  = zeros(NW+2,1);
    gv.LO  = zeros(NW+2,1);
    gv.TO  = zeros(NW+2,1);
    % 计算群速度表/态密度表
    GroupvLA = diff(omegaLA,q,1);
    GroupvTA = diff(omegaTA,q,1);
    GroupvLO = diff(omegaLO,q,1);
    GroupvTO = diff(omegaTO,q,1);
    wLA = double(abs(vpa(subs(omegaLA ,q,[grid.q.point]))));
    wTA = double(abs(vpa(subs(omegaTA ,q,[grid.q.point]))));
    wLO = double(abs(vpa(subs(omegaLO ,q,[grid.q.point]))));
    wTO = double(abs(vpa(subs(omegaTO ,q,[grid.q.point]))));
    vLA = double(abs(vpa(subs(GroupvLA,q,[grid.q.point]))));
    vTA = double(abs(vpa(subs(GroupvTA,q,[grid.q.point]))));
    vLO = double(abs(vpa(subs(GroupvLO,q,[grid.q.point]))));
    vTO = double(abs(vpa(subs(GroupvTO,q,[grid.q.point]))));
    for k = 1:NW+2
        if grid.w.point(k) >= wMinLA && grid.w.point(k) <= wMaxLA
            gv.LA(k) = spline(wLA,vLA,grid.w.point(k));
            dos.LA(k) = 3*grid.w.point(k)^2 / (2*pi^2*gv.LA(k)^3);
        end
        if grid.w.point(k) >= wMinTA && grid.w.point(k) <= wMaxTA
            gv.TA(k) = spline(wTA,vTA,grid.w.point(k));
            dos.TA(k) = 3*grid.w.point(k)^2 / (2*pi^2*gv.TA(k)^3);
        end
        if grid.w.point(k) >= wMinLO && grid.w.point(k) <= wMaxLO
            gv.LO(k) = spline(wLO,vLO,grid.w.point(k));
            dos.LO(k) = 3*grid.w.point(k)^2 / (2*pi^2*gv.LO(k)^3);
        end
        if grid.w.point(k) >= wMinTO && grid.w.point(k) <= wMaxTO
            gv.TO(k) = spline(wTO,vTO,grid.w.point(k));
            dos.TO(k) = 3*grid.w.point(k)^2 / (2*pi^2*gv.TO(k)^3);
        end 
    end
    % 弛豫时间
    invTaou = zeros(NW+2,1);
    invTaob = zeros(NW+2,1);
    for i = 1:NW+2
        invSumTao = 0;
        if gv.LA(i) ~= 0
            % Umklapp Scattering
            invTaou(i) = 2*gammaG^2*kb*T*grid.w.point(i)^2/(miu*V0*omegaD);
            % Boundary Scattering
            invTaob(i) = gv.LA(i)/mLength;
            % Combined
            invSumTao = invSumTao + invTaou(i) + invTaob(i);
            tao.LA(i) = 1/invSumTao;
        end
        invSumTao = 0;
        if gv.TA(i) ~= 0
            % Umklapp Scattering
            invTaou(i) = 2*gammaG^2*kb*T*grid.w.point(i)^2/(miu*V0*omegaD);
            % Boundary Scattering
            invTaob(i) = gv.TA(i)/mLength;
            % Combined
            invSumTao = invSumTao + invTaou(i) + invTaob(i);
            tao.TA(i) = 1/invSumTao;
        end
        invSumTao = 0;
        if gv.LO(i) ~= 0
            % Umklapp Scattering
            invTaou(i) = 2*gammaG^2*kb*T*grid.w.point(i)^2/(miu*V0*omegaD);
            % Boundary Scattering
            invTaob(i) = gv.LO(i)/mLength;
            % Combined
            invSumTao = invSumTao + invTaou(i) + invTaob(i);
            tao.LO(i) = 1/invSumTao;
        end
        invSumTao = 0;
        if gv.TO(i) ~= 0
            % Umklapp Scattering
            invTaou(i) = 2*gammaG^2*kb*T*grid.w.point(i)^2/(miu*V0*omegaD);
            % Boundary Scattering
            invTaob(i) = gv.TO(i)/mLength;
            % Combined
            invSumTao = invSumTao + invTaou(i) + invTaob(i);
            tao.TO(i) = 1/invSumTao;
        end
    end
    tao.LA(1) = tao.LA(2);
    tao.LA(NW+2) = tao.LA(NW+1);
    tao.TA(1) = tao.TA(2);
    tao.TA(NW+2) = tao.TA(NW+1);
    tao.LO(1) = tao.LO(2);
    tao.LO(NW+2) = tao.LO(NW+1);
    tao.TO(1) = tao.TO(2);
    tao.TO(NW+2) = tao.TO(NW+1);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  2  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 说明：
% (1)一维网格划分;
% (2)分段计算是为了及时保存计算数据;

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
    % 无输入
    Macro;
    Public;
    
    grid = Allgrid;
    grid.w = MeshGrid(wMin, wMax, NW);% 频率
    grid.q = MeshGrid(qMin, qMax, NQ);% 波矢
    grid.x = MeshGrid(xMin, xMax, NX);% 位置
    grid.t = MeshGrid(tMin, tMax, Nt);% 时间
    
end

% 构造分段计算索引表
function [kArray] = Karray()
    % noFly:单个电子的飞行次数
    % deltak:按deltak间隔对飞行次数进行划分
    Macro;
    
    nok = floor(noFly/deltaFly);
    modnok = mod(noFly,deltaFly);
    if modnok == 0
        kArray = zeros(nok,2);
        for i = 1:nok
            kArray(i,1) = deltaFly*(i-1)+1;
            kArray(i,2) = deltaFly*i;
        end
    else
        kArray = zeros(nok+1,2);
        for i = 1:nok
            kArray(i,1) = deltaFly*(i-1)+1;
            kArray(i,2) = deltaFly*i;
        end
        kArray(nok+1,1) = deltaFly*nok+1;
        kArray(nok+1,2) = noFly;
    end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  3  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 说明：散射表的计算参数与材料密切相关
% (1)设定EnergyCut,只有能量高于该值的电子才能发射声子,否则发射型散射率为0;
% (2)模拟过程中所使用的电子能量,均以第一导带底为能量零点;
% (3)slefScatRate决定了自散射的大小,它可以看作一个过渡散射类型,作用同电离杂质散射;

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
    
    if energy >= EnergyCut
        flag = 1;
    else
        flag = 0;
    end
    
    % 三种散射的句柄函数
    % e-impurity
    P_impurity = @(epsilon, nI) 2^(5/2)*pi*nI*Z^2*e^4/(kappa^2*(hbar^2*Beta^2/(2*m))^2*md^(1/2))*...
                                epsilon.^(1/2)./(1+4*epsilon./(hbar^2*Beta^2/(2*m)))*0.1;
    % intravalley
    P_intra = @(epsilon, D, u) 2^(1/2)*md^(3/2)*kb*T*D^2/(pi*hbar^4*u^2*rou)*epsilon.^(1/2);
    % intervalley
    P_inter_ab = @(epsilon, DK, Zf, wi) DK^2*md^(3/2)*Zf/(2^(1/2)*pi*rou*hbar^3*wi)*...
                                        (1/(exp(hbar*wi/(kb*T))-1))*(epsilon+hbar*wi).^(1/2);
    P_inter_em = @(epsilon, DK, Zf, wi) DK^2*md^(3/2)*Zf/(2^(1/2)*pi*rou*hbar^3*wi)*...
                                        (1+1/(exp(hbar*wi/(kb*T))-1))*(epsilon-hbar*wi).^(1/2)*flag;
    
    % 计算散射率
    scatTable = zeros(nofScat,1);
    scatTable(1) = P_impurity(energy, heavyDopDensity);
    scatTable(2) = P_intra(energy, DLA, ul);
    scatTable(3) = P_intra(energy, DTA, ut);
    scatTable(4) = P_inter_ab(energy, gDKTA, 1, double(subs(omegaTA, qg)));
    scatTable(5) = P_inter_ab(energy, gDKLA, 1, double(subs(omegaLA, qg)));
    scatTable(6) = P_inter_ab(energy, gDKLO, 1, double(subs(omegaLO, qg)));
    scatTable(7) = P_inter_ab(energy, fDKTA, 4, double(subs(omegaTA, qf)));
    scatTable(8) = P_inter_ab(energy, fDKLA, 4, double(subs(omegaLA, qf)));
    scatTable(9) = P_inter_ab(energy, fDKTO, 4, double(subs(omegaTO, qf)));
    scatTable(10)= P_inter_em(energy, gDKTA, 1, double(subs(omegaTA, qg)));
    scatTable(11)= P_inter_em(energy, gDKLA, 1, double(subs(omegaLA, qg)));
    scatTable(12)= P_inter_em(energy, gDKLO, 1, double(subs(omegaLO, qg)));
    scatTable(13)= P_inter_em(energy, fDKTA, 4, double(subs(omegaTA, qf)));
    scatTable(14)= P_inter_em(energy, fDKLA, 4, double(subs(omegaLA, qf)));
    scatTable(15)= P_inter_em(energy, fDKTO, 4, double(subs(omegaTO, qf)));
    
end

% 散射率画图
function [] = PlotScatterringRate(energy)
    % energy:电子能量列表
    Macro;
    
    scatTable = zeros(length(energy),nofScat);
    for i = 1:length(energy)
        scatTable(i,:) = deal(ScatterringTable(energy(i))');
    end
    figure
    for j = 1:nofScat
        slg = semilogy(energy/e*1000, scatTable(:,j));
        slg.LineWidth = 3;
        hold on
    end
    legend("e-impurity","intra LA","intra TA","inter g ab TA","inter g ab LA",...
           "inter g ab LO","inter f ab TA","inter f ab LA","inter f ab TO",...
           "inter g em TA","inter g em LA","inter g em LO","inter f em TA",...
           "inter f em LA","inter f em TO")
    xlabel('meV');
    ylabel('s^{-1}')
    
end

% 计算散射类型
function [type] = ChooseScatType(energy)
    % energy:电子能量值
    Macro;
    
    scatTable = ScatterringTable(energy);
    scatTableAll = cumsum(scatTable);
    scatTableAll(nofScat+1) = slefScatRate*scatTableAll(nofScat);
    
    r = rand(1)*scatTableAll(end);
    type = find(scatTableAll > r, 1);
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  4  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 说明：该部分信息可以使用Atlas的输出数据
% (1)dopDensity和ne均是(NX+2)行(1)列的向量;
% (2)掺杂浓度在交界面上的分布可以按Guass分布等;
% (3)可以在不同掺杂区设置不同超电子数，对应的电荷量也要重新计算;

% 生成掺杂浓度向量
function [dopDensity] = GaussDopDensity()
    Macro;
    
    dopDensity = zeros(NX+2,1);
    % 重掺杂区域
    numd1 = d1/deltax;
    for i = 2:numd1
        dopDensity(i+1) = heavyDopDensity;
    end
    % 轻掺杂区域
    numd2 = d2/deltax/2;
    for i = 2:numd2
        dopDensity(numd1+1+i) = lightDopDensity;
    end
    % 取对称
    for i = 1:NX/2+1
        dopDensity(NX+3-i) = dopDensity(i);
    end
    dopDensity(1) = dopDensity(2);
    dopDensity(NX+2) = dopDensity(NX+1);
    
end

% 掺杂/电子浓度画图
function [] = PlotDensity(grid,Density,name)
    % grid:网格
    % dopDensity:掺杂浓度向量
    Macro;
    
    % 掺杂浓度随x变化关系图
    if NX+2 == length(Density)
        figure
        slg = semilogy(grid.x.point(:)*1e9, Density, '-');
        slg.LineWidth = 5;
        xlabel('nm');
        ylabel('m^3');
        legend(name);
    else
        disp("数组大小不一致！")
    end
    
end

% 根据掺杂浓度分布计算超电子电荷量
function [lightCharge,heavyCharge] = ComputeSuperCharge(dopDensity)
    % dopDensity:掺杂浓度向量
    Macro;
    
    % 轻掺杂部分
    sumNum = 0;
    index = d1/deltax + 1;
    for i = 1:NGate
        sumNum = sumNum + dopDensity(index+i)*deltax;
    end
    lightCharge = e*sumNum/lightSuperElecs;
    % 重掺杂部分
    sumNum = 0;
    for i = 1:(d1/deltax)
        sumNum = sumNum + dopDensity(i+1)*deltax;
    end
    heavyCharge = e*sumNum/heavySuperElecs;
    
end

% 计算某一时刻电子浓度
function [ne] = ComputeNe(grid,eHistory,time)
    % grid:网格结构体
    % eHistory:电子历史信息结构体
    % time:某一时刻
    Macro;
    
    ne = zeros(NX+2,1);
    for i = 1:NX
        sumNum = 0;
        position = zeros(noFly+1,1);
        times = zeros(noFly+1,1);
        for k = 1:sumSuperElecs
            for j = 1:noFly+1
                position(j) = eHistory(k,j).r(1);
                times(j)  = eHistory(k,j).time;
            end
            index1 = position >= grid.x.face(i) & position < grid.x.face(i+1);
            index2 = times >= time;
            index3 = index1 & index2;
            index = find(index3,1);
            if isempty(index)
                continue;
            end
            sumNum = sumNum + eHistory(k,index).charge/e;
        end
        ne(i+1) = sumNum;
    end
    ne(1) = ne(2);
    ne(NX+2) = ne(NX+1);
    
end

% 读取电子浓度文件
function [ne] = ElectronConc(grid,Eleconc)
    % grid:网格结构体
    % Eleconc:电子浓度信息
    Macro;
    
    % 转化为国际量纲
    Eleconc(:,1) = 1e-6*Eleconc(:,1);
    Eleconc(:,3) = 1e6*Eleconc(:,3);
    
    ne = zeros(NX+2,1);
    xf = Eleconc(2:3:end,1);
    xf(end+1) = mLength;
    eleConc = Eleconc(2:3:end,3);
    eleConc(end+1) = eleConc(end);
    for i = 1:NX+2
        ne(i) = spline(xf,eleConc,grid.x.point(i));
    end
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  5  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 说明：初始化相关函数
% (1)初始电子群速度按Maxwell分布计算,初始能量按定值;
% (2)Maxwell分布是一个概率分布,群速度分布符合该分布曲线,采用rejection方法来实现;
% (3)在等能椭球面上随机选取电子波矢,但要注意波矢长度不能超出第一布里渊区;

% 随机在某区域上生成电子
function [particle] = GenerateElectron(lb,rb,charge,energy)
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
    % 超电子电荷量
    particle.charge = charge;
    % 随机生成能谷
    valleys = [1 -1 2 -2 3 -3];
    index = round(Random(0.5, 6.5));
    particle.valley = valleys(index);
    % 随机生成波矢
    particle = Choosek(particle);
    % 随机生成初始速度
    particle.v = MaxwellVelocity();
    
end

% 电子热运动速度根据Maxwell分布计算
function [value] = MaxwellVelocity()
    % x：电子x方向位置
    % dopDensity：掺杂浓度信息向量
    Macro;
    
    f = @(vv) heavyDopDensity*(m/(2*pi*kb*T))^(3/2)*exp(-m*vv.^2/(2*kb*T));
    fMax = f(0);
    fx = 0;
    fC = 1;
    while fx <= fC
        C = rand(1);
        fC = fMax*C;
        velocity = rand(1)*4e5;
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
function [] = PlotMaxwell(vMin,vMax,num)
    % vMin:速度区间最小值
    % vMax:速度区间最大值
    % num:划分数量
    
    v = zeros(num,1);
    vnum = zeros(num,1);
    vgrid = MeshGrid(vMin, vMax, num);
    for i = 1:num
        item = MaxwellVelocity();
        v(i) = sqrt(sum(item.^2));
    end
    for i = 1:num
        index = v >= vgrid.face(i) & v < vgrid.face(i+1);
        vnum(i) = sum(double(index));
    end
    figure
    bar(vgrid.point(2:num+1), vnum);
    xlabel('electron velocity(m/s)');
    legend('Maxwell Velocity Distribution');
    
end

% 随机选择指定能量的电子波矢
function [particle] = Choosek(particle)
    % particle:某一电子结构体
    Macro;

    n = 10; %椭球点密集程度
    particle.energy = particle.energy;
    % 不清楚那里会导致能量为负值，需要加个real取实部
    rx = real(sqrt(2 * particle.energy * mt) / hbar);
    ry = real(sqrt(2 * particle.energy * mt) / hbar);
    rz = real(sqrt(2 * particle.energy * ml) / hbar);
    [x1, y1, z1] = ellipsoid(0,0,0,rx,ry,rz,n);
    
    while true
        suiji_x = round(rand(1)*(n - 1)) + 1;
        suiji_y = round(rand(1)*(n - 1)) + 1;
        x = x1(suiji_x, suiji_y);
        y = y1(suiji_x, suiji_y);
        z = z1(suiji_x, suiji_y);
        switch particle.valley %加在长轴方向上
            case 1
                particle.k = [z, x, y] + [ 0.85, 0, 0] * dGX;
            case -1
                particle.k = [z, x, y] + [-0.85, 0, 0] * dGX;
            case 2
                particle.k = [x, z, y] + [0,  0.85, 0] * dGX;
            case -2
                particle.k = [x, z, y] + [0, -0.85, 0] * dGX;
            case 3
                particle.k = [x, y, z] + [0, 0,  0.85] * dGX;
            case -3
                particle.k = [x, y, z] + [0, 0, -0.85] * dGX;
        end
        if double(max(abs(particle.k))/dGX) < 1.0
            break;
        end
    end

end

% 返回一个在a和b之间的随机数
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
function [electrons] = InitializeInfor(electrons,lightCharge,heavyCharge)
    % electrons:电子信息结构体
    % lightCharge:轻掺杂超电子电荷量
    % heavyCharge:重掺杂超电子电荷量
    Macro;
    
    % electrons中分三段存储超电子
    subscript0 = 1;
    subscript1 = lightSuperElecs;
    subscript2 = heavySuperElecs/2 + lightSuperElecs;
    subscript3 = sumSuperElecs;
    % 生成栅极超电子
    for i = subscript0:subscript1
        electrons(i) = GenerateElectron(d1,d1+d2,lightCharge,EnergyInit);
    end
    % 生成源极超电子
    for i = subscript1+1:subscript2
        electrons(i) = GenerateElectron(0,d1,heavyCharge,EnergyInit);
    end
    % 生成漏极超电子
    for i = subscript2+1:subscript3
        electrons(i) = GenerateElectron(d1+d2,d1+d2+d3,heavyCharge,EnergyInit);
    end
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 计算模拟部分 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

% 电子能带计算
function [value] = eBand(particle,type)
    % particle:单个粒子结构体
    % type:0代表能量计算，其他为速度计算
    Macro;

    switch particle.valley
        case 1
            k0 = particle.k - [0.85, 0, 0] * dGX;
            kx0 = k0(2); ky0 = k0(3); kz0 = k0(1);
            mx = ml;my = mt;mz = mt;
        case -1
            k0 = particle.k - [-0.85, 0, 0] * dGX;
            kx0 = k0(2); ky0 = k0(3); kz0 = k0(1);
            mx = ml;my = mt;mz = mt;
        case 2
            k0 = particle.k - [0, 0.85, 0] * dGX;
            kx0 = k0(1); ky0 = k0(3); kz0 = k0(2);
            mx = mt;my = ml;mz = mt;
        case -2
            k0 = particle.k - [0, -0.85, 0] * dGX;
            kx0 = k0(1); ky0 = k0(3); kz0 = k0(2);
            mx = mt;my = ml;mz = mt;
        case 3
            k0 = particle.k - [0, 0, 0.85] * dGX;
            kx0 = k0(1); ky0 = k0(2); kz0 = k0(3);
            mx = mt;my = mt;mz = ml;
        case -3
            k0 = particle.k - [0, 0, -0.85] * dGX;
            kx0 = k0(1); ky0 = k0(2); kz0 = k0(3);
            mx = mt;my = mt;mz = ml;
    end

    if type == 0
        value = hbar^2*(kx0^2 / mt + ky0^2 / mt + kz0^2 / ml) / 2;
    else
        vx = hbar * k0(1) / mx;
        vy = hbar * k0(2) / my;
        vz = hbar * k0(3) / mz;
        value = [vx, vy, vz];
    end
    
end

% 判断是否超出第一布里渊区,并对波矢进行修正
function [particle] = Ifbeyondbz(particle,type)
    % particle:单个粒子结构体
    % type:0代表电子,其他代表声子
    Macro;

    if type == 0
        if double(max(abs(particle.k)) / dGX) <= 1.0
            return;
        end
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
        particle.valley = -1*particle.valley;
    else
        if double(particle.q / bzR) > 1.0
            particle.k(1) = particle.k(1) - 2*dGX*particle.k(1) / particle.q;
            particle.k(2) = particle.k(2) - 2*dGX*particle.k(2) / particle.q;
            particle.k(3) = particle.k(3) - 2*dGX*particle.k(3) / particle.q;
        end
        particle.q = sqrt(sum(particle.k.^2));
    end

end

% 计算任意位置电场强度
function [Efield] = SearchEfield(x,XeField)
    % x:横坐标
    % XeField:电场向量
    Macro;
    
    % 转化为国际量纲
    XeField(:,1) = 1e-6*XeField(:,1);
    XeField(:,3) = 100*XeField(:,3);
    % 提取电场数据
    xf = XeField(2:3:end,1);
    xf(end+1) = mLength;
    xeField = XeField(2:3:end,3);
    xeField(end+1) = xeField(end);
    indexX = find(x <= xf,1);
    Efield = xeField(indexX);
    
end

% 随机选择散射后的能谷
function [value] = ChooseFinalValley(valley,type)
    % valley:电子所在能谷
    
    switch type
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

% 散射末态波矢迭代选择,根据能量守恒
function [particle,phonon] = ChooseFinalK(particle,phonon,type1,type2,type3)
    % 
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
        particle = Choosek(particle);
        phonon.k = particle.k - kStart;
        phonon.q = sqrt(sum(phonon.k.^2));
        phonon = Ifbeyondbz(phonon,1);
        phonon.w = double(subs(hanshu, phonon.q));
        phonon.energy = double(hbar*phonon.w);
        error = abs((phonon.energy-phononEnergy)/phonon.energy);
        item = item + 1;
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
            particle = Choosek(particle);
        case 2 % intra_LA
            particle.energy = particle.energy;
            particle = Choosek(particle);
        case 3 % intra_TA
            particle.energy = particle.energy;
            particle = Choosek(particle);
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
    
end

% 计算飞行时间
function [tf] = TimeForFly()
    % gammaMax:总散射率
    Macro;
    
    tf = -log(Random(0.2,0.7)) / gammaMax;
    
end

% 生成截止能量随位置变化
function [EnergyDecay] = EnergyDecayArray()
    % downlimit:截止能量下限,eV
    % uplimit:截止能量上限,eV
    % num:划分份数
    Macro;
    
    % 生成高斯分布
    x = 0:0.01:1.5;
    y = normpdf(x,0,(1/(uplimit-downlimit))*1/sqrt(2*pi))+downlimit;
    EnergyDecay = zeros(numofErelax+1,2);
    EnergyDecay(:,1) = linspace((d1+d2),(d1+d2+lenEnergyRelax),numofErelax+1);
    deltar = floor(length(y)/numofErelax);
    for i = 1:numofErelax+1
        EnergyDecay(i,2) = y(1+(i-1)*deltar)*e;
    end
    figure
    plot(EnergyDecay(:,1)*1e9,EnergyDecay(:,2)/e)
    xlabel('nm');ylabel('eV');
    legend("Energy Cut")
end

% 局域化
function [flag] = Localization(particle,EnergyDecay)
    % particle:单个粒子结构体
    % EnergyDecay:能量衰减矩阵
    Macro;
    
    flag = 1;
    HotSpotRound = lenEnergyRelax/(2*numofErelax);
    x = particle.r(1);
    e = particle.energy;
    for i = 2:numofErelax
        index1 = x > EnergyDecay(1,1);
        index2 = abs(mod(x, EnergyDecay(i,1))) <= HotSpotRound;
        index3 = e >= EnergyDecay(i,2);
        if  index1 && index2 && index3
            flag = 0;
            break;
        end
    end
    
end

% 单个电子飞行过程
function [electron] = FlyProcess(electron,tf,XeField,EnergyDecay)
    % electron:单个电子信息
    % tf:自由飞行时间
    % XeField:电场向量
    Macro;
    
    % 自由飞行段
    flag = Localization(electron,EnergyDecay);
    Efield = SearchEfield(electron.r(1),XeField);
    electron.k(1) = electron.k(1) - e*Efield*tf*flag/hbar;
    electron = Ifbeyondbz(electron, 0);
    electron.energy = eBand(electron, 0);
    electron.v = eBand(electron, 1);
    electron.r(1) = electron.r(1) + electron.v(1)*tf*flag;
    Time = electron.time + tf;
    electron.time = Time;
    % 超出模型边界,在源极重新生成超电子
    if electron.r(1) >= mbRight || electron.r(1) <= mbLeft 
        electron = GenerateElectron(0,d1/100,electron.charge,EnergyInit);
        electron.time = Time;
    end

end

% 并行计算
function [phistory,electrons] = ParFunction(electrons,XeField,EnergyDecay,sumSuperElecs)
    % electrons:电子信息结构体
    % XeField:电场向量
    % sumSuperElecs:总超电子数
    % nofScat:散射类型数
    Public;
    
    phistory = repmat(Phonon, sumSuperElecs, 1);
    parfor i = 1:sumSuperElecs
        % 自由飞行段
        tf = TimeForFly(); %#ok<*PFBNS>
        electrons(i) = FlyProcess(electrons(i),tf,XeField,EnergyDecay);
        % 散射段
        type = ChooseScatType(electrons(i).energy);
        [electrons(i),phistory(i)] = EscatP(type,electrons(i),phistory(i));
    end
    
end

% 分段模拟电子运动
function [pHistory,eHistory,electrons] = SubsectionParllel(electrons,eHistory,...
                                           XeField,EnergyDecay,pHistory,startk,endk)
    % electrons:电子信息结构体
    % eHistory:电子历史信息
    % XeField:电场向量
    % sumSuperElecs:总超电子数
    % pHistory:声子历史记录
    % startk:该段飞行开始时次数
    % endk:该段飞行结束时次数
    Macro;
    
    for k = startk:endk
        % 输出计算进度
        if mod(k, noFly/100) == 0
            disp(['计算进度： ', num2str(k/noFly*100), '%']);
        end
        % 飞行开始前统计电子历史信息
        eHistory(:,k+1) = electrons;
        [phistory,electrons] = ParFunction(electrons,XeField,EnergyDecay,sumSuperElecs);
        pHistory(:,k) = phistory;
    end
    % 分段保存计算数据
    save data.mat;
    if endk ~= noFly
        clear;
        load data.mat; %#ok<*LOAD>
    end
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 后处理部分 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  1  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 说明：声子群提取及处理
% (1)模拟时间可根据实际模拟情况获得,timeStart和timeEnd的设置应该参考总模拟时间totalTime;
% (2)需要调整nDot/Q/SourceB等参数的量级,主要原因是公式是三维的,在应用到一维及二维模型时会有数量级差异;
% (3);

% 计算平均总飞行时间
function [totalTime] = TotalFlyTime(eHistory)
    % 
    Macro;
    
    time = zeros(sumSuperElecs, 1);
    for i = 1:sumSuperElecs
        time(i) = eHistory(i,end).time;
    end
    totalTime = sum(time)/sumSuperElecs;
    if totalTime > timeEnd
        disp("timeEnd设置合理,且可以更大！")
    end
    disp(['总模拟时间： ', num2str(totalTime)]);
    
    
end

% 统计各个频率段的声子群
function [frequency,phonons] = StatisticPhonon(grid,pHistory)
    % grid:网格
    % pHistory:声子历史信息
    Macro;
    Public;
    
    frequency = repmat(Frequency, NW, 1);
    wPhonon = zeros(sumSuperElecs*noFly,1);
    times = zeros(sumSuperElecs*noFly,1);
    polars = zeros(sumSuperElecs*noFly,1);
    phonons = repmat(Phonon,sumSuperElecs*noFly,1);
    % 提取声子信息
    for i = 1:sumSuperElecs
        wPhonon((i-1)*noFly+1:i*noFly) = deal([pHistory(i,:).w]');
        times((i-1)*noFly+1:i*noFly)   = deal([pHistory(i,:).time]');
        polars((i-1)*noFly+1:i*noFly)  = deal([pHistory(i,:).polarization]');
        phonons((i-1)*noFly+1:i*noFly) = deal(pHistory(i,:)');
    end
    % index1用于筛选模拟时间内的声子
    index1 = times >=timeStart & times <= timeEnd;
    % index2用于剔除零值
    index2 = polars ~= 0;
    for k = 1:NW
        index3 = wPhonon > grid.w.face(k) & wPhonon < grid.w.face(k+1);
        index = index1 & index2 & index3;
        % frequency(k).pop中存储单个频率段对应的声子群在pHistory中的标号
        frequency(k).pop = find(index);
        % frequency(k).num中存储单个频率段对应的声子数目
        frequency(k).num = length(frequency(k).pop);
    end

end

% 统计各个频率段上/模型区域上声子产热率
function [nDot, Q] = HeatGeneration(grid,ne,frequency,phonons,dos)
    % grid:网格
    % ne:电子密度
    % pHistory:声子历史信息
    % frequency:各频率段下标索引
    % dos:声子态密度
    Macro;
    Public;
    ScatterringCurve;
    
    nDot = repmat(Polar, NW, 1);
    Q = repmat(Polar, NW, 1);
    for k = 1:NW
        nDot(k).LA = zeros(NX+2,1);
        nDot(k).TA = zeros(NX+2,1);
        nDot(k).LO = zeros(NX+2,1);
        nDot(k).TO = zeros(NX+2,1);
        Q(k).LA = zeros(NX+2,1);
        Q(k).TA = zeros(NX+2,1);
        Q(k).LO = zeros(NX+2,1);
        Q(k).TO = zeros(NX+2,1);
    end
    % 循环所有频率段，尤其注意不同极化支的频率范围
    for k = 1:NW
        wphonon = phonons(frequency(k).pop);
        wPtype = [wphonon(:).type]';
        wPpola = [wphonon(:).polarization]';
        index1 = wPpola == 1; index2 = wPtype == 1;
        pLAab = wphonon(index1 & index2);
        index1 = wPpola == 1; index2 = wPtype == 0;
        pLAem = wphonon(index1 & index2);
        index1 = wPpola == 2; index2 = wPtype == 1;
        pTAab = wphonon(index1 & index2);
        index1 = wPpola == 2; index2 = wPtype == 0;
        pTAem = wphonon(index1 & index2);
        index1 = wPpola == 3; index2 = wPtype == 1;
        pLOab = wphonon(index1 & index2);
        index1 = wPpola == 3; index2 = wPtype == 0;
        pLOem = wphonon(index1 & index2);
        index1 = wPpola == 4; index2 = wPtype == 1;
        pTOab = wphonon(index1 & index2);
        index1 = wPpola == 4; index2 = wPtype == 0;
        pTOem = wphonon(index1 & index2);
        % 扫描模型内部区域
        for i = 1:NX
            energyLAem = 0; energyLAab = 0;
            energyTAem = 0; energyTAab = 0;
            energyLOem = 0; energyLOab = 0;
            energyTOem = 0; energyTOab = 0;

            if ~isempty(pLAab)
                r = [pLAab(:).r];
                x = double(r(1:3:end-2)');
                index1 = x > grid.x.face(i) & x < grid.x.face(i+1);
                interPhonon = pLAab(index1);
                energyLAab = sum([interPhonon(:).energy]);
            end
            if ~isempty(pLAem)
                r = [pLAem(:).r];
                x = double(r(1:3:end-2)');
                index1 = x > grid.x.face(i) & x < grid.x.face(i+1);
                interPhonon = pLAem(index1);
                energyLAem = sum([interPhonon(:).energy]);
            end
            if ~isempty(pTAab)
                r = [pTAab(:).r];
                x = double(r(1:3:end-2)');
                index1 = x > grid.x.face(i) & x < grid.x.face(i+1);
                interPhonon = pTAab(index1);
                energyTAab = sum([interPhonon(:).energy]);
            end
            if ~isempty(pTAem)
                r = [pTAem(:).r];
                x = double(r(1:3:end-2)');
                index1 = x > grid.x.face(i) & x < grid.x.face(i+1);
                interPhonon = pTAem(index1);
                energyTAem = sum([interPhonon(:).energy]);
            end
            if ~isempty(pLOab)
                r = [pLOab(:).r];
                x = double(r(1:3:end-2)');
                index1 = x > grid.x.face(i) & x < grid.x.face(i+1);
                interPhonon = pLOab(index1);
                energyLOab = sum([interPhonon(:).energy]);
            end
            if ~isempty(pLOem)
                r = [pLOem(:).r];
                x = double(r(1:3:end-2)');
                index1 = x > grid.x.face(i) & x < grid.x.face(i+1);
                interPhonon = pLOem(index1);
                energyLOem = sum([interPhonon(:).energy]);
            end
            if ~isempty(pTOab)
                r = [pTOab(:).r];
                x = double(r(1:3:end-2)');
                index1 = x > grid.x.face(i) & x < grid.x.face(i+1);
                interPhonon = pTOab(index1);
                energyTOab = sum([interPhonon(:).energy]);
            end
            if ~isempty(pTOem)
                r = [pTOem(:).r];
                x = double(r(1:3:end-2)');
                index1 = x > grid.x.face(i) & x < grid.x.face(i+1);
                interPhonon = pTOem(index1);
                energyTOem = sum([interPhonon(:).energy]);
            end
            % 只能在极化支的频率定义域内进行计算,否则会有除0错误
            if grid.w.point(k+1) >= wMinLA && grid.w.point(k+1) <= wMaxLA
                Q(k).LA(i+1) = ne(i+1) * (energyLAem - energyLAab) / (sumSuperElecs*Deltat);
                nDot(k).LA(i+1) = Q(k).LA(i+1) / (hbar*grid.w.point(k+1)*dos.LA(k+1)*deltaw)*xsfornDot;
            end
            if grid.w.point(k+1) >= wMinTA && grid.w.point(k+1) <= wMaxTA
                Q(k).TA(i+1) = ne(i+1) * (energyTAem - energyTAab) / (sumSuperElecs*Deltat);
                nDot(k).TA(i+1) = Q(k).TA(i+1) / (hbar*grid.w.point(k+1)*dos.TA(k+1)*deltaw)*xsfornDot;
            end
            if grid.w.point(k+1) >= wMinLO && grid.w.point(k+1) <= wMaxLO
                Q(k).LO(i+1) = ne(i+1) * (energyLOem - energyLOab) / (sumSuperElecs*Deltat);
                nDot(k).LO(i+1) = Q(k).LO(i+1) / (hbar*grid.w.point(k+1)*dos.LO(k+1)*deltaw)*xsfornDot;
            end
            if grid.w.point(k+1) >= wMinTO && grid.w.point(k+1) <= wMaxTO
                Q(k).TO(i+1) = ne(i+1) * (energyTOem - energyTOab) / (sumSuperElecs*Deltat);
                nDot(k).TO(i+1) = Q(k).TO(i+1) / (hbar*grid.w.point(k+1)*dos.TO(k+1)*deltaw)*xsfornDot;
            end
        end
    end
    
end

% 用于确定n/nDot/Q量级大小
function [nn] = PlotSumnAndnDot(grid, n, name, type)
    % grid:网格结构体
    % n:n/nDot/Q结构体
    % name:画图类型
    Macro;
    
    nn = zeros(NX+2,1);
    for k = 1:NW
        switch type
            case 'LA'
                nn = nn + n(k).LA;
            case 'TA'
                nn = nn + n(k).TA;
            case 'LO'
                nn = nn + n(k).LO;
            case 'TO'
                nn = nn + n(k).TO;
            case 'ALL'
                nn = nn + n(k).LA + n(k).TA + n(k).LO + n(k).TO;
        end
    end
    figure
    slg = plot(grid.x.point(:)*1e9,nn,'-');
    slg.LineWidth = 2;
    legend(name)
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  2  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 说明：
% (1)将n中小于0的数值定为0,因为计算n的方程本身不够好,导致n的数值很分散;
% (2);
% (3);

% 求远平衡分布函数
function [n] = FarDistributionFunction(gv,tao,nDot)
    % gv:群速度结构体
    % tao:弛豫时间结构体
    % nDot:nDot结构体
    Macro;
    Public;
    
    n = repmat(Polar,NW,1);
    for k = 1:NW
        if tao.LA(k+1) ~= 0
            n(k).LA = SolveConvection(gv.LA(k+1),tao.LA(k+1),nDot(k).LA);
        end
        if tao.TA(k+1) ~= 0
            n(k).TA = SolveConvection(gv.TA(k+1),tao.TA(k+1),nDot(k).TA);
        end
        if tao.LO(k+1) ~= 0
            n(k).LO = SolveConvection(gv.LO(k+1),tao.LO(k+1),nDot(k).LO);
        end
        if tao.TO(k+1) ~= 0
            n(k).TO = SolveConvection(gv.TO(k+1),tao.TO(k+1),nDot(k).TO);
        end
    end

end

% FarDistributionFunction的子函数
function [n] = SolveConvection(gv,tao,ndot)
    % gv:某个极化支/某个频率下的群速度
    % tao:某个频率下的弛豫时间
    % ndot:某个极化支、某个频率下的nDot
    Macro;
    
    n = zeros(NX+2,1);
    for i = 2:NX+1
        if i == 2
            ap = gv + 3*deltax/(2*tao);
            aw = gv;
            b = 3*deltax*ndot(i)/2;
            n(i) = (aw*n(i-1) + b)/ap;
        else
            ap = gv + deltax/tao;
            aw = gv;
            b = deltax*ndot(i);
            n(i) = (aw*n(i-1) + b)/ap;
        end
        if n(i) < 0
            n(i) = 0;
        end
    end
    
end

% 求扩散温度
function [TF] = ComputeTF(grid,n,gv,tao)
    % grid:网格结构体
    % n:远平衡分布函数
    % gv:群速度结构体
    % tao:弛豫时间结构体
    Macro;
    ScatterringCurve;

    sourceB = zeros(NX+2,1);
    for i = 1:NX
        energyLA = 0; energyTA = 0;
        energyLO = 0; energyTO = 0;
        for k = 1:NW
            if grid.w.point(k+1) >= wMinLA && grid.w.point(k+1) <= wMaxLA
                energyLA = energyLA + n(k).LA(i+1)*hbar*grid.w.point(k+1)*deltaw / (gv.LA(k+1)*tao.LA(k+1));
            end
            if grid.w.point(k+1) >= wMinTA && grid.w.point(k+1) <= wMaxTA
                energyTA = energyTA + n(k).TA(i+1)*hbar*grid.w.point(k+1)*deltaw / (gv.TA(k+1)*tao.TA(k+1));
            end
            if grid.w.point(k+1) >= wMinLO && grid.w.point(k+1) <= wMaxLO
                energyLO = energyLO + n(k).LO(i+1)*hbar*grid.w.point(k+1)*deltaw / (gv.LO(k+1)*tao.LO(k+1));
            end
            if grid.w.point(k+1) >= wMinTO && grid.w.point(k+1) <= wMaxTO
                energyTO = energyTO + n(k).TO(i+1)*hbar*grid.w.point(k+1)*deltaw / (gv.TO(k+1)*tao.TO(k+1));
            end
        end
        sourceB(i+1) = xsforSourceB*(energyLA + energyTA + energyLO + energyTO) / (2*pi)^3;
    end
    TF = SolveDiffusion(sourceB);
    
end

% 数值求解扩散温度
function [TF] = SolveDiffusion(sourceB)
    % sourceB:扩散方程源项
    Macro;
    
    TF = zeros(NX+2,1) + 300;
    xishu = zeros(NX,NX);
    youduan = zeros(NX,1);
    for i = 2:NX+1
        if i == 2
            xishu(1,1) = -3;
            xishu(1,2) = 2;
            youduan(1) = -sourceB(i)/k*deltax^2 - TF(1);
        elseif i == NX+1
            xishu(NX,NX-1) = 2;
            xishu(NX,NX) = -3;
            youduan(NX) = -sourceB(i)/k*deltax^2 - TF(NX+2);
        else
            xishu(i-1,i-2) = 1;
            xishu(i-1,i-1) = -2;
            xishu(i-1,i) = 1;
            youduan(i-1) = -sourceB(i)/k*deltax^2;
        end
    end
    TF(2:NX+1) = xishu\youduan;

end

% 求等效温度
function [Teff] = ComputeTeff(grid,TF,n,gv)
    % grid:网格结构体
    % TF:扩散温度
    % n:远平衡分布函数
    % gv:群速度结构体
    Macro;
    ScatterringCurve;

    Teff = zeros(NX+2,1) + T;
    energyLeft = zeros(NX+2,1);
    energyRight = zeros(NX+2,1);
    % 循环控制变量
    number = 2000;
    deltaT = 0.1;
    errorMax = 1e-3;

    for i = 1:NX
        error = zeros(number, 1);
        flag = -1;% 用于控制温度增减
        for p = 1:number
            % 方程左边
            energyLA = 0; energyTA = 0;
            energyLO = 0; energyTO = 0;
            for k = 1:NW
                NLeft = 1 / (exp(hbar*grid.w.point(k+1) / (kb*Teff(i+1))) - 1);
                if grid.w.point(k+1) >= wMinLA && grid.w.point(k+1) <= wMaxLA
                    energyLA = energyLA + NLeft*hbar*grid.w.point(k+1)*deltaw / gv.LA(k+1);
                end
                if grid.w.point(k+1) >= wMinTA && grid.w.point(k+1) <= wMaxTA
                    energyTA = energyTA + NLeft*hbar*grid.w.point(k+1)*deltaw / gv.TA(k+1);
                end
                if grid.w.point(k+1) >= wMinLO && grid.w.point(k+1) <= wMaxLO
                    energyLO = energyLO + NLeft*hbar*grid.w.point(k+1)*deltaw / gv.LO(k+1);
                end
                if grid.w.point(k+1) >= wMinTO && grid.w.point(k+1) <= wMaxTO
                    energyTO = energyTO + NLeft*hbar*grid.w.point(k+1)*deltaw / gv.TO(k+1);
                end
            end
            energyLeft(i+1) = (energyLA + energyTA + energyLO + energyTO) / (2*pi)^3;
            % 方程右边
            energyLA = 0; energyTA = 0;
            energyLO = 0; energyTO = 0;
            for k = 1:NW
                NRight = 1 / (exp(hbar*grid.w.point(k+1) / (kb*TF(i+1))) - 1);
                if grid.w.point(k+1) >= wMinLA && grid.w.point(k+1) <= wMaxLA
                    energyLA = energyLA + (n(k).LA(i+1) + NRight)*hbar*grid.w.point(k+1)*deltaw / gv.LA(k+1);
                end
                if grid.w.point(k+1) >= wMinTA && grid.w.point(k+1) <= wMaxTA
                    energyTA = energyTA + (n(k).TA(i+1) + NRight)*hbar*grid.w.point(k+1)*deltaw / gv.TA(k+1);
                end
                if grid.w.point(k+1) >= wMinLO && grid.w.point(k+1) <= wMaxLO
                    energyLO = energyLO + (n(k).LO(i+1) + NRight)*hbar*grid.w.point(k+1)*deltaw / gv.LO(k+1);
                end
                if grid.w.point(k+1) >= wMinTO && grid.w.point(k+1) <= wMaxTO
                    energyTO = energyTO + (n(k).TO(i+1) + NRight)*hbar*grid.w.point(k+1)*deltaw / gv.TO(k+1);
                end
            end
            energyRight(i+1) = (energyLA + energyTA + energyLO + energyTO) / (2*pi)^3;
            % 左右校准
            error(p) = double(abs((energyRight(i+1) - energyLeft(i+1)) / energyRight(i+1)));
            if error(p) < errorMax
                break;
            end
            if p >= 2 && (error(p) - error(p-1)) > 0
                flag = -1*flag;
            end
            Teff(i+1) = Teff(i+1) + flag*deltaT;
        end
    end

end

% 单个极化支等效温度
function [Teff] = PolarTeff(grid,TF,n,gv,type)
    % grid:网格结构体
    % TF:扩散温度场
    % n:远平衡分布函数
    % gv:群速度结构体
    % type:极化支类型
    Macro;
    Public;
    ScatterringCurve;
    
    nn = repmat(Polar, NW, 1);
    Teff = zeros(NX+2,1) + T;
    energyLeft = zeros(NX+2,1);
    energyRight = zeros(NX+2,1);
    % 循环控制变量
    number = 2000;
    deltaT = 0.1;
    errorMax = 1e-3;
    
    switch type
        case 'LA'
            wMin = wMinLA; wMax = wMaxLA;
            gvelocity = gv.LA;
            for k = 1:NW
                nn(k).LA = n(k).LA;
            end
        case 'TA'
            wMin = wMinTA; wMax = wMaxTA;
            gvelocity = gv.TA;
            for k = 1:NW
                nn(k).LA = n(k).TA;
            end
        case 'LO'
            wMin = wMinLO; wMax = wMaxLO;
            gvelocity = gv.LO;
            for k = 1:NW
                nn(k).LA = n(k).LO;
            end
        case 'TO'
            wMin = wMinTO; wMax = wMaxTO;
            gvelocity = gv.TO;
            for k = 1:NW
                nn(k).LA = n(k).TO;
            end
    end

    for i = 1:NX
        error = zeros(number, 1);
        flag = -1;% 用于控制温度增减
        for p = 1:number
            % 方程左边
            energy = 0;
            for k = 1:NW
                NLeft = 1 / (exp(hbar*grid.w.point(k+1) / (kb*Teff(i+1))) - 1);
                if grid.w.point(k+1) >= wMin && grid.w.point(k+1) <= wMax
                    energy = energy + NLeft*hbar*grid.w.point(k+1)*deltaw / gvelocity(k+1);
                end
            end
            energyLeft(i+1) = energy / (2*pi)^3;
            % 方程右边
            energy = 0;
            for k = 1:NW
                NRight = 1 / (exp(hbar*grid.w.point(k+1) / (kb*TF(i+1))) - 1);
                if grid.w.point(k+1) >= wMin && grid.w.point(k+1) <= wMax
                    energy = energy + (nn(k).LA(i+1) + NRight)*hbar*grid.w.point(k+1)*deltaw / gvelocity(k+1);
                end
            end
            energyRight(i+1) = energy / (2*pi)^3;
            % 左右校准
            error(p) = double(abs((energyRight(i+1) - energyLeft(i+1)) / energyRight(i+1)));
            if error(p) < errorMax
                break;
            end
            if p >= 2 && (error(p) - error(p-1)) > 0
                flag = -1*flag;
            end
            Teff(i+1) = Teff(i+1) + flag*deltaT;
        end
    end

end

% 等效温度画图
function [] = PlotTeff(grid,TE,name)
    % grid:网格
    % Teff:等效温度向量
    Macro;
    
    num = size(TE);
    figure
    for i = 1:num(2)
        values = spcrv([grid.x.point(:)'*1e9;TE(:,i)'],3);
        slg = plot(values(1,:), values(2,:));
        slg.LineWidth = 2;
        hold on
    end
    xlabel('nm');
    ylabel('K');
    legend(name);
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  3  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 说明：这部分主要是为了验证程序的合理性
% (1);
% (2);
% (3);

% 单电子轨迹图
function [] = ElectronTrace(eHistory,num,name)
    % eHistory:电子历史信息
    % num:超电子序号
    % name:画图类型
    Macro;
    
    switch name
        case 'k'
            k = zeros(noFly+1,3);
            times = zeros(noFly+1,1);
            for i = 1:noFly+1
                times(i) = eHistory(num,i).time;
                k(i,:) = eHistory(num,i).k;
            end
            figure
            plot3(k(:,1),k(:,2),k(:,3),'*')
            xlabel('kx');ylabel('ky');zlabel('kz');
            legend("k-space")
        case 'r'
            positions = zeros(noFly+1,1);
            times = zeros(noFly+1,1);
            for i = 1:noFly+1
                times(i) = eHistory(num,i).time;
                positions(i) = eHistory(num,i).r(1);
            end
            figure
            plot(times*1e12,positions*1e9,'-')
            xlabel('ps');ylabel('nm');
            legend("real-space")
        case 'e'
            positions = zeros(noFly+1,1);
            energys = zeros(noFly+1,1);
            for i = 1:noFly+1
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
function [aveEnergyTime] = AverageEnergyTime(grid,eHistory)
    % grid:网格结构体
    % eHistory:电子历史信息
    Macro;
    
    aveEnergyTime = zeros(Nt+1,1);
    for t = 1:Nt+1
        Energy = 0;
        for i = 1:sumSuperElecs
            energy = [eHistory(i,:).energy];
            times  = [eHistory(i,:).time];
            index = find(grid.t.face(t) <= times,1);
            if isempty(index)
                continue;
            end
            Energy = Energy + energy(index);
        end
        aveEnergyTime(t) = Energy / (sumSuperElecs*e);
    end
    figure
    slg = semilogy(grid.t.face(:)*1e12,aveEnergyTime(:));
    slg.LineWidth = 2;
    xlabel('ps');ylabel('eV');
    legend("average elevtron energy")
    
end

% 求电子平均能量随位置变化关系图
function [aveEnergyDisp] = AverageEnergyDisplace(grid,eHistory)
    % grid:网格结构体
    % eHistory:电子历史信息 
    Macro;
    
    aveEnergyDisp = zeros(NX+2,1);
    for k = 1:NX
        num = 0;
        Energy = 0;
        for i = 1:sumSuperElecs
            x = zeros(noFly+1,1);
            for j = 1:noFly+1
                x(j) = eHistory(i,j).r(1);
            end
            energy = [eHistory(i,:).energy];
            index = x >= grid.x.face(k) & x < grid.x.face(k+1);
            if isempty(index)
                continue;
            end
            num = num + sum(double(index));
            Energy = Energy + sum(energy(index));
        end
        aveEnergyDisp(k+1) = Energy / num;
    end
    aveEnergyDisp(1) = aveEnergyDisp(2);
    aveEnergyDisp(NX+2) = aveEnergyDisp(NX+1);
    figure
    slg = plot(grid.x.point(:)*1e9,aveEnergyDisp(:)/e);
    slg.LineWidth = 2;
    xlabel('nm');ylabel('eV');
    legend("average electron energy")
    
end

% 求声子发射谱
function [wNum] = PhononEmSpectrum(grid,frequency)
    % 
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

% 某个位置上的声子分布函数
function [distribution] = PhononDistribution(grid,n,type,position)
    % 
    Macro;
    Public;
    
    BoseEin = @(w) 1/(exp(hbar*w/(kb*T))-1);
    nn = repmat(Frequency,NW,1);
    for k = 1:NW
        switch type
            case 'LA'
                nn(k).pop = n(k).LA;
            case 'TA'
                nn(k).pop = n(k).TA;
            case 'LO'
                nn(k).pop = n(k).LO;
            case 'TO'
                nn(k).pop = n(k).TO;
            case 'ALL'
                nn(k).pop = n(k).LA + n(k).TA + n(k).LO + n(k).TO;
        end
    end
    index = floor(position/deltax)+1;
    distribution = zeros(NW,3);
    for k = 1:NW
        num = length(nn(k).pop);
        distribution(k,1) = hbar*grid.w.point(k+1)/e*1000;
        distribution(k,2) = BoseEin(grid.w.point(k+1));
        if num(1) > 1
            distribution(k,2) = nn(k).pop(index)+distribution(k,2);
        end
    end
    for k = 1:NW
        distribution(k,3) = BoseEin(grid.w.point(k+2));
    end
    index = find(distribution(:,1)>10,1);
    figure
    slg = plot(distribution(index:end,1),distribution(index:end,2));
    slg.LineWidth = 2;
    hold on
    slg = plot(distribution(index:end,1),distribution(index:end,3));
    slg.LineWidth = 2;
    xlabel('meV');ylabel('.a.u');
    legend("phonon distribution","Bose-Einstein distribution")
    
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

























