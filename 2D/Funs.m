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
    Funs.ReadDopDensity            = @ReadDopDensity;
    Funs.HarmonicAverage           = @HarmonicAverage;
    Funs.PlotDensity               = @PlotDensity;
    Funs.ComputeSuperCharge        = @ComputeSuperCharge;
    Funs.ReadEleconc               = @ReadEleconc;
    Funs.GenerateElectron          = @GenerateElectron;
    Funs.MaxwellVelocity           = @MaxwellVelocity;
    Funs.PlotMaxwell               = @PlotMaxwell;
    Funs.Choosek                   = @Choosek;
    Funs.Random                    = @Random;
    Funs.InitializeInfor           = @InitializeInfor;
    % 计算模拟部分
    Funs.eBand                     = @eBand;
    Funs.Ifbeyondbz                = @Ifbeyondbz;
    Funs.ReadElectricField         = @ReadElectricField;
    Funs.TotalElecField            = @TotalElecField;
    Funs.PlotElectricField         = @PlotElectricField;
    Funs.SearchEfield              = @SearchEfield;
    Funs.ChooseFvalley             = @ChooseFvalley;
    Funs.EscatP                    = @EscatP;
    Funs.TimeForFly                = @TimeForFly;
    Funs.Localization              = @Localization;
    Funs.Directangle               = @Directangle;
    Funs.MESFETBoundary            = @MESFETBoundary;
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
    Funs.Write2datFile             = @Write2datFile;
    Funs.Write3datFile             = @Write3datFile;
    
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
% (1)二维网格划分;
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
    grid.y = MeshGrid(yMin, yMax, NY);
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
    scatTable(1) = P_impurity(energy, DopDensity);
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
        slg = semilogy(energy, scatTable(:,j));
        slg.LineWidth = 3;
        hold on
    end
    legend("e-impurity","intra_LA","intra_TA","inter_g_ab_TA","inter_g_ab_LA",...
           "inter_g_ab_LO","inter_f_ab_TA","inter_f_ab_LA","inter_f_ab_TO",...
           "inter_g_em_TA","inter_g_em_LA","inter_g_em_LO","inter_f_em_TA",...
           "inter_f_em_LA","inter_f_em_TO")
    
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
% (1)MESFET使用的是单一均匀掺杂,掺杂浓度按照常数进行设置;
% (2)MESFET中不考虑轻重掺杂;
% (3)根据设置的超电子数,计算对应的电荷量,要注意该电荷量的量纲中含有m;

% 读取掺杂浓度
function [dopDensity] = ReadDopDensity(grid, TotalDoping)
    % grid:网格结构体
    % TotalDoping:掺杂数据文件
    Macro;
    
    dopDensity = zeros(NY+2,NX+2);
    for j = 1:NY
        for i = 1:NX
            dopDensity(j+1,i+1) = HarmonicAverage(grid.x.point(i+1),grid.y.point(j+1),TotalDoping);
        end
    end
    
end

% 读取电子浓度
function [ne] = ReadEleconc(grid, Eleconc)
    % grid:网格结构体
    % Eleconc:电子浓度数据文件
    Macro;
    
    ne = zeros(NY+2,NX+2);
    for j = 1:NY
        for i = 1:NX
            ne(j+1,i+1) = HarmonicAverage(grid.x.point(i+1),grid.y.point(j+1),Eleconc);
        end
    end
    
end

% 调和平均插值
function [backvalue] = HarmonicAverage(x, y, value)
    % x:横坐标
    % y:纵坐标
    % value:浓度信息
    Macro;
    
    %转化为国际量纲
    value(:,1) = 1e-6*value(:,1);
    value(:,2) = 1e-6*value(:,2);
    value(:,3) = 1e6*value(:,3);

    %不必是均匀网格，但必须正交
    xf = unique(value(:,1));
    yf = unique(value(:,2));

    indexX = find(x < xf,1);
    rightFace = xf(indexX);
    leftFace = xf(indexX-1);
    %y方向互补，x方向相同
    y1 = abs(mWidth - y);
    indexY = find(y1 < yf,1);
    bottomFace = yf(indexY);
    topFace = yf(indexY-1);
    %求距离和面积
    deltaYtop = abs(y1 - topFace);
    deltaYbottom = abs(bottomFace - y1);
    deltaY = deltaYtop + deltaYbottom;

    deltaXleft = abs(x - leftFace);
    deltaXright = abs(rightFace - x);
    deltaX = deltaXleft + deltaXright;

    rbArea = deltaXright*deltaYbottom;
    rtArea = deltaXright*deltaYtop;
    ltArea = deltaXleft*deltaYtop;
    lbArea = deltaXleft*deltaYbottom;
    allArea = deltaX*deltaY;
    %求四个角上的电子浓度，使用调和平均计算电子浓度
    rbEfieldX = value(value(:,1) == rightFace & value(:,2) == bottomFace,3);
    rtEfieldX = value(value(:,1) == rightFace & value(:,2) == topFace,3);
    ltEfieldX = value(value(:,1) == leftFace & value(:,2) == topFace,3);
    lbEfieldX = value(value(:,1) == leftFace & value(:,2) == bottomFace,3);

    backvalue = (rbEfieldX*(allArea - rbArea)/allArea + rtEfieldX*(allArea - rtArea)/allArea +...
                ltEfieldX*(allArea - ltArea)/allArea + lbEfieldX*(allArea - lbArea)/allArea)/3;
             
