function [K,face1,face2] = computek(x,t,e,Nf)
nf = size(t, 1);
nv = size(x, 1);
mesh=sparse(t, t(:, [2:end 1]), repmat(1:nf, 1, 3), nv, nv);
ne = size(e, 1);
[B,~]=findBoundary(x,t);
K=zeros(ne,1);
face1=zeros(ne,1);
face2=zeros(ne,1);
for i=1:ne
    f1=mesh(e(i,1),e(i,2));
    f2=mesh(e(i,2),e(i,1));
    face1(i)=f1;
    face2(i)=f2;
    if ismember(e(i,1),B)&&ismember(e(i,2),B)
       continue;
    end
    id2=find(t(f2,:)==e(i,2));
    common_edge=x(e(i,2),:)-x(e(i,1),:);
    common_edge=common_edge./repmat(sqrt(sum(common_edge.^2,2)),1,3);
    P=[common_edge;-cross(Nf(f1,:),common_edge,2);Nf(f1,:)];
    V1=x(t(f1,:),:)-repmat(x(e(i,1),:),3,1);
    V1=(P*(V1'))';
    V2=x(t(f2,:),:)-repmat(x(e(i,1),:),3,1);
    V2=(P*(V2'))';
    arf=-atan2(V2(mod(id2+1,3)+1,3),V2(mod(id2+1,3)+1,2));
    R=[1,0,0;0,cos(arf),-sin(arf);0,sin(arf),cos(arf)];
    V2=(R*(V2'))';
    ref1= V1(2,:) - V1(1,:);
    ref2= V2(2,:) - V2(1,:);
    ref1=ref1./repmat(sqrt(sum(ref1.^2,2)),1,3);
    ref2=ref2./repmat(sqrt(sum(ref2.^2,2)),1,3);
    K(i)=atan2(ref2(2),ref2(1)) - atan2(ref1(2),ref1(1));
end
end

