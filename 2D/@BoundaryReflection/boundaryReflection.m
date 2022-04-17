function [bool] = boundaryReflection(obj, mm, rAgo, es)
    %>MESFET型结构边界反射
    bool = false;
    rAfter = es.position;
    velocityTemp = sqrt(sum(es.velocity(1:2).^2));
    
    x1 = rAgo(1);y1 = rAgo(2);z1 = rAgo(3);
    x2 = rAfter(1);y2 = rAfter(2);z2 = rAfter(3);
    
    while x2 < mm.modelx.face(1) || x2 > mm.modelx.face(end) ||...
            y2 < mm.modely.face(1) || y2 > mm.modely.face(end)
        thetas = zeros(8, 1);
        thetas(1) = obj.directAngle(x1,y1,obj.nodes(1,1),obj.nodes(1,2),obj.nodes(2,1),obj.nodes(2,2));
        thetas(2) = obj.directAngle(x1,y1,obj.nodes(2,1),obj.nodes(2,2),obj.nodes(3,1),obj.nodes(3,2));
        thetas(3) = obj.directAngle(x1,y1,obj.nodes(3,1),obj.nodes(3,2),obj.nodes(4,1),obj.nodes(4,2));
        thetas(4) = obj.directAngle(x1,y1,obj.nodes(4,1),obj.nodes(4,2),obj.nodes(5,1),obj.nodes(5,2));
        thetas(5) = obj.directAngle(x1,y1,obj.nodes(5,1),obj.nodes(5,2),obj.nodes(6,1),obj.nodes(6,2));
        thetas(6) = obj.directAngle(x1,y1,obj.nodes(6,1),obj.nodes(6,2),obj.nodes(7,1),obj.nodes(7,2));
        thetas(7) = obj.directAngle(x1,y1,obj.nodes(7,1),obj.nodes(7,2),obj.nodes(8,1),obj.nodes(8,2));
        thetas(8) = obj.directAngle(x1,y1,obj.nodes(8,1),obj.nodes(8,2),obj.nodes(1,1),obj.nodes(1,2));
        %>求由点obj.nodes(1, :)和(x2, y2)构成的直线在x1处的值y21
        k1 = (y2 - obj.nodes(1, 2)) / (x2 - obj.nodes(1, 1));
        y21 = k1*(x1-obj.nodes(1,1))+obj.nodes(1,2);
        %>求由点(x1, y1)和点(x2, y2)构成的直线在obj.nodes(1, 1)处的值y20
        k2 = (y2 - y1) / (x2 - x1);
        y20 = k2*(obj.nodes(1, 1) - x1) + y1;
        if x2 > 0
            if y21 <= y1
                theta = obj.directAngle(x1,y1,obj.nodes(1,1),obj.nodes(1,2),x2,y2);
            else
                theta = 2*pi - obj.directAngle(x1,y1,obj.nodes(1,1),obj.nodes(1,2),x2,y2);
            end
        else
            if y20 < 0
                theta = obj.directAngle(x1,y1,obj.nodes(1,1),obj.nodes(1,2),x2,y2);
            else
                theta = 2*pi - obj.directAngle(x1,y1,obj.nodes(1,1),obj.nodes(1,2),x2,y2);
            end
        end
        cumtheta = cumsum(thetas);
        type = find(cumtheta > theta, 1);
        switch type
            case 1
                %下边界发生镜面反射
                %利用斜率相等求交点
                y0 = mm.modely.face(1);
                x0 = x1 + (y0 - y1) / (y2 - y1)*(x2 - x1);
                x2 = x2;
                y2 = -1*y2;
            case 2
                %右边界发生镜面反射
                x0 = mm.modelx.face(mm.NX+1);
                y0 = y1 + (y2 - y1) / (x2 - x1)*(x0-x1);
                x2 = 2*x0 - x2;
                y2 = y2;
            case 3
                %漏极吸收
                bool = true;
                x0 = 0;
                y0 = 0;
                break;
            case 4
                %漏极/栅极之间发生镜面反射
                y0 = mm.modely.face(mm.NY+1);
                x0 = x1 + (y0 - y1) / (y2 - y1)*(x2 - x1);
                x2 = x2; %#ok<*ASGSL>
                y2 = 2*y0 - y2;
            case 5
                %栅极发生漫反射
                y0 = mm.modely.face(mm.NY+1);
                x0 = x1 + (y0 - y1) / (y2 - y1)*(x2 - x1);
                rou = sqrt((x2 - x0)^2+(y2 - y0)^2);
                alpha = rand*pi;
                x2 = x0 + rou*cos(alpha);
                y2 = y0 - rou*sin(alpha);
            case 6
                %源极/栅极之间发生镜面反射
                y0 = mm.modely.face(mm.NY+1);
                x0 = x1 + (y0 - y1) / (y2 - y1)*(x2 - x1);
                x2 = x2;
                y2 = 2*y0 - y2;
            case 7
                %源极吸收
                bool = true;
                x0 = 0;
                y0 = 0;
                break;
            case 8
                %左边界发射镜面反射
                x0 = mm.modelx.face(1);
                y0 = y1 + (y2 - y1) / (x2 - x1)*(x0 - x1);
                x2 = -1*x2;
                y2 = y2;
            otherwise
                error("边界反射未找到反射类型！");
        end
        %将交点作为新的起始点
        x1 = x0;
        y1 = y0;
    end
    %根据位矢调整速度方向
    p = [x2 - x1, y2 - y1];
    es.velocity(1:2) = velocityTemp*p/sqrt(sum(p.^2));
    es.position = [x2, y2, z2];
    
end