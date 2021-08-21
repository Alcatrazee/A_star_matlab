function exist = exist_in_close(CLOSE,xval,yval)
    %This function returns the index of the location of a node in the list
    %OPEN
    %
    
    for i = 1:size(CLOSE,1)
       if CLOSE(i,1) == xval && CLOSE(i,2) == yval
          exist = 1;
          return ;
       end
    end
    exist = 0;
end