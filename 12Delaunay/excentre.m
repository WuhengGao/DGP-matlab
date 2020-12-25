function center= excentre(x,t)
nf = size(t, 1);
nv = size(x, 1);
center=zeros(nf,2);
x2=x(:,[1,2]).^2;
for i=1:nf
    sumx=sum(x2(t(i,:),:),2);
    b=[sumx(1)-sumx(2);sumx(1)-sumx(3)];
    A=2*[x(t(i,1),[1,2])-x(t(i,2),[1,2]);x(t(i,1),[1,2])-x(t(i,3),[1,2])];
    center(i,:)=A\b;
end



end

