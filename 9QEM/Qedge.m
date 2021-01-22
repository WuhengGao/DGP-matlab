function [cost,aim] = Qedge(x,e,Qv)
ne = size(e, 1);
cost=zeros(ne,1);
aim=zeros(ne,3);
for i=1:ne
    Qe=Qv(:,4*e(i,1)-3:4*e(i,1))+Qv(:,4*e(i,2)-3:4*e(i,2));
    Qe2=Qe;
    Qe2(4,:)=[0,0,0,1];
    if(abs(det(Qe2))<10^-5)
        aim(i,:)=sum(x(e(i,:),:),1)/2;
        aimi=[aim(i,:)';1];
    else
        aimi=Qe2\[0;0;0;1];
        aim(i,:)=aimi(1:3);
    end
    cost(i)=aimi'*Qe*aimi;
end
end

