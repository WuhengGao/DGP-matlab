function uv= mvc(x,t)
nf = size(t, 1);
nv = size(x, 1);
[B,~]=findBoundary(x,t);
B=B';
nb=size(B, 1);

%%caculate the three angles and edges of triangles
costheta=cos(meshAngles(x, t));
%tan(theta/2)=(1-cos)/sin
tantheta2=(1-costheta)./sqrt(1-costheta.^2);


%%construct sparse linear equations
%boundary to circle
b=zeros(nv,2);
r=1:nb;
r=2*pi*r/nb;
b(B,1)=sin(r);
b(B,2)=cos(r);

%in boundary:Aii=1,Aij=0;
%not in boundary:Aij=(tan(theta/2)+tan(theta'/2))/||vj-vi||((i,j in a triangle),Aii=-sum(Aij)
detx=meshFaceEdgeLen2s(x, t);
A=sparse([t;t], [t(:, [2,3,1]);t(:,[3,1,2])], [tantheta2./(detx.^0.5);tantheta2./(detx(:,[3,1,2]).^0.5)], nv, nv);
A(B,:)=0;
sumw=-sum(A,2);
sumw(B)=1;
A=spdiags(sumw, 0, A);

uv=A\b;
end

