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
xo = [-1 0 0 3 3 -1 -1]; 
yo = [-3 -3 0 0 1 1 -3];
O = [xo;yo];

% Bounds 1
xb1 = [-4 -4 -.5];
yb1 = [1 -5 -5];
L1 = [xb1;yb1];

% Bounds 2
xb2 = [0 5 5];
yb2 = [5 5 0];
L2 = [xb2 ; xb2];

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

% deltat = ;

% initial vertex 
v1 = [0;-3];
v2 = [3;0];

% initial facet
Finp = [v1 v2];

% Simplex Entry Point
[trajx_inp,trajy_inp] = polyxpoly(trajx,trajy,Finp(1,:),Finp(2,:));
inp = [trajx_inp;trajy_inp];
if size(inp,2)>0
    %Error
end

if MAP == 1
    mapshow(trajx_inp,trajy_inp,'DisplayType','point','Marker','o')
end

ds = 0.5;

dist =  sum((repmat([trajx_inp;trajy_inp],1,length(traj))-traj).^2).^(.5);
[c ,index] = min(dist);
s0 = tq(index);
sf = s0+ds;
indexf = find(tq==sf);

traj_f = traj(:,indexf); 

zeta = traj_f - inp;
% v31  = v1 + 2*zeta;
% v32  = v2 + 2*zeta;
% v3 = [v31 v32]


for i = 1:1
    vi = Finp(:,i);
    v3i = vi + 2*zeta;
    li = [vi v3i];
    
    [U1intx,U1inty] = polyxpoly(li(1,:),li(2,:),xU1,yU1);
    U1int = [U1intx,U1inty]';
    [U2intx,U2inty] = polyxpoly(li(1,:),li(2,:),xU2,yU2);
    U2int = [U2intx,U2inty]';
    [Ointx,Ointy]   = polyxpoly(li(1,:),li(2,:),xo,yo);
    Oint = [Ointx,Ointy]';
    [L1intx,L1inty] = polyxpoly(li(1,:),li(2,:),xb1,yb1);
    L1int = [L1intx,L1inty]';
    [L2intx,L2inty] = polyxpoly(li(1,:),li(2,:),xb2,yb2);
    L2int = [L2intx,L2inty]';
    
    v3i_new = [U1int,U2int,Oint,L1int,L2int]
    
    mapshow(v3i(1),v3i(2),'DisplayType','point','Marker','o')
%     if ~isempty(v3i_new)
%         mapshow(tempv3x(1),tempv3y(1),'DisplayType','point','Marker','+')
%     end
end




% s0+deltas