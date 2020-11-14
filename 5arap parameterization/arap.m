%%load mesh
%[x,t] = objread('Balls.obj');
[x,t] = objread('cathead.obj');
x=x';t=t';
nf = size(t, 1);
nv = size(x, 1);
%initial
uv=tutte(x,t);

%%3D triangles->2D triangles
%caculate the three angles of triangles
costheta=zeros(nf,3);
for i=1:3
    %xi,xj,xk:three vertices of triangle
    xi=x(t(:,i),:);
    xj=x(t(:,mod(i,3)+1),:);
    xk=x(t(:,mod(i+1,3)+1),:);
    costheta(:,i)=dot(xi-xj,xi-xk,2)./sqrt(sum((xi-xj).^2,2))./sqrt(sum((xi-xk).^2,2));
end
cottheta=costheta./sqrt(1-costheta.^2);
%xi,xj,xk->(0,0),(|xi-xj|,0),(|xi-xk|cosi,|xi-xk|sini)
t2x=zeros(nf,3);
t2y=zeros(nf,3);
t2x(:,2)=sqrt(sum((x(t(:,1),:)-x(t(:,2),:)).^2,2));
t2x(:,3)=sqrt(sum((x(t(:,1),:)-x(t(:,3),:)).^2,2)).*costheta(:,1);
t2y(:,3)=sqrt(sum((x(t(:,1),:)-x(t(:,3),:)).^2,2)).*sqrt(1-costheta(:,1).^2);

%%local-global iteration
%caculate A:Aij=-(cot(thetaij)+cot(thetaji))(i,j in a triangle),Aii=-sum(Aij)
%anchor point:1
A=sparse(t, t(:, [2,3,1]), cottheta(:,[3,1,2]), nv, nv);
A=A+A';
A(1,:)=0;
sumw=sum(A,2);
sumw(1)=1;
A=-A+diag(sumw);

for k=1:10
    %local update
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
    %caculate b
    b=zeros(nv,2);
    for i=1:nf
        R=reshape(Rarray(i,:),2,2);
        dx=[t2x(i,:)-t2x(i,[2,3,1]);t2y(i,:)-t2y(i,[2,3,1])];
        dx2=[t2x(i,:)-t2x(i,[3,1,2]);t2y(i,:)-t2y(i,[3,1,2])];
        b(t(i,:),:)=b(t(i,:),:)+(repmat(cottheta(i,[3,1,2]),2,1).*(R*dx))';
        b(t(i,:),:)=b(t(i,:),:)+(repmat(cottheta(i,[2,3,1]),2,1).*(R*dx2))';
    end
    b(1,:)=[0,0];
    
    uv=A\b;
end

%%draw mesh and parameter coordinates
subplot(1,2,1)
patch('Faces',t,'Vertices',x,'FaceColor','green');
title('Real mesh');
subplot(1,2,2)
patch('Faces',t,'Vertices',uv,'FaceColor','green');
title('Parameter coordinates');


