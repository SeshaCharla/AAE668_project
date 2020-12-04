%clear all; clc;
load("S.mat")
load("trej.mat")

global j;
j = 1;

tf = 400;
n = 10*tf;
t = linspace(0, tf, n);
x0 = [1.8,0];

odefun = @(t, x) f(t, x, S);
[ts, ys] = ode45(odefun, t, x0);
plot(ys(:, 1), ys(:, 2))

