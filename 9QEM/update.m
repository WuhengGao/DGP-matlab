function [e,cost,aim] = update(x,e,k2,cost,Qv,aim)
    [near1,~,~]=find(e(:,1)==k2);
    [near2,~,~]=find(e(:,2)==k2);
    [~,mark,~]=unique([e(near1,:);e(near2,[2,1])],'rows');
    near=[near1;near2];
    mark2=1:size(near,1);
    mark2(mark)=[];
    e(near(mark2),:)=zeros(2,2);
    cost(near(mark2))=10^5;
    near=near(mark);
    
    for j=1:size(near,1)       
        Qe=Qv(:,4*e(near(j),1)-3:4*e(near(j),1))+Qv(:,4*e(near(j),2)-3:4*e(near(j),2));
        Qe2=Qe;
        Qe2(4,:)=[0,0,0,1];
        if(abs(det(Qe2))<10^-5)
            aim(near(j),:)=sum(x(e(near(j),:),:),1)/2;
            aimi=[aim(near(j),:)';1];
        else
            aimi=Qe2\[0;0;0;1];
            aim(near(j),:)=aimi(1:3);
        end
        cost(near(j))=aimi'*Qe*aimi;
    end  
end

