function b = updateb(Rarray,Sarray,H1array,H2array,x,t,dt)
nf = size(t, 1);
nv = size(x, 1);
b=zeros(nv,2);
for i=1:nf
    R=[cos(Rarray(i)*dt),-sin(Rarray(i)*dt);sin(Rarray(i)*dt),cos(Rarray(i)*dt)];
    S=(1-dt)*eye(2)+dt*reshape(Sarray(i,:),2,2);
    At=R*S;
    %x:At(1,1)*(H11v1+H12v2+H13v3)+At(1,2)*(H21v1+H22v2+H23v3)
    b(t(i,:),:)=b(t(i,:),:)+(At(:,1)*H1array(i,:))'+(At(:,2)*H2array(i,:))';
end

end

