function [center] = FaceCenter(x,t)
center=(x(t(:,1),:)+x(t(:,2),:)+x(t(:,3),:))/3;
end

