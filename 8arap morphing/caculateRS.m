function [Rarray,Sarray] = caculateRS(x,t,x2)
nf = size(t, 1);
Rarray=zeros(nf,1);
Sarray=zeros(nf,4);

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
end
end

