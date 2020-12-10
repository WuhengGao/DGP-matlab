function newnormal = updatenormal(normal,center,dets,adjface,flag,area,nf)
%newnormal=1/Kpsum(areaj*exp(-||cj-ci||^2/(2*detc))*exp(-||normalj-normali||^2/(2*dets))*normalj)

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
end

