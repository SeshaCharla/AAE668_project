close 
clc 
clear
wpts = [1,-1;3,-1;4,1;4,4];
%wpts = [1,-1;1,-3;-1,-4;-3,-3;-3,-1;-2.5,1.8;-.5,3;1.5,4;4,4];
t = 0: (length(wpts)-1);
points = wpts;
x1 = points(:,1);
y1 = points(:,2);

% figure;
% plot(t,x,t,x,'o');
% title('x vs. t');
% 
% figure;
% plot(t,y,t,y,'o');
% title('y vs. t');
% 
% figure;
% plot(x,y,x,y,'o');
% title('y vs. x');

tq = 0:0.01:(length(wpts)-1);
slope0 = 0;
slopeF = 0;
xq = spline(t,[slope0; x1; slopeF],tq);
yq = spline(t,[slope0; y1; slopeF],tq);

% plot spline in t-x, t-y and x-y space
% figure;
% plot(t,x,'o',tq,xq,':.');
% 
% title('x vs. t');
% 
% figure;
% plot(t,y,'o',tq,yq,':.');
% title('y vs. t');

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
plot(x1,y1,'o',xq,yq,':.');

% obstacle
xo = [-1 0 0 3 3 -1]; 
yo = [-3 -3 0 0 1 1];
patch(xo,yo,'r','FaceColor',[0.4940 0.1840 0.5560],'LineStyle','none')
% rectangle('Position',[-1, -3, 1, 4],"FaceColor",'#A2142F','LineStyle','none')
% rectangle('Position',[0,0, 3,1 ],"FaceColor",'#A2142F','LineStyle','none')

% Unsafe Region
xp1 = [-4 -2.5 0 -4];
yp1 = [1 3 5 5];
% patch(xp1,yp1,'r','FaceColor',[0.6350 0.0780 0.1840],'LineStyle','none')

xp2 = [-.5 2.5 5 5;xp1]';
yp2 = [-5 -3 0 -5;yp1]';
patch(xp2,yp2,'r','FaceColor',[0.6350 0.0780 0.1840],'LineStyle','none')

