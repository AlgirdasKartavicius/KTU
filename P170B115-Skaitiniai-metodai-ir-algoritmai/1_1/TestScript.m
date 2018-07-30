f=@(x)(x-2).*sin(x);
xx = -5:0.1:5;
xmin = xx(1); xmax = xx(end);
figure; hold on; grid on; 
plot(xx, f(xx), 'k-', 'LineWidth', 4);
zingsnis = 0.1;
x=xmin;
SaknuIntervalas=[];
tol = 1e-9;
while x < xmax
    if (sign(f(x))~=sign(f(x+zingsnis)))
        [a, b]=ScanRecursion(x, x+zingsnis, zingsnis/10, tol, f);
        SaknuIntervalas=[SaknuIntervalas; a b];
    end
    x=x+zingsnis;
end
saknys=(SaknuIntervalas(:,1)+SaknuIntervalas(:,2))/2;
saknys