function [ data ] = cropmas( tmp )


idx1 = 0; 
for i = 1:size(tmp,2)
    if std(tmp(:,i)) > 0.001  
    idx1 = idx1+1;
    data(:,idx1) = tmp(:,i);
    end
end


end
