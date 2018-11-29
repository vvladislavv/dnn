function [out] = kol(insize)


struct = {insize insize/2 (insize/2)/2 ((insize/2)/2)/2 (insize/2)/2 insize/2 insize}; 

out = 0

for i = 1:length(struct)-1
    out = out+struct{i}*struct{i+1};
end
end

