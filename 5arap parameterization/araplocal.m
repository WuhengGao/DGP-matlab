function Rarray = araplocal(t,t2x,t2y,uv,cottheta)
nf=size(t, 1);
Rarray=zeros(nf,4);
for i=1:nf
    dx=[t2x(i,:)-t2x(i,[2,3,1]);t2y(i,:)-t2y(i,[2,3,1])];
    du=(uv(t(i,:),:)-uv(t(i,[2,3,1]),:))';
    St=zeros(2,2);
    for j=1:3
         St=St+cottheta(i,mod(j+1,3)+1)*du(:,j)*dx(:,j)';
    end
    [U,~,V]=svd(St);
    R=U*V';
    Rarray(i,:)=reshape(R,1,4);
end
end

