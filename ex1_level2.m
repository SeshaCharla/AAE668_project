clear all; clc;
% Level 2 : Point generation

A = [-1 -1 ;
    -2  1]; 
B = [2 -2]';
a = [3 1]';



v1 = [-1,0]';
v2 = [1,1]';
%v3 = [1,-1]';
v3 = [3, -2]';

N = [0 1; -1 0];

N1 = N;
h1 = N1*(v2-v3);
if (h1'*(v2-v1)) <= 0
    h1 = -h1;
    N1 = -N1;
end

N2 = N;
h2 = N2*(v3-v1);
if (h2'*(v3-v2)) <= 0
    h2 = -h2;
    N2 = -N2;
end

N3 = N;
h3 = N3*(v1-v2);
if (h3'*(v1-v3)) <= 0
    h3 = -h3;
    N3 = -N3;
end

% Qf1 = [0, 0.5*(N1*(v1-v3))'*B;
%        (0.5*(N1*(v1-v3))'*B)', 0];
% iQf1 = inv(Qf1);
%   
% qf1 = [ (N1*(v1-v3))'*(A*v2 + a);
%          (N1*(v2-v1))' * B];
% rf1 = (N1*(v2-v1))' * (A*v2 + a);
% 
% Qf2 = [(N1*(v1-v2))'*A*(v3 - v1), 0.5*(N1*(v1-v3))'*B;
%        (0.5*(N1*(v1-v3))'*B)', 0];
% iQf2 = inv(Qf2);
% rf2 = (N1*(v1-v3))'*(A*v1 + a);
%    
% qf2 = [rf2 + (N1*(v2-v1))'*A*(v3-v1);
%              (N1*(v2-v1))'*B];
         
qi4 = [ (N2*(v3-v1))' * A * (v3 - v1);
         (N2*(v3-v1))'*B];
ri4 = (N2*(v3-v1))'*(A*v1 + a);

z = (-h1 -h2 +h3)/3;

qf = [ z' * A * (v3 - v1);
       z'*B];
rf = z'*(A*v1 + a);

cvx_begin 
variable u1
variable u2
variable u3
variable L
% dual variables lam1 lam2

%minimize((norm(.25 - [u1,u2,u3]*[.5;.5;0]) + norm([u1,u2,u3]) + norm(L)))

% invariance conditions
h2'*(A*v1 + B*u1 +a) <= 0
h3'*(A*v1 + B*u1 +a) <= 0
h3'*(A*v2 + B*u2 +a) <= 0
 
% Slightly complex invariance conditions
qi4'*[L; u3] + ri4 <= 0
qf'*[L; u3] + rf >= 0
z'*(A*v2 + B*u2 +a) >= 0


u1 <= 1;
u2 <= 1;
u3 <= 1;
u1 >= -1;
u2 >= -1;
u3 >= -1;
L >= 0;
L <= 1;

cvx_end

u1 
u2
u3
L
