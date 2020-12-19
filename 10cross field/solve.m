function [vector1,vector2] = solve(x,t,B1,B2,B3,Constrain,coeff)
nf = size(t, 1);
e = unique( sort( [reshape(t, [], 1), reshape(t(:,[2 3 1]), [], 1)], 2 ), 'rows' );
[K,face1,face2]=computek(x,t,e,B3);
%K to complex
complexK1=exp(-4*K*1i);
complexK2=exp(4*K*1i);
%remove boundary
flag=logical(K);
rne=sum(flag);
face1=face1(flag);
face2=face2(flag);
complexK1=complexK1(flag);
complexK2=complexK2(flag);
%Laplace
L=sparse([face1,face2,face1,face2], [face1,face2,face2,face1], [ones(rne,2),-complexK1,-complexK2], nf, nf);
L(Constrain,:)=0;
dL=diag(L);
dL(Constrain)=1;
L= spdiags(dL,0,L);
b=zeros(nf,1);
b(Constrain)=coeff;
facecoeff=L\b;
facecoeff=facecoeff.^(1/4);
%complex to vector
vector1=repmat(real(facecoeff),1,3).*B1+repmat(imag(facecoeff),1,3).*B2;
vector1=vector1./repmat(sqrt(sum(vector1.^2,2)),1,3);
vector2=-repmat(imag(facecoeff),1,3).*B1+repmat(real(facecoeff),1,3).*B2;
vector2=vector2./repmat(sqrt(sum(vector2.^2,2)),1,3);
end

