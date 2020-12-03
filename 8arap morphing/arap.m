%%load mesh
[x,t] = objread('horse_source.obj');
[x2,t2] = objread('horse_target.obj');
x=x';t=t';
x2=x2';t2=t2';
nf = size(t, 1);
nv = size(x, 1);
if ~isequal(t,t2)
    warning('not corresponding meshs!');
end

Rarray=zeros(nf,1);
Sarray=zeros(nf,4);
H1array=zeros(nf,3);
H2array=zeros(nf,3);
for i=1:nf
    %Ap+l=q
    xy=x(t(i,[2,3]),[1,2])-repmat(x(t(i,1),[1,2]),2,1);
    xy2=x2(t(i,[2,3]),[1,2])-repmat(x2(t(i,1),[1,2]),2,1);
    A=(xy2')/(xy');
    %A=RS,R:rotation
    [U,~,V]=svd(A);
    R=U*V';
    if det(R)<0
       U(:,end)=-U(:,end);
       R=U*V';
    end
    S=R\A;
    if R(2,1)>0
        Rarray(i)=acos(R(1,1));
    else
        Rarray(i)=-acos(R(1,1));
    end
    Sarray(i,:)=reshape(S,1,4);
    H=inv([x(t(i,:),[1,2]),ones(3,1)]);
    H1array(i,:)=H(1,:);
    H2array(i,:)=H(2,:);
end

%sum(bi^2)=(H11v1+H12v2+H13v3)^2+(H21v1+H22v2+H23v3)^2
SH=sparse([t;t;t],[t;t(:,[2,3,1]);t(:,[3,1,2])],[H1array.^2+H2array.^2;H1array.*H1array(:,[2,3,1])+H2array.*H2array(:,[2,3,1]);H1array.*H1array(:,[3,1,2])+H2array.*H2array(:,[3,1,2])]);
%anchor point
SH(1,:)=0;
SH(1,1)=1;
dSH=decomposition(SH,'lu');

N=20;
tx=zeros(nv,N);
ty=zeros(nv,N);
for k=1:N
    dt=k/N;
    b=zeros(nv,2);
    for i=1:nf
        R=[cos(Rarray(i)*dt),-sin(Rarray(i)*dt);sin(Rarray(i)*dt),cos(Rarray(i)*dt)];
        S=(1-dt)*eye(2)+dt*reshape(Sarray(i,:),2,2);
        At=R*S;
        %x:At(1,1)*(H11v1+H12v2+H13v3)+At(1,2)*(H21v1+H22v2+H23v3)
        b(t(i,:),:)=b(t(i,:),:)+(At(:,1)*H1array(i,:))'+(At(:,2)*H2array(i,:))';
    end
    %anchor point
    b(1,:)=(1-dt)*x(1,[1,2])+dt*x2(1,[1,2]);
    
    uv=dSH\b;
    tx(:,k)=uv(:,1);
    ty(:,k)=uv(:,2);
end

%%draw mesh 
for k=1:N
    figure(k);
    patch('Faces',t,'Vertices',[tx(:,k),ty(:,k)],'FaceColor','green');
    saveas(gcf, num2str(k), 'jpg');
end


