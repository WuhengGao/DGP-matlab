function [B1,B2,B3] = localbasis(x,t)
B1=x(t(:,2),:)-x(t(:,1),:);
B3=cross( B1, x(t(:,3), :) - x(t(:,1), :), 2 );
B2=cross( B3, B1, 2 );
B1=B1./repmat(sqrt(sum(B1.^2,2)),1,3);
B2=B2./repmat(sqrt(sum(B2.^2,2)),1,3);
B3=B3./repmat(sqrt(sum(B3.^2,2)),1,3);
end

