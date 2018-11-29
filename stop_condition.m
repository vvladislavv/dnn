%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% stop_condition.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function retval= stop_condition(err_hist,min_err,err_win_len)
   err_min_diff=1e-6; % window error deviation threshold

   if isnan(err_hist(end))
	  fprintf('\n= Error is NaN =\n');
	  retval=1;
      return;
   end

   if err_hist(end)<min_err
	  fprintf('\n= Minimum error is reached =\n');
	  retval=1;
	  return;
   end
   
   if length(err_hist) > err_win_len
        err_win = err_hist(end-err_win_len:end);
        if issorted(err_win)
            fprintf('\n= Error increases monotonically = \n') ;
            retval=1;
            return;
        end
  
        md=max(abs(mean(err_win)-err_win));
        if md < err_min_diff
            fprintf('\n= Minimum error window deviation is reached =\n');
            retval=1;
            return;
        end
   end
retval=0;
end
