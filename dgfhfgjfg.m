     if opts.dist
        ndata = sort(data+0.05*bsxfun(@times,std(data')',randn(size(data))),1);
        sample = sort(bsxfun(@times,std(data')',randn(size(data))),1);
        rotidx = (randn(1,opts.batchsize)>0);
        ndata(:,rotidx==1) = -ndata(end:-1:1,rotidx==1);
        ndata = (ndata./std(ndata))./4;   
     else
         ndata = data;
     end