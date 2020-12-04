function area = tri_ar(v1, v2, v3)
a = norm(v1-v2);
b = norm(v2-v3);
c = norm(v3-v1);
s = (a+b+c)/2;
area = sqrt(s*(s-a)*(s-b)*(s-c));
end