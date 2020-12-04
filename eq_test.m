A = [-0.1, 0.2;
    -1, 0.4];
B = [1,0;
    0,1];
a = [-0.2; 
    -0.1];

load("S.mat")

for j = 1:length(S)
    [K, g] = ctrl_in(S(j));
    xe = - (A + B*K)\(g+a);
    inpolygon(xe(1,1), xe(2,1), S(j).v(1,:), S(j).v(2,:))
    j
end
