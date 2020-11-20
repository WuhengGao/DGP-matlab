%%load mesh
%[x,t] = objread('Balls.obj');
[x,t] = objread('cathead.obj');
x=x';t=t';
nf = size(t, 1);
nv = size(x, 1);
[B,~]=findBoundary(x,t);
B=B';
nb=size(B, 1);

%%caculate the three angles and edges of triangles
costheta=zeros(nf,3);
detx=zeros(nf,3);
for i=1:3
    %xi,xj,xk:three vertices of triangle
    xi=x(t(:,i),:);
    xj=x(t(:,mod(i,3)+1),:);
    xk=x(t(:,mod(i+1,3)+1),:);
    costheta(:,i)=dot(xi-xj,xi-xk,2)./sqrt(sum((xi-xj).^2,2))./sqrt(sum((xi-xk).^2,2));
    detx(:,i)=sqrt(sum((xi-xj).^2,2));
end
%tan(theta/2)=(1-cos)/sin
tantheta2=(1-costheta)./sqrt(1-costheta.^2);


%%construct sparse linear equations
%boundary to circle
b=zeros(nv,2);
r=1:nb;
r=2*pi*r/nb;
b(B,1)=sin(r);
b(B,2)=cos(r);

%in boundary:Aii=1,Aij=0;
%not in boundary:Aij=-(tan(theta/2)+tan(theta'/2))/||vj-vi||((i,j in a triangle),Aii=-sum(Aij)
A=sparse([t;t], [t(:, [2,3,1]);t(:,[3,1,2])], [tantheta2./detx;tantheta2./detx(:,[3,1,2])], nv, nv);
A(B,:)=0;
sumw=sum(A,2);
sumw(B)=1;
A=-A+diag(sumw);

uv=A\b;

%%draw mesh and parameter coordinates
subplot(1,2,1)
patch('Faces',t,'Vertices',x,'FaceColor','green');
title('Real mesh');
subplot(1,2,2)
patch('Faces',t,'Vertices',uv,'FaceColor','green');
title('Parameter coordinates');

