%%load mesh
%[x,t] = readObj('D:\mesh\Balls.obj');
[x,t] = readObj('D:\mesh\cathead.obj');

nf = size(t, 1);
nv = size(x, 1);
%initial
uv=tutte(x,t);

%%3D triangles->2D triangles
%caculate the three angles of triangles
costheta=cos(meshAngles(x, t));
cottheta=costheta./sqrt(1-costheta.^2);
%xi,xj,xk->(0,0),(|xi-xj|,0),(|xi-xk|cosi,|xi-xk|sini)
t2x=zeros(nf,3);
t2y=zeros(nf,3);
t2x(:,2)=sqrt(sum((x(t(:,1),:)-x(t(:,2),:)).^2,2));
t2x(:,3)=sqrt(sum((x(t(:,1),:)-x(t(:,3),:)).^2,2)).*costheta(:,1);
t2y(:,3)=sqrt(sum((x(t(:,1),:)-x(t(:,3),:)).^2,2)).*sqrt(1-costheta(:,1).^2);

%%local-global iteration
%anchor point:1
A=laplacian(x,t);
A(:,1)=0;
A(1,1)=1;

for k=1:100
    %local update
    Rarray=araplocal(t,t2x,t2y,uv,cottheta);
    %global update
    b=arapglobal(t,x,t2x,t2y,Rarray,cottheta);
    b(1,:)=[0,0];
    
    uv=A'\b;
end

drawparameter(x,t,uv);


