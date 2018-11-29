%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ffprop.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [activations, preactivations, drop, qnt] = ffprop(FF, data, ...
                                                          quantize,dropout)   
a{1} = data;
act = data;
m =size(data,2);
len = length(FF.W)+1;
qnt = [];
    for d = 1:len-1
        z{d+1} = FF.W{d}*act + repmat(FF.B{d}, 1, m);
        a{d+1} = afunc(z{d+1},FF.afun{d+1});
        
        if dropout >0 && d<len-1
        drop{d+1} = binornd(1,1-dropout,size(a{d+1}));
        else
        drop{d+1} = ones(size(a{d+1}));    
        end
        a{d+1} = a{d+1}.* drop{d+1};
        
        if d == (len-1)/2 && quantize
              act = ((round(((4*a{d+1}/2)+1/2)*15)/15)-1/2)*2/4;
              qnt = act;
        else
            act = a{d+1};
        end
        
%         if d == (len-1)/2 && dropout < 0
%               qntdrop = binornd(1,0.8,size(a{d+1}));        
%               act = ((round(((4*a{d+1}/2)+1/2)*15)/15)-1/2)*2/4;
%               act(qntdrop>0) = a{d+1}(qntdrop>0);
%               qnt = act;
%               a{d+1} = act;
%         else
%             act = a{d+1};
%         end

    end
activations = a;
preactivations = z;
end
