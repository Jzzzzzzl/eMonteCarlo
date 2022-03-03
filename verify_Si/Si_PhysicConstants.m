% Material = 'Si'

global a                            %晶格常数
global c
global mt                          %有效质量分量
global ml
global md                          %态密度有效质量
global rho                          %密度
global ul                            %纵向声速
global ut                           %横向声速
% 电子谷间散射所需参数
global gDKTA                     %耦合常数
global gDKLA
global gDKLO
global fDKTA
global fDKLA
global fDKTO
global dGX                         %Gamma到X距离
global bzR                          %第一布里渊区等效半径
global qf                            %f型谷间散射平均声子波矢大小
global qg                           %g型谷间散射平均声子波矢大小
% 电子谷内散射所需参数
global DLA                         %各向同性平均形变势
global DTA
global qintra                       %谷内散射平均声子波矢大小



a = 5.431e-10;
c = 3.867e-10; 
mt = 0.196*m;
ml = 0.916*m;
md = (mt^2*ml)^(1/3);
rho = 2330;
ul = 9.2e3;
ut = 4.7e3;

gDKTA = 0.5e10*e;
gDKLA = 0.8e10*e;
gDKLO =  11e10*e;
fDKTA = 0.3e10*e;
fDKLA =   2e10*e;
fDKTO =   2e10*e;
dGX = 2*pi/a;
bzR = (5/pi)^(1/3)*dGX;
qf = 0.95*dGX;
qg = 0.3*dGX;

DLA = 6.39*e;
DTA = 3.01*e;
qintra = 0.15*dGX;


