%clear all; clc;
load("S.mat")
load("trej.mat")

global j;
j = 1;

tf = 400;
n = 10*tf;
t = linspace(0, tf, n);
xx0 = 0:.2:2;
filename = 'testAnimated_traj2.gif';

for i = 1:length(xx0)
    x0 = [xx0(i) 0];
    odefun = @(t, x) f(t, x, S);
    [ts, ys] = ode45(odefun, t, x0);
    figure(2)
    plot(ys(:, 1), ys(:, 2),'LineWidth',.8)
    % Capture the plot as an image 
      frame = getframe(h); 
      im = frame2im(frame); 
      [imind,cm] = rgb2ind(im,256); 
      % Write to the GIF File 
      if i == 1 
          imwrite(imind,cm,filename,'gif', 'Loopcount',inf); 
      else 
          imwrite(imind,cm,filename,'gif','WriteMode','append'); 
      end 
end
