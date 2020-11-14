function [uv] = tutte(x,t)
nf = size(t, 1);
nv = size(x, 1);
[B,~]=findBoundary(x,t);
B=B';
nb=size(B, 1);

%%construct sparse linear equations
%boundary to circle
b=zeros(nv,2);
r=1:nb;
r=2*pi*r/nb;
b(B,1)=sin(r);
b(B,2)=cos(r);

%in boundary:Aii=1,Aij=0;
%not in boundary:Aij=-1(i,j in a triangle),Aii=-sum(Aij)
A=sparse(t, t(:, [2,3,1]), ones(nf,3), nv, nv);
A(B,:)=0;
sumw=sum(A,2);
sumw(B)=1;
A=-A+diag(sumw);

uv=A\b;
end

