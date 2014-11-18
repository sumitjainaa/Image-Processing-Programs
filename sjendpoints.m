function [] = sjendpoints( )

%read parameters
fl=fopen('slaunch.txt');
tline=fgetl(fl);
par=fscanf(fl,'%f');
fclose(fl);
thres=par(3);
N=par(2);
nrot=par(4);
tni=N*nrot;
ntni=2*tni;
np=2*N;
lthick=5;
xmaxp=par(6);
ymaxp=par(7);
% terr=par(10);
% berr=par(11);
fgr=0.6;
fbl=0.6;

ft=strcat('PIV_',num2str(par(5)),'_',num2str(par(5)),'.txt');
cent_control = fopen(ft,'w');
fprintf(cent_control, '%10s %10s %10s %10s %10s %10s %10s %10s %10s\r\n','%patch', 'uo','v0','uf','vf','du','dv','size','desc');

for k=1:tni;
fi=strcat('IMG_',num2str(k-1+par(1)),'.jpg');

a=imread(fi);
red=a(1:ymaxp,1:xmaxp,1);
gr=a(1:ymaxp,1:xmaxp,2);
bl=a(1:ymaxp,1:xmaxp,3);

b=red>(thres) & gr<(thres*fgr) & bl<(thres*fbl);
for i=1:10;
    ff=1+(i/5);
    ab=red>(thres*ff) & gr<(thres*fgr*ff) & bl<(thres*fbl*ff);
    b=b+ab;
end

c=bwmorph(b,'dilate',2);
% dplot=rem(k,4);
% dplot=dplot+1;
% subplot(2,2,dplot);
%imtool(c);

pr=regionprops(c);

s=size(pr);
for i=1:s(1)
    bbp{k}(i,:)=pr(i,1).BoundingBox;
    %len(i)=bbp(i,4);
end

cen{k}=[pr(1:end,1).Centroid];
cenx{k}=cen{k}(1,1:2:end)';
ceny{k}=cen{k}(1,2:2:end)';

indd=find(ceny{k}>ymaxp);
cenx{k}(indd)=[];
ceny{k}(indd)=[];
xindd=find(cenx{k}>xmaxp);

bbp{k}(indd,:)=[];
bbp{k}(xindd,:)=[];


len=bbp{k}(1:end,4);

[~,imaxp]=max(len);
ep(k,:)=bbp{k}(imaxp(1),:);
ep(k,4)=ep(k,4);
end


%Creating data for PIV file
f=[1:np]';
l(1:np,1)=0.0000;
l(1:np,2)=0.0000;
l(1:np,3)=30.0000;
l(1:np,4)=0.0000;


interr=[40 30 20 10 8 8 8 8];
for i=1:8;
    hpixdiff=ep(:,4);
    avgh=mean(hpixdiff);
    hmax=avgh+interr(i);
    hmin=avgh-interr(i);
    for j=1:tni;
        if hpixdiff(j)>hmax || hpixdiff(j)<hmin
            if j~=1
            ep(j,:)=ep(j-1,:);
            end
            if j==1
            ep(j,:)=ep(N,:);
            end
        end
    end
end

for i=1:tni;
endco((2*i-1),1)=ep(i,1)+lthick;
endco((2*i-1),2)=ep(i,2);
endco((2*i),1)=ep(i,1)+ep(i,3)-lthick;
endco((2*i),2)=ymaxp;
end

for i=1:N
    sumep(i,:)=ep(i,:);
    for j=1:nrot-1
        k=i+(N*j);
        sumep(i,:)=sumep(i,:)+ep(k,:);
    end
    avgep(i,:)=sumep(i,:)/nrot;
end

for i=1:N;
avgendco((2*i-1),1)=avgep(i,1)+lthick;
avgendco((2*i-1),2)=avgep(i,2);
avgendco((2*i),1)=avgep(i,1)+avgep(i,3)-lthick;
avgendco((2*i),2)=ymaxp;
end

centr{k}=[f,avgendco,avgendco,l]';

%Output to PIV file
fprintf(cent_control, '%10.2f %10.2f %10.2f %10.2f %10.2f %10.2f %10.2f %10.2f %10.2f\r\n',centr{k});
fprintf(cent_control, '\n');
fclose(cent_control);

csvwrite('avgep.csv',avgep);


%All the data
allf=[1:ntni]';
alll(1:ntni,1)=0.0000;
alll(1:ntni,2)=0.0000;
alll(1:ntni,3)=30.0000;
alll(1:ntni,4)=0.0000;

allft=strcat('AllPIV_',num2str(par(5)),'_',num2str(par(5)),'.txt');
allcent_control = fopen(allft,'w');
allcentr{k}=[allf,endco,endco,alll]';
%Output All to PIV file
fprintf(cent_control, '%10.2f %10.2f %10.2f %10.2f %10.2f %10.2f %10.2f %10.2f %10.2f\r\n',allcentr{k});
fprintf(cent_control, '\n');
fclose(cent_control);

csvwrite('ep.csv',ep);

end