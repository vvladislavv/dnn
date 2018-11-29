function [FF,dW,dB,hdW,hdB,delta] = bp_grad(FF,a,z,drop, qnt,m,epoch,opts,target,dW, dB,hdW,hdB,delta, update)
len = length(FF.W)+1;
   
    for d = len-1:-1:2 
        delta{d} = FF.W{d}' * delta{d+1} .* ...
            dafunc(z{d}, a{d}, FF.afun{d}).*drop{d}; 
%         if opts.decorr>0 && d == (len+1)/2
%             tmp = a{d}*a{d}';
%                     delta{d} = (FF.W{d}' * delta{d+1} + (opts.decorr)*( (1/m)*tmp - eye(size(tmp,1)) ) * a{d}) .* ...
%             dafunc(z{d}, a{d}, FF.afun{d}).*drop{d}; 
%         end
    end
    
    for d = 1:len-1
        gradB{d} = sum(delta{d+1},2)/m;
        gradW{d} = (delta{d+1}*a{d}')/m + opts.lambda*FF.W{d};
        if FF.scale > 1
            gradW{d} = gradW{d}.*FF.mask{d};%./FF.scale;
        end
        if opts.quantize && d == (len+1)/2
            gradW{d} = (delta{d+1}*qnt')/m + opts.lambda*FF.W{d};
        end  
    end
if update
    for d = 1:len-1
        switch opts.method
        case 'RMSprop'
        % Weight update
        dW{d} = (1-opts.momentum).*gradW{d}.^2 + opts.momentum.*dW{d};
        FF.W{d} = FF.W{d} - (opts.step./sqrt(dW{d}+eps)).*gradW{d};
        % Bias unit update
        dB{d} = (1-opts.momentum).*gradB{d}.^2 + opts.momentum.*dB{d};
        FF.B{d} = FF.B{d} - (opts.step./sqrt(dB{d}+eps)).*gradB{d};
        case 'adam'
        b1 = 0.9;
        b2 = 0.9;
        hdW{d} = (1-b1).*gradW{d} + b1*hdW{d};
        dW{d} = (1-b2).*gradW{d}.^2 + b2*dW{d};
        FF.W{d} = FF.W{d} - (opts.step.*(hdW{d}/(1-b1^epoch))./...
            sqrt(dW{d}./(1-b2^epoch)+1e-8));
        % Bias unit update
        hdB{d} = (1-b1).*gradB{d} + b1*hdB{d};
        dB{d} = (1-b2).*gradB{d}.^2 + b2.*dB{d};
        FF.B{d} = FF.B{d} - (opts.step.*(hdB{d}/(1-b1^epoch))./...
            sqrt(dB{d}./(1-b2^epoch)+1e-8));
        case 'momentum'
        dW{d} = opts.step*gradW{d} + opts.momentum*dW{d};
        FF.W{d} = FF.W{d} - dW{d};
        % Bias unit update
        dB{d} = opts.step*gradB{d} + opts.momentum*dB{d};
        FF.B{d} = FF.B{d} - dB{d};
        end
    end
end


end

