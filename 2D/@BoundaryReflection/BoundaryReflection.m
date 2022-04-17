classdef BoundaryReflection < handle
    %% 
    properties
        dSource
        pGate%>起始点
        dGate
        dDrain
        nodes
    end
    
    methods
        function buildModelNodes(obj, mm)
            %>建立节点坐标
            obj.nodes = zeros(8, 2);
            obj.nodes(1,:) = [mm.modelx.face(1), mm.modely.face(1)];
            obj.nodes(2,:) = [mm.modelx.face(mm.NX+1), mm.modely.face(1)];
            obj.nodes(3,:) = [mm.modelx.face(mm.NX+1), mm.modely.face(mm.NY+1)];
            obj.nodes(4,:) = [mm.modelx.face(mm.NX+1) - obj.dDrain, mm.modely.face(mm.NY+1)];
            obj.nodes(5,:) = [mm.modelx.face(1) + obj.pGate + obj.dGate, mm.modely.face(mm.NY+1)];
            obj.nodes(6,:) = [mm.modelx.face(1) + obj.pGate, mm.modely.face(mm.NY+1)];
            obj.nodes(7,:) = [mm.modelx.face(1) + obj.dSource, mm.modely.face(mm.NY+1)];
            obj.nodes(8,:) = [mm.modelx.face(1), mm.modely.face(mm.NY+1)];
        end
    end
    
    methods
        [bool] = boundaryReflection(obj, mm, rAgo, es)
    end
    
    methods(Static)
        [theta] = directAngle(x1, y1, x2, y2, x3, y3)
    end
end