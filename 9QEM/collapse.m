function [mesh,garbaget] = collapse(t,k1,k2,mesh)
%collapse edge(k1,k2),new vertex:aim
t1=mesh(k1,k2);
t2=mesh(k2,k1);
% for j=1:3
%     mesh(t(t1,j),t(t1,mod(j,3)+1))=0;
%     mesh(t(t2,j),t(t2,mod(j,3)+1))=0;
% end
mesh(sub2ind(size(mesh),t([t1,t2],:),t([t1,t2],[2,3,1])))=0;
garbaget=[t1,t2];

[near,~]=find(mesh(:,k1)|mesh(:,k2));
mesh(near,k2)=mesh(near,k1)+mesh(near,k2);
mesh(k2,near)=mesh(k1,near)+mesh(k2,near);
mesh(near,k1)=0;
mesh(k1,near)=0;

% mesh(:,k2)=mesh(:,k2)+mesh(:,k1);
% mesh(k2,:)=mesh(k2,:)+mesh(k1,:);
% mesh(:,k1)=0;
% mesh(k1,:)=0;


end

