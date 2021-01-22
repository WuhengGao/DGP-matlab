function [x,t] = cleargarbage(x,t,garbagex,garbaget)
x(garbagex,:)=[];
garbagex=sort(garbagex,'descend');
garbaget=unique(reshape(garbaget,[],1));
t(garbaget,:)=[];
for i=1:size(garbagex, 1)
   t(t>garbagex(i))=t(t>garbagex(i))-1;
end
end

