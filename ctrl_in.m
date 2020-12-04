function [K, g] = ctrl_in(splx)
V = [splx.v', ones(3,1)];
U = splx.u';
Kg = V\U;
KgT = Kg';
K = KgT(:, 1:2);
g = KgT(:, 3);
end
