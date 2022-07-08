function [a] = sumall(~)
    %>
    a = 0;
    NX = evalin('base', 'NX');
    NY = evalin('base', 'NY');
    z = evalin('base', 'z');
    cc = evalin('base', 'cc');
    disp(cc.initTemp);
    for i = 1 : NX
        for j = 1 : NY
            a = a + z(i, j);
        end
    end
end