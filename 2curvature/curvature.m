%%load mesh
[x,t] = readObj('D:\mesh\ball.obj');

nf = size(t, 1);
nv = size(x, 1);

%%caculate the three angles of triangles
costheta=zeros(nf,3);
for i=1:3
    %xi,xj,xk:three vertices of triangle
    xi=x(t(:,i),:);
    xj=x(t(:,mod(i,3)+1),:);
    xk=x(t(:,mod(i+1,3)+1),:);
    costheta(:,i)=dot(xi-xj,xi-xk,2)./sqrt(sum((xi-xj).^2,2))./sqrt(sum((xi-xk).^2,2));
end
cottheta=costheta./sqrt(1-costheta.^2);
theata=acos(costheta);
%flag:obtuse triangle
flag=logical(sum((costheta<0),2));

%%caculate curvature
%Area:Local Averaging Region
Area=zeros(nv,1);
%K:Gaussian curvature
K=2*pi*ones(nv,1);
%Laplace:cotangent Laplace
Laplace=zeros(nv,3);
for i=1:3
    j=mod(i,3)+1;
    k=mod(i+1,3)+1;
    xi=x(t(:,i),:);
    xj=x(t(:,j),:);
    xk=x(t(:,k),:);
    area=zeros(nf,1);
    %area=T/2,obtuse triangle
    %area=(|xi-xj|^2*cotk+|xi-xk|^2*cotj)/8,others
    area(~flag)=(sum((xi(~flag,:)-xj(~flag,:)).^2,2).*cottheta(~flag,k)+sum((xi(~flag,:)-xk(~flag,:)).^2,2).*cottheta(~flag,j))./8;
    area(flag)=sqrt(sum(cross(xi(flag,:)-xj(flag,:),xi(flag,:)-xk(flag,:),2).^2,2))./4;
    Area=Area+accumarray(t(:,i),area,[nv,1]);
    %Ki=(2pi-sum(thetaj))/Areai
    K=K-accumarray(t(:,i),theata(:,i),[nv,1]);
    %Laplace=sum(cotk*(xj-xi)+cotj*(xk-xi))/2Areai
    laplace=(xj-xi).*repmat(cottheta(:,k),1,3)+(xk-xi).*repmat(cottheta(:,j),1,3);
    for d=1:3
    Laplace(:,d)=Laplace(:,d)+accumarray(t(:,i),laplace(:,d),[nv,1]);
    end   
end
K=K./Area;
Laplace=Laplace./repmat(2.*Area,1,3);
%H=||Laplace||/2,absolute mean curvature
H=sqrt(sum(Laplace.^2,2))./2;

%%draw mesh
figure(1)
patch('Faces',t,'Vertices',x,'FaceVertexCData',K,'FaceColor','interp');
title('Gaussian curvature');
grid on; 
colorbar;
figure(2)
patch('Faces',t,'Vertices',x,'FaceVertexCData',H,'FaceColor','interp');
title('absolute mean curvature');
grid on;
colorbar;

