%%load mesh
[x,t] = readObj('D:\mesh\fandisk.obj');
nf = size(t, 1);
nv = size(x, 1);
e=sort([t(:,[1,2]);t(:,[2,3]);t(:,[3,1])],2);
e=unique(e,'rows');
%draw Real mesh
subplot(1,3,1)
patch('Faces',t,'Vertices',x,'FaceColor','green');
title('Real mesh');

%%add noise
%average edge length
AverageLong=sum(sqrt(sum((x(e(:,1),:)-x(e(:,2),:)).^2,2)),1)/size(e,1);
range=AverageLong/5;
noisen=-range+ 2*range * rand(size(x,1),size(x,2));
x2=x+noisen;
%draw noised mesh
subplot(1,3,2)
patch('Faces',t,'Vertices',x2,'FaceColor','green');
title('Noised mesh');

%%caculate face
%face normal
edgecross=cross(x2(t(:,1),:)-x2(t(:,2),:),x2(t(:,1),:)-x2(t(:,3),:),2);
normal=edgecross./repmat(sqrt(sum(edgecross.^2,2)),1,3);
%face center
center=(x2(t(:,1),:)+x2(t(:,2),:)+x2(t(:,3),:))./3;
%face area
area=sqrt(sum(edgecross.^2,2))./2;
mesh=sparse(t,t(:,[2,3,1]), repmat(1:nf, 1, 3), nv, nv);
%adjacent face
adjface=reshape(full(mesh(sub2ind([nv,nv],t(:,[2,3,1]),t))),3*nf,1);
%flag:not boundary
flag=logical(adjface);

%%update normal
%newnormal=1/Kpsum(areaj*exp(-||cj-ci||^2/(2*detc))*exp(-||normalj-normali||^2/(2*dets))*normalj)
dets=AverageLong/5;
newnormal=updatenormal(normal,center,dets,adjface,flag,area,nf);

%%update vertices
%x'=x+1/Ni*sum((nj.(cj-xi))nj)
for k=1:20
    x3=updatevertex(x2,t,newnormal,center);
    
    x2=x3;
    center=(x2(t(:,1),:)+x2(t(:,2),:)+x2(t(:,3),:))./3;
end

%%draw mesh
subplot(1,3,3)
patch('Faces',t,'Vertices',x3,'FaceColor','green');
title('Denoising');
    
