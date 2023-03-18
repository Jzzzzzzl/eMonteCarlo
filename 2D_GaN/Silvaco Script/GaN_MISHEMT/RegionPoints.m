classdef RegionPoints
    %% 用于定义每个区域
    
    properties
        points
        coord
    end
    
    methods
        function obj = regionpoints(obj, nums)
            %构造函数
            obj.points = nums;
            obj.coord = zeros(nums, 2);
        end
        
    end
end

