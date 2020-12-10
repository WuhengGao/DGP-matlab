function [H1array,H2array] = caculateH(x,t)
nf = size(t, 1);
H1array=zeros(nf,3);
H2array=zeros(nf,3);
for i=1:nf
    H=inv([x(t(i,:),[1,2]),ones(3,1)]);
    H1array(i,:)=H(1,:);
    H2array(i,:)=H(2,:);
end
end

