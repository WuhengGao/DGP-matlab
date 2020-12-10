function volume = meshvolume(x,t)
volume=abs(sum(dot(cross(x(t(:,1),:),x(t(:,2),:),2),x(t(:,3),:),2),1));
end

