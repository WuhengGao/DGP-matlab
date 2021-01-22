%%load mesh
[x,t] = readObj('rgb_dragon.obj');
nv2=round(nv/4);
%[x,t] = readObj('fandisk.obj');
%nv2=round(nv/2);
x2=x;
t2=t;
nf = size(t2, 1);
nv = size(x2, 1);
e = unique( sort( [reshape(t,3*nf, 1), reshape(t(:,[2 3 1]), 3*nf, 1)], 2 ), 'rows' );
mesh=sparse(t, t(:, [2:end 1]), repmat(1:nf, 1, 3), nv, nv);
%mesh2=mesh;
%mesh2(mesh&mesh')=0;
%mesh=mesh+mesh2';
%QEM of vertex
Qv=Qvertex(x2,t2,mesh);

%cost and aim of edge
[cost,aim] = Qedge(x2,e,Qv);

garbagex=zeros(nv2,1);
garbaget=zeros(nv2,2);
i=1;
while i<=nv2
    [test,k]=min(cost);
    k1=e(k,1);k2=e(k,2);
    %collapse edge e(k,:)
    if ~iscollapseok(mesh,k1,k2)
        cost(k)=10^5;       
        continue
    end
    [mesh,garbagetk]=collapse(t2,k1,k2,mesh);
    x2(k2,:)=aim(k,:);
    t2(t2==k1)=k2;
    garbagex(i)=k1;
    garbaget(i,:)=garbagetk;
    %Qv'=Qv1+Qv2
    Qv(:,4*k2-3:4*k2)=Qv(:,4*k2-3:4*k2)+Qv(:,4*k1-3:4*k1);       
    e(e==k1)=k2;
    e(k,:)=[0,0];
    cost(k)=10^5;
    [e,cost,aim] = update(x2,e,k2,cost,Qv,aim);
    i=i+1;
end
%[x2,t2] = cleargarbage(x2,t2,garbagex,garbaget);
drawQEM(x,t,x2,t2);
[flipfaces, ~]=checkFlip(x2,t2);



