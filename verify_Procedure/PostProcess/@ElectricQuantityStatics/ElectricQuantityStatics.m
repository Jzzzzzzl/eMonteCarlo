classdef ElectricQuantityStatics < handle
    %% 后处理类
    properties(Constant)
        e = 1.602176634e-19;
    end
    
    properties
        totalTime
        mobility
        driftVelocity
    end
    
    methods
        function obj = ElectricQuantityStatics(sh, cc)
            %>构造函数
            obj.averageTotalFlyTime(sh, cc);
            obj.electronDirftVelocity(sh, cc);
        end
        
        function averageTotalFlyTime(obj, sh, cc)
            %>计算平均总飞行时间
            time = zeros(cc.superElecs, 1);
            for i = 1 : cc.superElecs
                time(i) = sh.eHistory(i, end).time;
            end
            obj.totalTime = sum(time) / cc.superElecs;
            disp(['总模拟时间： ', num2str(obj.totalTime * 1e12), '  ps']);
        end
        
        function electronDirftVelocity(obj, sh, cc)
            %>计算漂移速度
            velocity = zeros(cc.superElecs, 1);
            for i = 1 : cc.superElecs
                for j = 1 : cc.noFly
                    velocity(i) = velocity(i) + sh.eHistory(i, j).perdrift;
                end
            end
            obj.driftVelocity = sum(velocity) / (cc.superElecs * cc.noFly);
            disp(['电子漂移速度为： ', num2str(obj.driftVelocity * 100), '  cm/s']);
        end
        
        function electronMobility(~)
            %>计算迁移率
            disp(['电子迁移率为： ', num2str(miu), '  cm^2/(V*s)']);
        end
        
    end
    
end