function dx = f(t, x, S)
global j
% linear system 
A = [-0.1, 0.2;
    -1, 0.4];
B = [1,0;
    0,1];
a = [-0.2; 
    -0.1];
Si = which_splx(x, S);
[K, g] = ctrl_in(Si);
u = K*x + g;
dx = A*x + B*u + a;
end