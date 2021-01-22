function [Q] = Qvertex(x,t,mesh)
nv = size(x, 1);
[~,Nf]=meshNormals(x, t);
Q=zeros(4,4*nv);
for i=1:nv
    near=nonzeros(mesh(:,i));
    nn=size(near,1);
    %dj=nj'*xi
    d=dot(Nf(near,:),repmat(x(i,:),nn,1),2);
    %n2j=(nj,-d)
    n2=[Nf(near,:),-d];
    %Q=sum(n2j*n2j')
    Q(:,4*i-3:4*i)=n2'*n2;
end

end

