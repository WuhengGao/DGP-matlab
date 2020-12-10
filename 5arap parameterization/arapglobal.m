function b = arapglobal(t,x,t2x,t2y,Rarray,cottheta)
nf=size(t, 1);
nv = size(x, 1);
b=zeros(nv,2);
for i=1:nf
    R=reshape(Rarray(i,:),2,2);
    dx=[t2x(i,:)-t2x(i,[2,3,1]);t2y(i,:)-t2y(i,[2,3,1])];
    dx2=[t2x(i,:)-t2x(i,[3,1,2]);t2y(i,:)-t2y(i,[3,1,2])];
    b(t(i,:),:)=b(t(i,:),:)+(repmat(cottheta(i,[3,1,2]),2,1).*(R*dx))';
    b(t(i,:),:)=b(t(i,:),:)+(repmat(cottheta(i,[2,3,1]),2,1).*(R*dx2))';
end
end

