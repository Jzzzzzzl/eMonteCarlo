%% 材料验证
clc,clear;
close all;

Macro;
Public;
myfuns = Funs;

%% 计算部分
% 划分网格
grid = myfuns.AllGrid();
% 预分配内存
electrons = repmat(Electron,SuperElecs,1);
eHistory = repmat(Electron,SuperElecs,noFly);
pHistory = repmat(Phonon,SuperElecs,noFly);

% 初始化电子群信息
electrons = myfuns.InitializeInfor(electrons);

% 开始计算
[pHistory,eHistory,electrons] = myfuns.SubsectionParllel(electrons,eHistory,pHistory);
% 总飞行时间
myfuns.TotalFlyTime(eHistory);
% 迁移率
myfuns.ElectronMobility(eHistory);
% 漂移速度
myfuns.ElectronDirftVelocity(eHistory);


%% 后处理
% 能量分布图
myfuns.ElectronEnergyDistribution(0,2.5,100,eHistory);
% 平均能量随时间变化图
aveEnergyTime = myfuns.AverageEnergyTime(eHistory);
% 声子发射图
[frequency,~] = myfuns.StatisticPhonon(grid,pHistory);
wNum = myfuns.PhononEmSpectrum(grid,frequency);
% 漂移速度随时间变化图
myfuns.DirftVelocityToTime(eHistory);
% 散射种类分布
myfuns.ScatTypeDistribution(eHistory);



% 电子信息展示
myfuns.ElectronInformation(eHistory(2,911))
% 散射率画图
myfuns.PlotScatterringRate(logspace(-3,1,100)*e);
% 某个电子轨迹图/能谷转移图/能量随位置变化图
myfuns.ElectronTrace(eHistory,1,'r');
myfuns.ElectronTrace(eHistory,282,'e');
myfuns.ElectronTrace(eHistory,1,'k');
% 电子能带画图
energyGX = myfuns.eBandPlot(50);
% Maxwell速度分布画图
myfuns.PlotMaxwell(0,driftVelocity,5000,100)
% 程序验证
myfuns.VerifyProgram(1);


ii = 7;
xx = zeros(noFly,1);
yy = zeros(noFly,1);
for j = 1:noFly
    xx(j) = eHistory(ii,j).r(1);
    yy(j) = eHistory(ii,j).r(2);
end
plot(xx,yy,'-')


nums = 10000;
a = [1, -1, 2, -2, 3, -3];
value = zeros(nums,1);
mmm = zeros(6,1);
for i = 1:nums
    index = round(myfuns.Random(0.5, 6.5));
    value(i) = a(index);
end
for i = 1:6
    index = value==a(i);
    mmm(i) = sum(double(index));
end
bar(mmm)

p = eHistory(10,212)
sqrt(sum(p.v.^2))
p = myfuns.ChooseFinalK2(p)
sqrt(sum(p.v.^2))
