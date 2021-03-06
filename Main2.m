%% Main 2 - with new trajectory
clc 
clear
close all
% Arbitrary 
MAP = 1;

%% Trajectory

% wpts = [1,0;0.5,1;1,2;1.5,3;0.5,5];
wpts = [1,0 ; 2,1; 2,2; 3,3; 1,4; 2.5,5];
t = 0: (length(wpts)-1);

points = wpts;
x1 = points(:,1);
y1 = points(:,2);

tq = 0:0.01:(length(wpts)-1);
slope0 = 0;
slopeF = 0;

trajx = spline(t,[slope0; x1; slopeF],tq); % Row matrix 
trajy = spline(t,[slope0; y1; slopeF],tq); % Row matrix 
% trajectory = Column Matrix of coordinates
traj = [trajx;trajy];

% Trajectory as function
traj_par = spline(t , [[slope0;slope0] points' [slopeF;slopeF]]);

% example intersection with arbit line segment
% ex = [-4 5;-5 5]; % [ 0,3 ; 0,3] 
% P = InterX(traj,ex);
% plot(xq,yq,ex(1,:),ex(2,:),P(1,:),P(2,:),'ro')
 

%% Map - No bounds

% Goal 
xg = [-10 10  10 -10];
yg = [3.5 3.5 6 6];
G = [xg;yg];


% Test intersection on random lines
% mapshow(xo,yo,'DisplayType','polygon','LineStyle','none')
% mapshow(xU1,yU1,'DisplayType','polygon','LineStyle','none')
% mapshow(xU2,yU2,'DisplayType','polygon','LineStyle','none')
% x = [-4 5 NaN -4 5]; 
% y = [-5 5 NaN 5 -5];
% mapshow(x,y,'Marker','+')
% [xi_o,yi_o] = polyxpoly(x,y,xo,yo);
% mapshow(xi_o,yi_o,'DisplayType','point','Marker','o')
% 
% [xi_u1,yi_u1] = polyxpoly(x,y,xU1,yU1);
% mapshow(xi_u1,yi_u1,'DisplayType','point','Marker','o')
% 
% [xi_u2,yi_u2] = polyxpoly(x,y,xU2,yU2);
% mapshow(xi_u2,yi_u2,'DisplayType','point','Marker','o')

%% Initialization

% initial vertex 
v1_0 = [0;0];
v2_0 = [2;0];

% initial facet
Finp_0 = [v1_0 v2_0];

%% Chain generation loop

% initial vertex 
v1 = v1_0;
v2 = v2_0;

% initial facet
Finp = [v1 v2];

% trajectory gen parameter
ds = 0.25; % in secs

Reachflag = false;
k = 1;
i = 1; %simplex chanin index

%-----------------------------
% Solve RCP for the first simplex whose exit facet becomes the starting
% point of the algorithm

%------------------------------
i = 1;

while(~Reachflag)
    % Simplex Entry Point
%     Finp;
    [trajx_inp,trajy_inp] = polyxpoly(trajx,trajy,Finp(1,:),Finp(2,:));
    inp = [trajx_inp;trajy_inp];
    if size(inp,2)>0
        %Error
    end
    
    % Flow avg Tangent generation = zeta
    [~ ,index_inp] = min(sum((repmat([trajx_inp;trajy_inp],1,length(traj))-traj).^2).^(.5));
    s0 = tq(index_inp);
    sf = s0 + ds;
    [~ ,index_out] = min(abs(repmat(sf,1,length(tq))-tq));
%     index_out = find(tq == sf);
    traj_f = traj(:,index_out); 
    zeta = traj_f - inp;
    
    
    % inital guesses for v3
    v3_new = [];
    for i = 1:2

        vi = Finp(:,i);
        v3i = vi + 2*zeta;
        li = [vi v3i];
        v3i_new = v3i;
        v3_new = [v3_new v3i_new];
        
    end


    
    
    % comes from vertex gen
%     % Defining necessary stuff for simgen
    bt = [0.5;0.5;0]; %barrycentric coordinates of a reference point
    d = [-0.2; 1];
    uR = 6/sqrt(2)*(d/norm(d)); % initial guess will be updated after every simplex.
    z = zeta; % the reference direction (updated by bigger code)
    v1 = Finp(:, 1);
    v2 = Finp(:, 2);
    v31 = v3_new(:, 1);
    v32 = v3_new(:, 2);
    
    if mod(k,2)==0
        S(k) = vert_gen(v1, v2, v31, z, uR, bt);
    else
        S(k) = vert_gen(v2, v1, v32, z, uR, bt);
    end
    
    [K, g] = ctrl_in(S(k));
    uR = K*(S(k).v*bt) + g;
    % exit facet always v2 v3
    Finp = [S(k).v(:, 2), S(k).v(:, 3)];
    i = i + 1;
    k = k + 1;
   % v3_new = [v31  v32]
   % Finp = [v1, v3_new(:, 2)];
    if MAP == 1
        mapshow([S(k-1).v(1,:), S(k-1).v(1,1)],[S(k-1).v(2,:), S(k-1).v(2,1)],'DisplayType','line','Marker','.')
    end

    % termination flag
    if (inpolygon(v1(1),v1(2),xg,yg)) && (inpolygon(v2(1),v2(2),xg,yg))
        Reachflag = 1;
    end
     if k >= 40 
        Reachflag = 1;
    end

end

    if MAP == 1
       
    end


% s0+deltas
%generate MAP
if MAP == 1
    figure;
    hold on
    grid on
    axis equal
    axis([-1 3 -.5 5])
    title('Phase plot','Interpreter','latex');
    xlabel('$x_1$','Interpreter','latex')
    ylabel('$x_2$','Interpreter','latex')
    box on
    
    patch(xg,yg,'g',"FaceColor",[0.4660 0.6740 0.1880],"FaceAlpha",.5,'LineStyle','none')
    % trajectory
    plot(x1,y1,'o',trajx,trajy,':.');
end
save("S.mat", "S");
x = trajx;
y = trajy;
save("trej.mat", "x", "y");