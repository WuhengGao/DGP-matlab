function [l] = AverageEdgeLen(x,t)
l=x(t(:, [2 3 1]), :) - x(t(:, [3 1 2]), :) ;
l=sqrt(sum(l.^2,2));
l=sum(l,1)/(3*size(t,1));
end

