%% 一维模型主程序
clc,clear

Macro;
Public;
myfuns = Funs;
load TotalDoping.dat
load Eleconc.dat
load XeField.dat
load YeField.dat

% 网格信息
grid = myfuns.AllGrid();
% 分段计算索引表
kArray = myfuns.Karray();
% 群速度/态密度/弛豫时间表
[gv, dos, tao] = myfuns.GroupVelocityDOSTao(grid);
% 生成掺杂浓度分布信息
dopDensity = myfuns.ReadDopDensity(grid, TotalDoping);
% 根据掺杂信息计算超电子电荷量
superElecCharge = myfuns.ComputeSuperCharge(dopDensity);

%% 第二部分
% 预分配内存
electrons = repmat(Electron,sumSuperElecs,1);
eHistory = repmat(Electron,sumSuperElecs,noFly+1);
pHistory = repmat(Phonon,sumSuperElecs,noFly);

% 初始化电子群信息
electrons = myfuns.InitializeInfor(electrons,superElecCharge);
% 记录初始电子群信息
eHistory(:,1) = electrons;

% 开始计算
linenum = size(kArray);
for m = 1:linenum(1)
    tic
    [pHistory,eHistory,electrons] = myfuns.SubsectionParllel(grid,electrons,...
                                           eHistory,XeField,YeField,sumSuperElecs,...
                                           pHistory,kArray(m,1),kArray(m,2));
    toc
end
%% 第三部分
% 计算平均总模拟时间,用于更改timeEnd
myfuns.TotalFlyTime(eHistory)

% 求解BTE及等效温度
ne = myfuns.ReadEleconc(grid, Eleconc);
[frequency,phonons] = myfuns.StatisticPhonon(grid,pHistory);
[nDot, Q] = myfuns.HeatGeneration(grid,ne,frequency,phonons,dos);
n = myfuns.FarDistributionFunction(gv,tao,nDot);


% 用于确定n和ndot量级大小
nnDot = myfuns.PlotSumnAndnDot(grid, nDot, "nnDot");
nn = myfuns.PlotSumnAndnDot(grid, n, "nn");
QQ = myfuns.PlotSumnAndnDot(grid, Q, "QQ");

%% 第四部分
TF = myfuns.ComputeTF(grid,n,gv,tao);
Teff = myfuns.ComputeTeff(grid,TF,n,gv);
LATeff = myfuns.PolarTeff(grid,TF,n,gv,'LA');
TATeff = myfuns.PolarTeff(grid,TF,n,gv,'TA');
LOTeff = myfuns.PolarTeff(grid,TF,n,gv,'LO');
TOTeff = myfuns.PolarTeff(grid,TF,n,gv,'TO');

%% 第五部分
% 等效温度画图
myfuns.PlotTeff(grid, TF, "TF");
myfuns.PlotTeff(grid, Teff, "Teff");
myfuns.PlotTeff(grid, LATeff, "LATeff");
myfuns.PlotTeff(grid, TATeff, "TATeff");
myfuns.PlotTeff(grid, LOTeff, "LOTeff");
myfuns.PlotTeff(grid, TOTeff, "TOTeff");

% 掺杂浓度画图
myfuns.PlotDensity(grid,dopDensity,"dopDensity");
% 电子浓度画图
myfuns.PlotDensity(grid,ne,"elecDensity");
% 电场画图
[xeField,yeField] = myfuns.ReadElectricField(grid,XeField,YeField);
myfuns.PlotElectricField(grid,xeField,"xeField");
myfuns.PlotElectricField(grid,yeField,"yeField");
eField = myfuns.TotalElecField(xeField,yeField);
myfuns.PlotElectricField(grid,eField,"eField");
% 散射率画图
myfuns.PlotScatterringRate((0.01:0.08:1.3)*e)
% Maxwell速度分布画图
myfuns.PlotMaxwell(0,4e5,1000)
% 某个电子轨迹图/能谷转移图/能量随位置变化图
myfuns.ElectronTrace(eHistory,2,'r');
% 电子群平均能量随时间变化图
aveEnergyTime = myfuns.AverageEnergyTime(grid,eHistory);
% 电子平均能量随位置变化图
aveEnergyDisp = myfuns.AverageEnergyDisplace(grid,eHistory);

%% 第六部分
% 输出数据
myfuns.Write2datFile("LOTeff.dat","x","LOTeff",grid.x.point(:)*1e9,LOTeff);
















