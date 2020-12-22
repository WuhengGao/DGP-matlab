function Rarray = araplocal(t,t2x,t2y,uv,cottheta)
nf=size(t, 1);
Sarray=zeros(2,2*nf);
for i=1:nf
    dx=[t2x(i,:)-t2x(i,[2,3,1]);t2y(i,:)-t2y(i,[2,3,1])];
    du=(uv(t(i,:),:)-uv(t(i,[2,3,1]),:))';
    St=zeros(2,2);
    for j=1:3
         St=St+cottheta(i,mod(j+1,3)+1)*du(:,j)*dx(:,j)';
    end
    Sarray(:,2*i-1:2*i)=St;
end
Rarray=projectBlockRotation(Sarray);
end

