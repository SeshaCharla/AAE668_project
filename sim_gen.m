function S = sim_gen(v1, v2, v31, v32, z, uR, bt)
if v1 ~= v31
    S1 = vert_gen(v1, v2, v31, z, uR, bt);
    ar1 = tri_ar(S1.v(:,1), S1.v(:,2), S1.v(:,3));
else 
    ar1 = 0;
end
if v2 ~= v32
    S2 = vert_gen(v2, v1, v32, z, uR, bt);
    ar2 = tri_ar(S2.v(:,1), S2.v(:,2), S2.v(:,3));
else
    ar2 = 0;
end

if ar1 > ar2
    S = S1;
else
    S = S2;
end
end
