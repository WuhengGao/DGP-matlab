%%load mesh
[x,t] = objread('fandisk.obj');
x=x';t=t';
nf = size(t, 1);
nv = size(x, 1);
e=sort([t(:,[1,2]);t(:,[2,3]);t(:,[3,1])],2);
e=unique(e,'rows');
%draw mesh
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
%detc:average face distance
center3=repmat(center,3,1);
detc=sum(sqrt(sum((center3(flag,:)-center(adjface(flag),:)).^2,2)),1)/(3*nf);
wc=zeros(3*nf,1);
wc(flag)=exp(-sum((center(adjface(flag),:)-center3(flag,:)).^2,2)./(2*detc));
for k=1:20
    ws=zeros(3*nf,1);
    normal3=repmat(normal,3,1);
    adjnormal=zeros(3*nf,3);
    adjnormal(flag,:)=normal(adjface(flag),:);
    ws(flag)=exp(-sum((adjnormal-normal3(flag,:)).^2,2)./(2*dets));
    w=reshape(repmat(area,3,1).*wc.*ws,nf,3);
    newnormal=zeros(nf,3);
    for i=1:3
    newnormal(:,i)=sum(w.*reshape(adjnormal(:,i),nf,3)./repmat(sum(w,2),1,3),2);
    end
    %normalization
    newnormal=newnormal./repmat(sqrt(sum(newnormal.^2,2)),1,3);
    normal=newnormal;
end

%%update vertices
%x'=x+1/Ni*sum((nj.(cj-xi))nj)
for k=1:20
    %mesh volume:sum(signed volume of triangle with origin)
    volume1=abs(sum(dot(cross(x2(t(:,1),:),x2(t(:,2),:),2),x2(t(:,3),:),2),1));
    x3=zeros(nv,3);
    %Ni:number of adjacent faces
    Ni=zeros(nv,1);
    for i=1:3
        detx=repmat(sum((center-x2(t(:,i),:)).*newnormal,2),1,3).*newnormal;
        for j=1:3
        x3(:,j)=x3(:,j)+accumarray(t(:,i),detx(:,j),[nv,1]);
        end
        Ni=Ni+accumarray(t(:,i),ones(nf,1),[nv,1]);
    end
    x3=x3./repmat(Ni,1,3)+x2;
    %keep volume
    volume2=abs(sum(dot(cross(x3(t(:,1),:),x3(t(:,2),:),2),x3(t(:,3),:),2),1));
    x3=x3.*((volume1/volume2)^(1/3));
    
    x2=x3;
    center=(x2(t(:,1),:)+x2(t(:,2),:)+x2(t(:,3),:))./3;
end

%%draw mesh
subplot(1,3,3)
patch('Faces',t,'Vertices',x3,'FaceColor','green');
title('Denoising');
    
