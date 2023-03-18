function buildModelNodes(obj)
    %>建立节点坐标
    obj.nodes = zeros(8, 2);
    obj.nodes(1,:) = [obj.modelx.face(1), obj.modely.face(1)];
    obj.nodes(2,:) = [obj.modelx.face(obj.NX+1), obj.modely.face(1)];
    obj.nodes(3,:) = [obj.modelx.face(obj.NX+1), obj.modely.face(obj.NY+1)];
    obj.nodes(4,:) = [obj.modelx.face(obj.NX+1) - obj.d5, obj.modely.face(obj.NY+1)];
    obj.nodes(5,:) = [obj.modelx.face(1) + obj.d1 + obj.d2 + obj.d3, obj.modely.face(obj.NY+1)];
    obj.nodes(6,:) = [obj.modelx.face(1) + obj.d1 + obj.d2, obj.modely.face(obj.NY+1)];
    obj.nodes(7,:) = [obj.modelx.face(1) + obj.d1, obj.modely.face(obj.NY+1)];
    obj.nodes(8,:) = [obj.modelx.face(1), obj.modely.face(obj.NY+1)];
end