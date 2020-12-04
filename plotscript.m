% plot script - need one main script
% generate MAP

h = figure(2);
hold on
grid on
axis equal
axis([-1 3 -.5 5])
title('Phase plot','Interpreter','latex','FontSize',18);
xlabel('$x_1$','Interpreter','latex','FontSize',18)
ylabel('$x_2$','Interpreter','latex','FontSize',18)
box on

patch(xg,yg,'g',"FaceColor",[0.4660 0.6740 0.1880],"FaceAlpha",.5,'LineStyle','none')
% trajectory
plot(x1,y1,'o',trajx,trajy,':.');

for k = 2:length(S)+1
        %mapshow(trajx_inp,trajy_inp,'DisplayType','line','Marker','.')
        %mapshow(Finp(1,:),Finp(2,:),'DisplayType','line','Marker','.')
        mapshow([S(k-1).v(1,:), S(k-1).v(1,1)],[S(k-1).v(2,:), S(k-1).v(2,1)],'DisplayType','line','Marker','.')
end
mapshow(Finp_0(1,:),Finp_0(2,:),'Color','g','LineWidth',1,"MarkerSize",8)