%%load mesh
[x,t] = readObj('D:\mesh\horse_source.obj');
[x2,t2] = readObj('D:\mesh\horse_target.obj');

nf = size(t, 1);
nv = size(x, 1);
if ~isequal(t,t2)
    warning('not corresponding meshs!');
end

%A:t1->t2,A=RS,R:rotation
[Rarray,Sarray] = caculateRS(x,t,x2);
[H1array,H2array] = caculateH(x,t);


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
    b=updateb(Rarray,Sarray,H1array,H2array,x,t,dt);
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
    axis equal;
    saveas(gcf, num2str(k), 'jpg');
end


