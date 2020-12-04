function Si = which_splx(x, S)
global j;
[~, n] = size(S);
for i= 1:n
    if inpolygon(x(1,1), x(2,1), S(i).v(1,:), S(i).v(2,:))
        j = i
    end
end
Si = S(j);
end

