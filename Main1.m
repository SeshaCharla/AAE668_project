%% Main 
clc 
clear
close all
% Arbitrary 
MAP = 1;

%% Trajectory
wpts = [1,-1;3,-1;4,1;4,4];
wpts = [1,-1;1,-3;-1,-4;-3,-3;-3,-1;-2.5,1.8;-.5,3;1.5,4;4,4];
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
 

%% Map

% unsafe region 1
xU1 = [-4 -2.5 0 -4 -4];
yU1 = [1 3 5 5 1];
U1 = [xU1;yU1];


% unsafe region 2
xU2 = [-.5 2.5 5 5 -.5];
yU2 = [-5 -3 0 -5 -5];
U2 = [xU2;yU2];



% unsafe region Obs
% xo = [-1 0 0 3 3 -1 -1]; 
% yo = [-3 -3 0 0 1 1 -3];
xo = [0 0 0 0 0 0 0];
yo = [0 0 0 0 0 0 0];
O = [xo;yo];


% Bounds 1
xb1 = [-4 -4 -.5];
yb1 = [1 -5 -5];
L1 = [xb1;yb1];


% Bounds 2
xb2 = [0 5 5];
yb2 = [5 5 0];
L2 = [xb2 ; xb2];

% all Unsafe regions
U = struct('x',{xU1,xU2,xo,xb1,xb2},'y',{yU1,yU2,yo,yb1,yb2});

% Goal 
xg = [3 3 5 5 3];
yg = [3 5 5 3 3];
G = [xg;yg];

%generate MAP
if MAP == 1
    figure;
    hold on
    grid on
    axis equal
    axis([-4 5 -5 5])
    title('Phase plot','Interpreter','latex');
    xlabel('$x_1$','Interpreter','latex')
    ylabel('$x_2$','Interpreter','latex')
    box on

    % final region
    xf = [3 3 5 5];
    yf = [3 5 5 3];
    patch(xf,yf,'g',"FaceColor",[0.4660 0.6740 0.1880],'LineStyle','none')


    %initial set
    xp3 = [0 3 0];
    yp3 = [0 0 -3];
    patch(xp3,yp3,'r','FaceColor', [0 0.4470 0.7410],'LineStyle','none')

    % trajectory
    plot(x1,y1,'o',trajx,trajy,':.');

    % obstacle
    xo = [-1 0 0 3 3 -1]; 
    yo = [-3 -3 0 0 1 1];
    patch(xo,yo,'r','FaceColor',[0.4940 0.1840 0.5560],'LineStyle','none')

    % Unsafe Region
    xp1 = [-4 -2.5 0 -4];
    yp1 = [1 3 5 5];
    % patch(xp1,yp1,'r','FaceColor',[0.6350 0.0780 0.1840],'LineStyle','none')

    xp2 = [-.5 2.5 5 5;xp1]';
    yp2 = [-5 -3 0 -5;yp1]';
    patch(xp2,yp2,'r','FaceColor',[0.6350 0.0780 0.1840],'LineStyle','none')
end
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
v1_0 = [0;-3];
v2_0 = [3;0];

% initial facet
Finp_0 = [v1_0 v2_0];

%% Chain generation loop

% initial vertex 
v1 = v1_0;
v2 = v2_0;

% initial facet
Finp = [v1 v2];

% trajectory gen parameter
ds = 0.5; % in secs

Reachflag = false;
k = 1;
i = 1; %simplex chanin index

%-----------------------------
% Solve RCP for the first simplex whose exit facet becomes the starting
% point of the algorithm
S(i).v = [0, 0, -3;
          0, -3, 0];
S(i).u = [0, 0, 0;
          0, 0, 0];
%------------------------------
i = i+1;

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
        minv = 100;
        for j = 1:length(U)
            [Ujx,Ujy] = polyxpoly(li(1,:),li(2,:),U(j).x,U(j).y);
            if ~isempty(Ujx)
                Uj = [Ujx(1),Ujy(1)]';
                dj = sum((Uj-vi).^2).^0.5;
                if (minv > dj) 
    %             minj = j;
                    if (k==1 && dj==0)
                        %ignore
                    else
                        minv = dj;
                        v3i_new = Uj;
                    end
                    
                end  
            end

        end
        
    %     if ~isempty(v3i_new)
    %         mapshow(tempv3x(1),tempv3y(1),'DisplayType','point','Marker','+')
    %     end
        v3_new = [v3_new v3i_new];
    end

    

    
   
    
    % comes from vertex gen
%     % Defining necessary stuff for simgen
    bt = [0.5;0.5;0]; %barrycentric coordinates of a reference point
    uR = [2; 2]; % initial guess will be updated after every simplex.
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
    Finp = [S(k).v(:, 2), S(k).v(:, 3)]

    
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

% plot script
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

% s0+deltas
save("S.mat", "S");
x = trajx;
y = trajy;
save("trej.mat", "x", "y");