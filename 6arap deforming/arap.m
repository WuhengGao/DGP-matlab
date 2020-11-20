function [x2] = arap(x,t,handle,aim,init)
nf = size(t, 1);
nv = size(x, 1);

%init
x2=init;

%%local-global iteration
%nearij=1(i,j in a triangle)
near=sparse(t, t(:, [2,3,1]), ones(nf,3), nv, nv);
near(near|near')=1;
%wij=1/Ni
Ni=sum(near,2);
%anchor points:handle
A=near;
A(handle,:)=0;
sumw=Ni;
sumw(handle)=1;
%Aij=-wij,Aii=1
A=-A+diag(sumw);
A=A./repmat(sumw,1,nv);

for k=1:10
    %local update
    Rarray=zeros(nv,9);
    for i=1:nv
        %St=sum(wij(xi-xj)(x2i-x2j)')
        flag=find(near(i,:));
        St=zeros(3,3);
        for j=1:size(flag,2)
            St=St+(x(i,:)-x(flag(j),:))'*(x2(i,:)-x2(flag(j),:));
        end
        St=St/Ni(i);
        [U,~,V]=svd(St);
        R=V*U';
        if det(R)<0
            U(:,end)=-U(:,end);
            R=V*U';
        end
        Rarray(i,:)=reshape(R,1,9);
    end
    %caculate b
    b=zeros(nv,3);
    for i=1:nv
        %b(i,:)=wij/2(Ri+Rj)(xi-xj)
        Ri=reshape(Rarray(i,:),3,3);
        flag=find(near(i,:));
        for j=1:size(flag,2)
            Rj=reshape(Rarray(flag(j),:),3,3);
            b(i,:)=b(i,:)+((Ri+Rj)*(x(i,:)-x(flag(j),:))')';
        end
        b(i,:)=b(i,:)/(2*Ni(i));
    end
    b(handle,:)=aim;
    
    x2=A\b;
end
end

