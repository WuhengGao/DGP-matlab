function [uv] = tutte(x,t)
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
%not in boundary:Aij=1(i,j in a triangle),Aii=-sum(Aij)
A=sparse(t, t(:, [2,3,1]), true, nv, nv);
A=A|A';
dA=-sum(A,2);
dA(B,:)=1;
A(B,:)=0;
A= spdiags(dA, 0, double(A));

uv=A\b;
end

