function [x] = updatevertex(x,t,B)
nf = size(t, 1);
nv = size(x, 1);
mesh=sparse(t, t(:, [2:end 1]), repmat(1:nf, 1, 3), nv, nv);
area=TriArea(x,t);
center=excentre(x,t);
C=1:nv;
C(B)=[];
for i= C 
    near=nonzeros(mesh(:,i));  
    x(i,:)=[sum(center(near,:).*repmat(area(near),1,2),1)/sum(area(near),1),0]; 
    %area(near)=TriArea(x,t(near,:));
    %center(near,:)=excentre(x,t(near,:));
end

end

