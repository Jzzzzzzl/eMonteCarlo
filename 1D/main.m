%% 一维模型主程序
clc,clear

Macro;
Public;
myfuns = Funs;
load XeField.dat
load Eleconc.dat

% 网格信息
grid = myfuns.AllGrid();
% 分段计算索引表
kArray = myfuns.Karray();
% 群速度/态密度/弛豫时间表
[gv, dos, tao] = myfuns.GroupVelocityDOSTao(grid);
% 生成掺杂浓度分布信息
dopDensity = myfuns.GaussDopDensity();
% 根据掺杂信息计算超电子电荷量
[lightCharge,heavyCharge] = myfuns.ComputeSuperCharge(dopDensity);
% 根据高斯分布生成能量衰减矩阵
EnergyDecay = myfuns.EnergyDecayArray();

%% 第二部分
% 预分配内存
electrons = repmat(Electron,sumSuperElecs,1);
eHistory = repmat(Electron,sumSuperElecs,noFly+1);
pHistory = repmat(Phonon,sumSuperElecs,noFly);

% 初始化电子群信息
electrons = myfuns.InitializeInfor(electrons,lightCharge,heavyCharge);
% 记录初始电子群信息
eHistory(:,1) = electrons;

% 开始计算
linenum = size(kArray);
for m = 1:linenum(1)
    tic
    [pHistory,eHistory,electrons] = myfuns.SubsectionParllel(electrons,eHistory,XeField,...
                                           EnergyDecay,pHistory,kArray(m,1),kArray(m,2));
    toc
end
%% 第三部分
% 计算平均总模拟时间,用于更改timeEnd
myfuns.TotalFlyTime(eHistory);

% 求解BTE及等效温度
ne = myfuns.ElectronConc(grid,Eleconc);
[frequency,phonons] = myfuns.StatisticPhonon(grid,pHistory);
[nDot, Q] = myfuns.HeatGeneration(grid,ne,frequency,phonons,dos);
n = myfuns.FarDistributionFunction(gv,tao,nDot);

% 用于确定n和ndot量级大小
nnDot = myfuns.PlotSumnAndnDot(grid, nDot, 'nnDot','ALL');
nn = myfuns.PlotSumnAndnDot(grid, n, 'nn','ALL');
QQ = myfuns.PlotSumnAndnDot(grid, Q, 'QQ','ALL');
% 等效温度的形状与nn各极化支是一样的
nnLA = myfuns.PlotSumnAndnDot(grid, n, 'nnLA', 'LA');
nnTA = myfuns.PlotSumnAndnDot(grid, n, 'nnTA', 'TA');
nnLO = myfuns.PlotSumnAndnDot(grid, n, 'nnLO', 'LO');
nnTO = myfuns.PlotSumnAndnDot(grid, n, 'nnTO', 'TO');

%% 第四部分
TF = myfuns.ComputeTF(grid,n,gv,tao);
Teff = myfuns.ComputeTeff(grid,TF,n,gv);
LATeff = myfuns.PolarTeff(grid,TF,n,gv,'LA');
TATeff = myfuns.PolarTeff(grid,TF,n,gv,'TA');
LOTeff = myfuns.PolarTeff(grid,TF,n,gv,'LO');
TOTeff = myfuns.PolarTeff(grid,TF,n,gv,'TO');

% 等效温度画图
TE = [TF,LATeff];
myfuns.PlotTeff(grid,TE,["TF","Teff"]);
TE = [TF,Teff,LATeff,TATeff,LOTeff,TOTeff];
myfuns.PlotTeff(grid,TE,["TF","Teff","LATeff","TATeff","LOTeff","TOTeff"]);

%% 第五部分
% 掺杂浓度画图
myfuns.PlotDensity(grid, dopDensity, 'dop density')
% 电子浓度画图
myfuns.PlotDensity(grid, ne, 'electron density')
% 散射率画图
myfuns.PlotScatterringRate((0.01:0.08:1.3)*e)
% Maxwell速度分布画图
myfuns.PlotMaxwell(0,4e5,1000)
% 某个电子轨迹图/能谷转移图/能量随位置变化图
myfuns.ElectronTrace(eHistory,1,'r');
% 电子群平均能量随时间变化图
aveEnergyTime = myfuns.AverageEnergyTime(grid,eHistory);
% 电子平均能量随位置变化图
aveEnergyDisp = myfuns.AverageEnergyDisplace(grid,eHistory);
% 声子发射谱
wNum = myfuns.PhononEmSpectrum(grid,frequency);
% 声子实际分布函数
distribution = myfuns.PhononDistribution(grid,n,'ALL',185e-9);

%% 第六部分
% 输出数据
myfuns.Write2datFile("Teff.dat","x","Teff",grid.x.point(:)*1e9,Teff);
myfuns.Write2datFile("LOTeff.dat","x","LOTeff",grid.x.point(:)*1e9,LOTeff);
myfuns.Write2datFile("LATeff.dat","x","LATeff",grid.x.point(:)*1e9,LATeff);
myfuns.Write2datFile("TATeff.dat","x","TATeff",grid.x.point(:)*1e9,TATeff);
myfuns.Write2datFile("TOTeff.dat","x","TOTeff",grid.x.point(:)*1e9,TOTeff);
myfuns.Write2datFile("QQ.dat","x","W/m^{3}",grid.x.point(:)*1e9,QQ);
myfuns.Write2datFile("wNum.dat","numbers","energy",wNum(:,1),wNum(:,2));

myfuns.Write2datFile("distribution.dat","energy",".a.u",distribution(:,1),distribution(:,2));
myfuns.Write2datFile("bose-einstan.dat","energy",".a.u",distribution(:,1),distribution(:,3));