end

% 掺杂/电子浓度画图
function [] = PlotDensity(grid,Density,name)
    % grid:网格结构体
    % Density:浓度矩阵
    % name:矩阵名称
    Macro;
    
    item = Write3datFile(strcat(name,".dat"),grid,Density);
    x = item(:,1);
    y = item(:,2);
    z = item(:,3);
    [X,Y,Z]=griddata(x,y,z,linspace(0,mbRight*1e9,200)',linspace(0,mbTop*1e9,200),'v4');
    figure
    pcolor(X,Y,Z);
    shading interp
    colormap(turbo)
    xlabel("nm");
    ylabel("nm");
    legend(name);
    
end

% 根据掺杂浓度分布计算超电子电荷量
function [superElecCharge] = ComputeSuperCharge(dopDensity)
    % dopDensity:掺杂浓度矩阵
    Macro;
    
    Charge = 0;
    index = round((mWidth-dntype)/deltay)+2;
    for j = index:NY
        for i = 1:NX
            Charge = Charge + deltax*deltay*dopDensity(j+1,i+1)*e;
        end
    end
    superElecCharge = Charge/sumSuperElecs;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  5  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 说明：初始化相关函数
% (1)初始电子群速度按Maxwell分布计算,初始能量按定值;
% (2)Maxwell分布是一个概率分布,群速度分布符合该分布曲线,采用rejection方法来实现;
% (3)在等能椭球面上随机选取电子波矢,但要注意波矢长度不能超出第一布里渊区;

% 随机在某区域上生成电子
function [particle] = GenerateElectron(tb,bb,lb,rb,charge,energy)
    % tb:上边界
    % bb:下边界
    % lb:左边界
    % rb:右边界
    % chargr:超电子电荷量
    % energy:电子能量值
    Macro;
    Public;
    
    particle = Electron;
    % 随机生成位置
    particle.energy = energy;
    particle.r(1) = Random(lb, rb);
    particle.r(2) = Random(tb, bb);
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
    
    f = @(vv) DopDensity*(m/(2*pi*kb*T))^(3/2)*exp(-m*vv.^2/(2*kb*T));
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
function [electrons] = InitializeInfor(electrons,superElecCharge)
    % electrons:电子信息结构体
    % superElecCharge:超电子电荷量
    Macro;
    
    % 全范围均匀生成超电子
    for i = 1:sumSuperElecs
        electrons(i) = GenerateElectron(mbTop,mbTop,0,d1,superElecCharge,EnergyInit);
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
    end

end

% 读取电场强度
function [xeField,yeField] = ReadElectricField(grid,XeField,YeField)
    % grid:网格结构体
    % XeField:x方向电场数据文件
    % YeField:y方向电场数据文件
    Macro;
    
    xeField = zeros(NY+2,NX+2);
    yeField = zeros(NY+2,NX+2);
    for j = 1:NY
        for i = 1:NX
            [xeField(j+1,i+1),yeField(j+1,i+1)] = SearchEfield(grid.x.point(i+1),grid.y.point(j+1),XeField,YeField);
        end
    end 
    
end

% 计算总电场强度
function [eField] = TotalElecField(xeField,yeField)
    % xeField:x方向电场矩阵
    % yeField:y方向电场矩阵
    Macro;
    
    eField = zeros(NY+2,NX+2);
    for j = 1:NY
        for i = 1:NX
            eField(j+1,i+1) = sqrt(xeField(j+1,i+1).^2+yeField(j+1,i+1).^2);
        end
    end
    
end

% 电场强度画图
function [] = PlotElectricField(grid,ElecField,name)
    % grid:网格结构体
    % ElecField:电场矩阵
    % name:矩阵名称
    Macro;
    
    item = Write3datFile(strcat(name,".dat"),grid,ElecField);
    x = item(:,1);
    y = item(:,2);
    z = item(:,3);
    [X,Y,Z]=griddata(x,y,z,linspace(0,mbRight*1e9,200)',linspace(0,mbTop*1e9,200),'v4');
    figure
    pcolor(X,Y,Z);
    shading interp
    colormap(jet)
    xlabel("nm");
    ylabel("nm");
    legend(name);
    
end

% 调和平均插值电场强度
function [xEfield, yEfield] = SearchEfield(x, y, XeField, YeField)
    % x:横坐标
    % y:纵坐标
    % XeField:x方向电场矩阵
    % YeField:y方向电场矩阵
    Macro;

    %转化为国际量纲
    XeField(:,1) = 1e-6*XeField(:,1);
    YeField(:,1) = 1e-6*YeField(:,1);
    XeField(:,2) = 1e-6*XeField(:,2);
    YeField(:,2) = 1e-6*YeField(:,2);
    XeField(:,3) = 100*XeField(:,3);
    YeField(:,3) = -100*YeField(:,3);
    
    xf = XeField(:,1);
    yf = XeField(:,2);
    indexX = xf >= x;
    %y方向互补，x方向相同
    y1 = abs(mWidth - y);
    indexY = yf >= y1;
    index = find(indexX & indexY, 1);
    xEfield = XeField(index,3);
    yEfield = YeField(index,3);
    
    
%     %求距离和面积
%     deltaYtop = abs(y1 - topFace);
%     deltaYbottom = abs(bottomFace - y1);
%     deltaY = deltaYtop + deltaYbottom;
% 
%     deltaXleft = abs(x - leftFace);
%     deltaXright = abs(rightFace - x);
%     deltaX = deltaXleft + deltaXright;
% 
%     rbArea = deltaXright*deltaYbottom;
%     rtArea = deltaXright*deltaYtop;
%     ltArea = deltaXleft*deltaYtop;
%     lbArea = deltaXleft*deltaYbottom;
%     allArea = deltaX*deltaY;
%     %求四个角上的电场强度，使用调和平均计算电场强度
%     rbEfieldX = XeField(XeField(:,1) == rightFace & XeField(:,2) == bottomFace,3);
%     rtEfieldX = XeField(XeField(:,1) == rightFace & XeField(:,2) == topFace,3);
%     ltEfieldX = XeField(XeField(:,1) == leftFace & XeField(:,2) == topFace,3);
%     lbEfieldX = XeField(XeField(:,1) == leftFace & XeField(:,2) == bottomFace,3);
% 
%     rbEfieldY = YeField(YeField(:,1) == rightFace & YeField(:,2) == bottomFace,3);
%     rtEfieldY = YeField(YeField(:,1) == rightFace & YeField(:,2) == topFace,3);
%     ltEfieldY = YeField(YeField(:,1) == leftFace & YeField(:,2) == topFace,3);
%     lbEfieldY = YeField(YeField(:,1) == leftFace & YeField(:,2) == bottomFace,3);
% 
%     xEfield = (rbEfieldX*(allArea - rbArea)/allArea + rtEfieldX*(allArea - rtArea)/allArea +...
%                 ltEfieldX*(allArea - ltArea)/allArea + lbEfieldX*(allArea - lbArea)/allArea)/3;
% 
%     yEfield = (rbEfieldY*(allArea - rbArea)/allArea + rtEfieldY*(allArea - rtArea)/allArea +...
%                 ltEfieldY*(allArea - ltArea)/allArea + lbEfieldY*(allArea - lbArea)/allArea)/3;

end

% 随机选择f型散射的能谷
function [value] = ChooseFvalley(valley)
    % valley:电子所在能谷

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

end

% 针对不同散射类型计算电子声子散射过程
function [phonon, particle] = EscatP(type,particle,phonon)
    % type:散射类型
    % particle:某一电子结构体
    % phonon:声子存储变量
    Macro;
    Public;
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
            phonon.w = double(subs(omegaTA, qg));
            phonon.energy = double(hbar*phonon.w);
            particle.energy = particle.energy + phonon.energy;
            particle = Choosek(particle);
            phonon.type = 1;
            phonon.polarization = 2;
            phonon.r = particle.r;
            phonon.time = particle.time;
        case 5 % inter_g_ab_LA
            phonon.w = double(subs(omegaLA, qg));
            phonon.energy = double(hbar*phonon.w);
            particle.energy = particle.energy + phonon.energy;
            particle = Choosek(particle);
            phonon.type = 1;
            phonon.polarization = 1;
            phonon.r = particle.r;
            phonon.time = particle.time;
        case 6 % inter_g_ab_LO
            phonon.w = double(subs(omegaLO, qg));
            phonon.energy = double(hbar*phonon.w);
            particle.energy = particle.energy + phonon.energy;
            particle = Choosek(particle);
            phonon.type = 1;
            phonon.polarization = 3;
            phonon.r = particle.r;
            phonon.time = particle.time;
        case 7 % inter_f_ab_TA
            phonon.w = double(subs(omegaTA, qf));
            phonon.energy = double(hbar*phonon.w);
            particle.energy = particle.energy + phonon.energy;
            particle = Choosek(particle);
            phonon.type = 1;
            phonon.polarization = 2;
            phonon.r = particle.r;
            phonon.time = particle.time;
        case 8 % inter_f_ab_LA
            phonon.w = double(subs(omegaLA, qf));
            phonon.energy = double(hbar*phonon.w);
            particle.energy = particle.energy + phonon.energy;
            particle = Choosek(particle);
            phonon.type = 1;
            phonon.polarization = 1;
            phonon.r = particle.r;
            phonon.time = particle.time;
        case 9 % inter_f_ab_TO
            phonon.w = double(subs(omegaTO, qf));
            phonon.energy = double(hbar*phonon.w);
            particle.energy = particle.energy + phonon.energy;
            particle = Choosek(particle);
            phonon.type = 1;
            phonon.polarization = 4;
            phonon.r = particle.r;
            phonon.time = particle.time;
        case 10 % inter_g_em_TA
            phonon.w = double(subs(omegaTA, qg));
            phonon.energy = double(hbar*phonon.w);
            particle.energy = particle.energy - phonon.energy;
            particle = Choosek(particle);
            phonon.type = 0;
            phonon.polarization = 2;
            phonon.r = particle.r;
            phonon.time = particle.time;
        case 11 % inter_g_em_LA
            phonon.w = double(subs(omegaLA, qg));
            phonon.energy = double(hbar*phonon.w);
            particle.energy = particle.energy - phonon.energy;
            particle = Choosek(particle);
            phonon.type = 0;
            phonon.polarization = 1;
            phonon.r = particle.r;
            phonon.time = particle.time;
        case 12 % inter_g_em_LO
            phonon.w = double(subs(omegaLO, qg));
            phonon.energy = double(hbar*phonon.w);
            particle.energy = particle.energy - phonon.energy;
            particle = Choosek(particle);
            phonon.type = 0;
            phonon.polarization = 3;
            phonon.r = particle.r;
            phonon.time = particle.time;
        case 13 % inter_f_em_TA
            phonon.w = double(subs(omegaTA, qf));
            phonon.energy = double(hbar*phonon.w);
            particle.energy = particle.energy - phonon.energy;
            particle = Choosek(particle);
            phonon.type = 0;
            phonon.polarization = 2;
            phonon.r = particle.r;
            phonon.time = particle.time;
        case 14 % inter_f_em_LA
            phonon.w = double(subs(omegaLA, qf));
            phonon.energy = double(hbar*phonon.w);
            particle.energy = particle.energy - phonon.energy;
            particle = Choosek(particle);
            phonon.type = 0;
            phonon.polarization = 1;
            phonon.r = particle.r;
            phonon.time = particle.time;
        case 15 % inter_f_em_TO
            phonon.w = double(subs(omegaTO, qf));
            phonon.energy = double(hbar*phonon.w);
            particle.energy = particle.energy - phonon.energy;
            particle = Choosek(particle);
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

% 局域化
function [flag] = Localization(particle)
    % particle:单个粒子结构体
    Macro;
    
    flag = 1;
    x = particle.r(1);
    e = particle.energy;
    if x > hotSpotPoint && mod(x, hotSpotPoint) <= HotSpotRound && e >= EnergyCut
        flag = 0;
    end
    
end

% 返回以第一个点为顶点的角度大小
function [theta] = Directangle(x1,y1,x2,y2,x3,y3)

    rou1 = sqrt((x3-x2)^2+(y3-y2)^2);
    rou2 = sqrt((x3-x1)^2+(y3-y1)^2);
    rou3 = sqrt((x1-x2)^2+(y1-y2)^2);
    flag = true;
    try
        theta = real(acos((rou2^2+rou3^2-rou1^2)/(2*rou2*rou3)));
    catch
        flag = false;
    end

    if ~flag
        theta = pi;
    end

end

% MESFET边界反射函数，只适用于凸多边形
function [electron, item] = MESFETBoundary(grid, r1, electron)
    % grid:网格结构体
    % r1:线段起点坐标
    % r2:线段终点坐标
    Macro;
    
    r2 = electron.r;
    velocity = sqrt(sum(electron.v(1:2).^2));
    
    x1 = r1(1);y1 = r1(2);z1 = r1(3); %#ok<*NASGU>
    x2 = r2(1);y2 = r2(2);z2 = r2(3);
    item = 0;
    points = zeros(8,2);
    points(1,:) = [grid.x.face(1),           grid.y.face(1)];
    points(2,:) = [grid.x.face(NX+1),        grid.y.face(1)];
    points(3,:) = [grid.x.face(NX+1),        grid.y.face(NY+1)];
    points(4,:) = [grid.x.face(NX+1)-d3,     grid.y.face(NY+1)];
    points(5,:) = [grid.x.face(NX+1)/2+d2/2, grid.y.face(NY+1)];
    points(6,:) = [grid.x.face(NX+1)/2-d2/2, grid.y.face(NY+1)];
    points(7,:) = [grid.x.face(1)+d1,        grid.y.face(NY+1)];
    points(8,:) = [grid.x.face(1),           grid.y.face(NY+1)];

    while x2 < mbLeft || x2 > mbRight || y2 < mbBottom || y2 > mbTop
        thetas = zeros(8,1);
        thetas(1) = Directangle(x1,y1,points(1,1),points(1,2),points(2,1),points(2,2));
        thetas(2) = Directangle(x1,y1,points(2,1),points(2,2),points(3,1),points(3,2));
        thetas(3) = Directangle(x1,y1,points(3,1),points(3,2),points(4,1),points(4,2));
        thetas(4) = Directangle(x1,y1,points(4,1),points(4,2),points(5,1),points(5,2));
        thetas(5) = Directangle(x1,y1,points(5,1),points(5,2),points(6,1),points(6,2));
        thetas(6) = Directangle(x1,y1,points(6,1),points(6,2),points(7,1),points(7,2));
        thetas(7) = Directangle(x1,y1,points(7,1),points(7,2),points(8,1),points(8,2));
        thetas(8) = Directangle(x1,y1,points(8,1),points(8,2),points(1,1),points(1,2));
        % 求由点points(1,:)和(x2,y2)构成的直线在x1处的值y21
        k1 = (y2-points(1,2))/(x2-points(1,1));
        y21 = k1*(x1-points(1,1))+points(1,2);
        % 求由点(x1,y1)和点(x2,y2)构成的直线在points(1,1)处的值y20
        k2 = (y2-y1)/(x2-x1);
        y20 = k2*(points(1,1)-x1)+y1;
        if x2 > 0
            if y21 <= y1
                theta = Directangle(x1,y1,points(1,1),points(1,2),x2,y2);
            else
                theta = 2*pi-Directangle(x1,y1,points(1,1),points(1,2),x2,y2);
            end
        else
            if y20 < 0
                theta = Directangle(x1,y1,points(1,1),points(1,2),x2,y2);
            else
                theta = 2*pi-Directangle(x1,y1,points(1,1),points(1,2),x2,y2);
            end
        end
        cumtheta = cumsum(thetas);
        type = find(cumtheta > theta, 1);
        if isempty(type)
            disp("边界反射未找到反射类型！");
            break;
        end
        switch type
            case 1
                %下边界发生镜面反射
                %利用斜率相等求交点
                y0 = grid.y.face(1);
                x0 = x1+(y0-y1)/(y2-y1)*(x2-x1);
                x2 = x2;
                y2 = -1*y2;
            case 2
                %右边界发生镜面反射
                x0 = grid.x.face(NX+1);
                y0 = y1+(y2-y1)/(x2-x1)*(x0-x1);
                x2 = 2*x0-x2;
                y2 = y2;
            case 3
                %漏极吸收
                item = 1;
                x0 = 0;
                y0 = 0;
                break;
            case 4
                %漏极/栅极之间发生镜面反射
                y0 = grid.y.face(NY+1);
                x0 = x1+(y0-y1)/(y2-y1)*(x2-x1);
                x2 = x2; %#ok<*ASGSL>
                y2 = 2*y0-y2;
            case 5
                %栅极发生漫反射
                y0 = grid.y.face(NY+1);
                x0 = x1+(y0-y1)/(y2-y1)*(x2-x1);
                rou = sqrt((x2-x0)^2+(y2-y0)^2);
                alpha = rand(1)*pi;
                x2 = x0+rou*cos(alpha);
                y2 = y0-rou*sin(alpha);
            case 6
                %源极/栅极之间发生镜面反射
                y0 = grid.y.face(NY+1);
                x0 = x1+(y0-y1)/(y2-y1)*(x2-x1);
                x2 = x2;
                y2 = 2*y0-y2;
            case 7
                %源极吸收
                item = 1;
                x0 = 0;
                y0 = 0;
                break;
            case 8
                %左边界发射镜面反射
                x0 = grid.x.face(1);
                y0 = y1+(y2-y1)/(x2-x1)*(x0-x1);
                x2 = -1*x2;
                y2 = y2;
        end
        %将交点作为新的起始点
        x1 = x0;
        y1 = y0;
    end
    %根据位矢调整速度方向
    p = [x2-x1, y2-y1];
    pLength = sqrt(sum(p.^2));
    p = p/pLength;
    electron.v(1:2) = velocity*p;
    electron.r = [x2, y2, z2];
    
end

% 单个电子飞行过程
function [electron] = FlyProcess(grid,electron,tf,XeField,YeField)
    % electron:单个电子信息
    % tf:自由飞行时间
    % XeField:x方向电场数据文件
    % YeField:y方向电场数据文件
    Macro;
    
    % 自由飞行段
    flag = Localization(electron);
    [xEfield, yEfield] = SearchEfield(electron.r(1), electron.r(2), XeField, YeField);
    electron.k(1) = electron.k(1) - e*xEfield*tf*flag/hbar;
    electron.k(2) = electron.k(2) - e*yEfield*tf*flag/hbar;
    electron = Ifbeyondbz(electron, 0);
    electron.energy = eBand(electron, 0);
    electron.v = eBand(electron, 1);
    % 边界反射
    rago = electron.r;
    electron.r(1) = electron.r(1) + abs(electron.v(1))*tf*flag;
    electron.r(2) = electron.r(2) - sign(yEfield)*abs(electron.v(2))*tf*flag;
    [electron, item] = MESFETBoundary(grid, rago, electron);
    Time = electron.time + tf;
    electron.time = Time;
    % 到达漏极被吸收,在源极重新生成超电子
    if item == 1
        electron = GenerateElectron(mbTop,mbTop,0,d1,electron.charge,EnergyInit);
        electron.time = Time;
    end

end

% 并行计算
function [phistory,electrons] = ParFunction(grid,electrons,XeField,YeField,sumSuperElecs)
    % electrons:电子信息结构体
    % XeField:电场向量
    % sumSuperElecs:总超电子数
    % nofScat:散射类型数
    Public;
    
    phistory = repmat(Phonon, sumSuperElecs, 1);
    parfor i = 1:sumSuperElecs
        % 自由飞行段
        tf = TimeForFly(); %#ok<*PFBNS>
        electrons(i) = FlyProcess(grid,electrons(i),tf,XeField,YeField);
        % 散射段
        type = ChooseScatType(electrons(i).energy);
        [phistory(i), electrons(i)] = EscatP(type, electrons(i),phistory(i)); %#ok<*SAGROW>
    end
    
end

% 分段模拟电子运动
function [pHistory,eHistory,electrons] = SubsectionParllel(grid,electrons,eHistory,...
                                           XeField,YeField,sumSuperElecs,pHistory,startk,endk)
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
        [phistory,electrons] = ParFunction(grid,electrons,XeField,YeField,sumSuperElecs);
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
        nDot(k).LA = zeros(NY+2, NX+2);
        nDot(k).TA = zeros(NY+2, NX+2);
        nDot(k).LO = zeros(NY+2, NX+2);
        nDot(k).TO = zeros(NY+2, NX+2);
        Q(k).LA = zeros(NY+2, NX+2);
        Q(k).TA = zeros(NY+2, NX+2);
        Q(k).LO = zeros(NY+2, NX+2);
        Q(k).TO = zeros(NY+2, NX+2);
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
        for j = 1:NY
            for i = 1:NX
                energyLAem = 0; energyLAab = 0;
                energyTAem = 0; energyTAab = 0;
                energyLOem = 0; energyLOab = 0;
                energyTOem = 0; energyTOab = 0;

                if ~isempty(pLAab)
                    r = [pLAab(:).r];
                    x = double(r(1:3:end-2)');
                    y = double(r(2:3:end-1)');
                    index1 = x > grid.x.face(i) & x < grid.x.face(i+1);
                    index2 = y > grid.y.face(j) & y < grid.y.face(j+1);
                    interPhonon = pLAab(index1 & index2);
                    energyLAab = sum([interPhonon(:).energy]);
                end
                if ~isempty(pLAem)
                    r = [pLAem(:).r];
                    x = double(r(1:3:end-2)');
                    y = double(r(2:3:end-1)');
                    index1 = x > grid.x.face(i) & x < grid.x.face(i+1);
                    index2 = y > grid.y.face(j) & y < grid.y.face(j+1);
                    interPhonon = pLAem(index1 & index2);
                    energyLAem = sum([interPhonon(:).energy]);
                end
                if ~isempty(pTAab)
                    r = [pTAab(:).r];
                    x = double(r(1:3:end-2)');
                    y = double(r(2:3:end-1)');
                    index1 = x > grid.x.face(i) & x < grid.x.face(i+1);
                    index2 = y > grid.y.face(j) & y < grid.y.face(j+1);
                    interPhonon = pTAab(index1 & index2);
                    energyTAab = sum([interPhonon(:).energy]);
                end
                if ~isempty(pTAem)
                    r = [pTAem(:).r];
                    x = double(r(1:3:end-2)');
                    y = double(r(2:3:end-1)');
                    index1 = x > grid.x.face(i) & x < grid.x.face(i+1);
                    index2 = y > grid.y.face(j) & y < grid.y.face(j+1);
                    interPhonon = pTAem(index1 & index2);
                    energyTAem = sum([interPhonon(:).energy]);
                end
                if ~isempty(pLOab)
                    r = [pLOab(:).r];
                    x = double(r(1:3:end-2)');
                    y = double(r(2:3:end-1)');
                    index1 = x > grid.x.face(i) & x < grid.x.face(i+1);
                    index2 = y > grid.y.face(j) & y < grid.y.face(j+1);
                    interPhonon = pLOab(index1 & index2);
                    energyLOab = sum([interPhonon(:).energy]);
                end
                if ~isempty(pLOem)
                    r = [pLOem(:).r];
                    x = double(r(1:3:end-2)');
                    y = double(r(2:3:end-1)');
                    index1 = x > grid.x.face(i) & x < grid.x.face(i+1);
                    index2 = y > grid.y.face(j) & y < grid.y.face(j+1);
                    interPhonon = pLOem(index1 & index2);
                    energyLOem = sum([interPhonon(:).energy]);
                end
                if ~isempty(pTOab)
                    r = [pTOab(:).r];
                    x = double(r(1:3:end-2)');
                    y = double(r(2:3:end-1)');
                    index1 = x > grid.x.face(i) & x < grid.x.face(i+1);
                    index2 = y > grid.y.face(j) & y < grid.y.face(j+1);
                    interPhonon = pTOab(index1 & index2);
                    energyTOab = sum([interPhonon(:).energy]);
                end
                if ~isempty(pTOem)
                    r = [pTOem(:).r];
                    x = double(r(1:3:end-2)');
                    y = double(r(2:3:end-1)');
                    index1 = x > grid.x.face(i) & x < grid.x.face(i+1);
                    index2 = y > grid.y.face(j) & y < grid.y.face(j+1);
                    interPhonon = pTOem(index1 & index2);
                    energyTOem = sum([interPhonon(:).energy]);
                end
                % 只能在极化支的频率定义域内进行计算
                if grid.w.point(k+1) >= wMinLA && grid.w.point(k+1) <= wMaxLA
                    Q(k).LA(j+1,i+1) = ne(j+1,i+1) * (energyLAem - energyLAab) / (sumSuperElecs*Deltat);
                    nDot(k).LA(j+1,i+1) = Q(k).LA(j+1,i+1) / (hbar*grid.w.point(k+1)*dos.LA(k+1)*deltaw)*xsfornDot;
                end
                if grid.w.point(k+1) >= wMinTA && grid.w.point(k+1) <= wMaxTA
                    Q(k).TA(j+1,i+1) = ne(j+1,i+1) * (energyTAem - energyTAab) / (sumSuperElecs*Deltat);
                    nDot(k).TA(j+1,i+1) = Q(k).TA(j+1,i+1) / (hbar*grid.w.point(k+1)*dos.TA(k+1)*deltaw)*xsfornDot;
                end
                if grid.w.point(k+1) >= wMinLO && grid.w.point(k+1) <= wMaxLO
                    Q(k).LO(j+1,i+1) = ne(j+1,i+1) * (energyLOem - energyLOab) / (sumSuperElecs*Deltat);
                    nDot(k).LO(j+1,i+1) = Q(k).LO(j+1,i+1) / (hbar*grid.w.point(k+1)*dos.LO(k+1)*deltaw)*xsfornDot;
                end
                if grid.w.point(k+1) >= wMinTO && grid.w.point(k+1) <= wMaxTO
                    Q(k).TO(j+1,i+1) = ne(j+1,i+1) * (energyTOem - energyTOab) / (sumSuperElecs*Deltat);
                    nDot(k).TO(j+1,i+1) = Q(k).TO(j+1,i+1) / (hbar*grid.w.point(k+1)*dos.TO(k+1)*deltaw)*xsfornDot;
                end
            end
        end
    end
    
end

% 用于确定n/nDot/Q量级大小
function [nn] = PlotSumnAndnDot(grid, n, name)
    % grid:网格结构体
    % n:n/nDot/Q结构体
    % name:画图类型
    Macro;
    
    nn = zeros(NX+2,1);
    for k = 1:NW
        nn = nn + n(k).LA + n(k).TA + n(k).LO + n(k).TO;
    end
    PlotDensity(grid,nn,name);
    
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
    
    n = zeros(NY+2,NX+2);
    fanshu1 = norm(n);
    fanshu2 = 1;
    vx = gv; vy = gv;
    while double(abs(fanshu1 - fanshu2)) > 1e-5
        for j = 1:NY
            for i = 1:NX
                aW = vx/deltax;
                aS = vy/deltay;
                aP = aW + aS + 1/tao;
                b = ndot(j+1, i+1);
                n(j+1,i+1) = (aW*n(j+1,i) + aS*n(j,i+1) + b) / aP;
            end
        end
        fanshu2 = fanshu1;
        fanshu1 = norm(n);
    end
    for j = 1:NY
        for i = 1:NX
            if n(j+1,i+1) < 0
                n(j+1,i+1) = 0;
            end
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

    sourceB = zeros(NY+2,NX+2);
    for j = 1:NY
        for i = 1:NX
            energyLA = 0; energyTA = 0;
            energyLO = 0; energyTO = 0;
            for k = 1:NW
                if grid.w.point(k+1) >= wMinLA && grid.w.point(k+1) <= wMaxLA
                    energyLA = energyLA + n(k).LA(j+1,i+1)*hbar*grid.w.point(k+1)*deltaw / (gv.LA(k+1)*tao.LA(k+1));
                end
                if grid.w.point(k+1) >= wMinTA && grid.w.point(k+1) <= wMaxTA
                    energyTA = energyTA + n(k).TA(j+1,i+1)*hbar*grid.w.point(k+1)*deltaw / (gv.TA(k+1)*tao.TA(k+1));
                end
                if grid.w.point(k+1) >= wMinLO && grid.w.point(k+1) <= wMaxLO
                    energyLO = energyLO + n(k).LO(j+1,i+1)*hbar*grid.w.point(k+1)*deltaw / (gv.LO(k+1)*tao.LO(k+1));
                end
                if grid.w.point(k+1) >= wMinTO && grid.w.point(k+1) <= wMaxTO
                    energyTO = energyTO + n(k).TO(j+1,i+1)*hbar*grid.w.point(k+1)*deltaw / (gv.TO(k+1)*tao.TO(k+1));
                end
            end
            sourceB(j+1,i+1) = xsforSourceB*(energyLA + energyTA + energyLO + energyTO) / (2*pi)^3;
        end
    end
    TF = SolveDiffusion(sourceB);
    
end

% 数值求解扩散温度
function [TF] = SolveDiffusion(sourceB)
    % sourceB:扩散方程源项
    Macro;

    TF = zeros(NY+2, NX+2) + T;
    fanshu1 = norm(TF);
    fanshu2 = 1;
    while double(abs(fanshu1-fanshu2)) > 1e-5
        for j = 1:NY
            for i = 1:NX
                aE = deltay*k / deltax;%k为热导张量
                aW = aE;
                aN = deltax*k / deltay;
                aS = aN;
                b = sourceB(j+1,i+1)*deltax*deltay;
                if j == 1; aS = aS * 2; end
                if j == NY; aN = aN * 2; end
                if i == 1; aW = aW * 2; end
                if i == NX; aE = aE * 2; end
                aP = aE + aW + aN + aS;
                TF(j+1,i+1) = (aE*TF(j+1,i+2)+aW*TF(j+1,i)+aN*TF(j+2,i+1)+aS*TF(j,i+1)+b)/aP;
            end
        end
        fanshu2 = fanshu1;
        fanshu1 = norm(TF);
    end

end

% 求等效温度
function [Teff] = ComputeTeff(grid,TF,n,gv)
    % grid:网格结构体
    % TF:扩散温度
    % n:远平衡分布函数
    % gv:群速度结构体
    Macro;
    ScatterringCurve;

    Teff = zeros(NY+2, NX+2) + T;
    energyLeft = zeros(NY+2, NX+2);
    energyRight = zeros(NY+2, NX+2);
    % 循环控制变量
    number = 2000;
    deltaT = 0.1;
    errorMax = 1e-3;
    
    for j = 1:NY
        for i = 1:NX
            error = zeros(number, 1);
            flag = -1;% 用于控制温度增减
            for p = 1:number
                % 方程左边
                energyLA = 0; energyTA = 0;
                energyLO = 0; energyTO = 0;
                for k = 1:NW
                    NLeft = 1 / (exp(hbar*grid.w.point(k+1) / (kb*Teff(j+1,i+1))) - 1);
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
                energyLeft(j+1,i+1) = (energyLA + energyTA + energyLO + energyTO) / (2*pi)^3;
                % 方程右边
                energyLA = 0; energyTA = 0;
                energyLO = 0; energyTO = 0;
                for k = 1:NW
                    NRight = 1 / (exp(hbar*grid.w.point(k+1) / (kb*TF(j+1,i+1))) - 1);
                    if grid.w.point(k+1) >= wMinLA && grid.w.point(k+1) <= wMaxLA
                        energyLA = energyLA + (n(k).LA(j+1,i+1) + NRight)*hbar*grid.w.point(k+1)*deltaw / gv.LA(k+1);
                    end
                    if grid.w.point(k+1) >= wMinTA && grid.w.point(k+1) <= wMaxTA
                        energyTA = energyTA + (n(k).TA(j+1,i+1) + NRight)*hbar*grid.w.point(k+1)*deltaw / gv.TA(k+1);
                    end
                    if grid.w.point(k+1) >= wMinLO && grid.w.point(k+1) <= wMaxLO
                        energyLO = energyLO + (n(k).LO(j+1,i+1) + NRight)*hbar*grid.w.point(k+1)*deltaw / gv.LO(k+1);
                    end
                    if grid.w.point(k+1) >= wMinTO && grid.w.point(k+1) <= wMaxTO
                        energyTO = energyTO + (n(k).TO(j+1,i+1) + NRight)*hbar*grid.w.point(k+1)*deltaw / gv.TO(k+1);
                    end
                end
                energyRight(j+1,i+1) = (energyLA + energyTA + energyLO + energyTO) / (2*pi)^3;
                % 左右校准
                error(p) = double(abs((energyRight(j+1,i+1) - energyLeft(j+1,i+1)) / energyRight(j+1,i+1)));
                if error(p) < errorMax
                    break;
                end
                if p >= 2 && (error(p) - error(p-1)) > 0
                    flag = -1*flag;
                end
                Teff(j+1,i+1) = Teff(j+1,i+1) + flag*deltaT;
            end
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
    Teff = zeros(NY+2, NX+2) + T;
    energyLeft = zeros(NY+2, NX+2);
    energyRight = zeros(NY+2, NX+2);
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
    
    for j = 1:NY
        for i = 1:NX
            error = zeros(number, 1);
            flag = -1;% 用于控制温度增减
            for p = 1:number
                % 方程左边
                energy = 0;
                for k = 1:NW
                    NLeft = 1 / (exp(hbar*grid.w.point(k+1) / (kb*Teff(j+1,i+1))) - 1);
                    if grid.w.point(k+1) >= wMin && grid.w.point(k+1) <= wMax
                        energy = energy + NLeft*hbar*grid.w.point(k+1)*deltaw / gvelocity(k+1);
                    end
                end
                energyLeft(j+1,i+1) = energy / (2*pi)^3;
                % 方程右边
                energy = 0;
                for k = 1:NW
                    NRight = 1 / (exp(hbar*grid.w.point(k+1) / (kb*TF(j+1,i+1))) - 1);
                    if grid.w.point(k+1) >= wMin && grid.w.point(k+1) <= wMax
                        energy = energy + (nn(k).LA(j+1,i+1) + NRight)*hbar*grid.w.point(k+1)*deltaw / gvelocity(k+1);
                    end
                end
                energyRight(j+1,i+1) = energy / (2*pi)^3;
                % 左右校准
                error(p) = double(abs((energyRight(j+1,i+1) - energyLeft(j+1,i+1)) / energyRight(j+1,i+1)));
                if error(p) < errorMax
                    break;
                end
                if p >= 2 && (error(p) - error(p-1)) > 0
                    flag = -1*flag;
                end
                Teff(j+1,i+1) = Teff(j+1,i+1) + flag*deltaT;
            end
        end
    end

end

% 等效温度画图
function [] = PlotTeff(grid,Teff,name)
    % grid:网格
    % Teff:等效温度向量
    % name:变量名称
    Macro;
    
    PlotDensity(grid,Teff,name);
    
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
            positions = zeros(noFly+1,2);
            times = zeros(noFly+1,1);
            for i = 1:noFly+1
                times(i) = eHistory(num,i).time;
                positions(i,1) = eHistory(num,i).r(1);
                positions(i,2) = eHistory(num,i).r(2);
            end
            figure
            rectangle('Position',[0 0 mLength*1e9 mWidth*1e9]);
            hold on;
            plot(positions(:,1)*1e9,positions(:,2)*1e9,'-');
            xlabel('nm');ylabel('nm');
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
    slg = semilogy(grid.x.point(:)*1e9,aveEnergyDisp(:)/e);
    slg.LineWidth = 2;
    xlabel('nm');ylabel('eV');
    legend("average electron energy")
    
end

% 输出二维dat文件
function [backvalue] = Write2datFile(name,xvalue,yvalue)
    % name:文件名
    % xvalue:横轴变量值
    % yvalue:纵轴变量值
    Macro;
    
    backvalue = zeros(length(xvalue),2);
    fid = fopen(name, 'w+');
    for k = 1:length(xvalue)
        backvalue(k,1) = xvalue(k);
        backvalue(k,2) = yvalue(k);
        fprintf(fid, '%.2f\t', backvalue(k,1));
        fprintf(fid, '%.2f\n', backvalue(k,2));
    end
    fclose(fid);
    
end

%输出3维dat文件
function [backvalue] = Write3datFile(name, grid, value)
%      name------------文件名
%      grid------------网格
%      value-----------二维矩阵

    Macro;
    
    backvalue = zeros(NX*NY,3);
    fid = fopen(name, 'w+');
    for i = 2:NX + 1
       for j = 2:NY + 1
           k = NY*(i-2)+j-1;
           backvalue(k,1) = grid.x.face(i)*1e9;
           backvalue(k,2) = grid.y.face(j)*1e9;
           backvalue(k,3) = value(j, i);
           fprintf(fid, '%.2f\t', backvalue(k,1));
           fprintf(fid, '%.2f\t', backvalue(k,2));
           fprintf(fid, '%.2f\n', backvalue(k,3));
       end
    end
    fclose(fid);

end

























