clear all; clc;
% Level 1 : feasibility

A = [-1 -1 ;
    -2  1]; 
B = [2 -2]';
c = [3 1]';



v1 = [-1,0]';
v2 = [1,1]';
v3 = [1,-1]';

N = [0 1; -1 0];

h1 = N*(v2-v3);
h1 = h1/norm(h1);
if (h1'*(v2-v1)) <= 0
    h1 = -h1;
end

h2 = N*(v3-v1);
h2 = h2/norm(h2);
if (h2'*(v3-v2)) <= 0
    h2 = -h2;
end

h3 = N*(v1-v2);
h3 = h3/norm(h3);
if (h3'*(v1-v3)) <= 0
    h3 = -h3;
end


cvx_begin sdp
variable u1
variable u2
variable u3

minimize((norm(.25 - [u1,u2,u3]*[.5;.5;0]) + norm([u1,u2,u3])))

% invariance conditions
h2'*(A*v1 + B*u1 +c) <= 0
h3'*(A*v1 + B*u1 +c) <= 0
h3'*(A*v2 + B*u2 +c) <= 0
h2'*(A*v3 + B*u3 +c) <= 0

% flow conditions
h1'*(A*v2 + B*u2 +c) >= 0
h1'*(A*v3 + B*u3 +c) >= 0

u1 <= 1;
u2 <= 1;
u3 <= 1;
u1 >= -1;
u2 >= -1;
u3 >= -1;

cvx_end

u1 
u2
u3
