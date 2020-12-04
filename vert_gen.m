function splx = vert_gen(v1, v2, v3,z, uR, bt)
%system
A = [-0.1, 0.2;
    -1, 0.4];
B = [1,0;
    0,1];
a = [-0.2; 
    -0.1];
u_max = 6/sqrt(2);
del_L = 1;    % weight for L to keep it important
del_d = 3;
del_u = 1/u_max;

N = [0 1; -1 0];

N1 = N;
h1 = N1*(v2-v3);
h1 = h1/norm(h1);
if (h1'*(v2-v1)) <= 0
    h1 = -h1;
    N1 = -N1;
end

N2 = N;
h2 = N2*(v3-v1);
h2 = h2/norm(h2);
if (h2'*(v3-v2)) <= 0
    h2 = -h2;
    N2 = -N2;
end

N3 = N;
h3 = N3*(v1-v2);
h3 = h3/norm(h3);
if (h3'*(v1-v3)) <= 0
    h3 = -h3;
    N3 = -N3;
end

z = z/norm(z);

qi = [h2' * A *(v1-v3);
      (h2' * B)'];
ri = h2'* (A * v3 + a);

qf = [z'* A*(v1-v3);
      (z'*B)'];
rf = z'*(A*v3 + a);

cvx_begin sdp quiet
variable u1(2,1)
variable u2(2,1)
variable u3(2,1)
variable L(1,1)
minimize( del_d*norm(uR - (bt'*[u1';u2';u3'])')+ del_u*(norm(u1)+norm(u2)+norm(u3)) + del_L*norm(L) )
% invariance conditions
h2'*(A*v1 + B*u1 +a) <= 0
h3'*(A*v1 + B*u1 +a) <= 0
h3'*(A*v2 + B*u2 +a) <= 0
qi'*[L; u3] + ri <= 0
% flow conditions
z'*(A*v2 + B*u2 +a) >= 0
qf'*[L; u3] + rf >= 0
%limits
kron([1; -1], L) <= [0.8;-0.1];
kron([1; -1], eye(2))*u1 <= u_max*ones(4,1);
kron([1; -1], eye(2))*u2 <= u_max*ones(4,1);
kron([1; -1], eye(2))*u3 <= u_max*ones(4,1);
cvx_end

v_1 = v1;
v_2 = v2;
v_3 = L*v1 + (1-L)*v3;
u_1 = u1;
u_2 = u2;
u_3 = u3;

splx.v = [v_1, v_2, v_3];
splx.u = [u_1, u_2, u_3];
end
