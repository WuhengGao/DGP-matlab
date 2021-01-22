function [ok] = iscollapseok(mesh,k1,k2)
ok=true;
if nnz(mesh(:,k1)&mesh(:,k2))~=2
    ok=false;
end
end

