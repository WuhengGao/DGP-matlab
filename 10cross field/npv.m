%%load mesh
[x,t] = readObj('lilium.obj');
nf = size(t, 1);
nv = size(x, 1);
%local basis for every faces
[B1,B2,B3]=localbasis(x,t);

%%init constrain
Constrain=[1000;2000;4000;5000];
nc=size(Constrain, 1);
arf=rand(nc,1)*2*pi;
cfw=repmat(cos(arf),1,3).*B1(Constrain,:)+repmat(sin(arf),1,3).*B2(Constrain,:);
%cfw to complex
coeff=sum(cfw.*B1(Constrain,:),2)+1i*sum(cfw.*B2(Constrain,:),2);
coeff=coeff.^4;

%%compute vectors for every faces
[vector1,vector2] = solve(x,t,B1,B2,B3,Constrain,coeff);

%%draw cross field
drawcrossfield(x,t,Constrain,vector1,vector2);





