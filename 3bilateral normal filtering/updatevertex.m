function [x3] = updatevertex(x2,t,newnormal,center)
nv = size(x2,1);
nf = size(t, 1);
%mesh volume:sum(signed volume of triangle with origin)
volume1=meshvolume(x2,t);
x3=zeros(nv,3);
%Ni:number of adjacent faces
Ni=zeros(nv,1);
for i=1:3
    %x'=x+1/Ni*sum((nj.(cj-xi))nj)
    detx=repmat(sum((center-x2(t(:,i),:)).*newnormal,2),1,3).*newnormal;
    for j=1:3
        x3(:,j)=x3(:,j)+accumarray(t(:,i),detx(:,j),[nv,1]);
    end
    Ni=Ni+accumarray(t(:,i),ones(nf,1),[nv,1]);
end
x3=x3./repmat(Ni,1,3)+x2;
%keep volume
volume2=meshvolume(x3,t);
x3=x3.*((volume1/volume2)^(1/3));   
end

