function [centroid,tcent,nr ] = sjcentr(r, ang )

tcent=0;
%find x and y coordinates
for j=1:10;
N=length(r);
for i=1:N;
xco(i)=(r(i))*(cos((ang(i))));
yco(i)=(r(i))*(sin((ang(i))));
end
    
iNext = [2:N 1];

% compute cross products
common = xco .* yco(iNext) - xco(iNext) .* yco;
sx = sum((xco + xco(iNext)) .* common);
sy = sum((yco + yco(iNext)) .* common);

% area and centroid
area = sum(common) / 2;
centroid = [sx sy] / 6 / area;
%drawPolygon(poly);

sr=[1:N];

nxco(sr)=xco(sr)-centroid(1);
nyco(sr)=yco(sr)-centroid(2);

for i=1:N
nr(i)=sqrt((nxco(i)*nxco(i))+(nyco(i)*nyco(i)));
end
r=nr';
tcent=tcent+centroid;
end

nr=nr';

end

