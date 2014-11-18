function [] = sjdots( )

%read the parameters from launcher file
fl=fopen('slaunch.txt');
tline=fgetl(fl);
par=fscanf(fl,'%f');
fclose(fl);
nimag=par(2);
thres=par(3);
nrot=par(4);
N=nrot*nimag;
xmaxp=par(6);
ymaxp=par(7);

%creating the PIV file and writing first line
ft=strcat('PIV_',num2str(par(5)),'_',num2str(par(5)),'.txt');
cent_control = fopen(ft,'w');
fprintf(cent_control, '%10s %10s %10s %10s %10s %10s %10s %10s %10s\r\n','%patch', 'uo','v0','uf','vf','du','dv','size','desc');

%finding the centroid in all images
for k=1:N;
    fi=strcat('IMG_',num2str(k-1+par(1)),'.jpg');
    a=imread(fi);

    red=a(1:(ymaxp-5),1:xmaxp,1);
    b=red>thres;
    c=bwmorph(b,'dilate',2);


    pr=regionprops(c);
    cen{k}=[pr(1:end,1).Centroid];
    cenx{k}=cen{k}(1,1:2:end)';
    ceny{k}=cen{k}(1,2:2:end)';

    indd=find(ceny{k}>ymaxp);
    cenx{k}(indd)=[];
    ceny{k}(indd)=[];
    xindd=find(cenx{k}>xmaxp);
    cenx{k}(xindd)=[];
    ceny{k}(xindd)=[];
    cent{k}=[cenx{k},ceny{k}];
    [~, inx]=sort(cent{k}(:,2));
    sortcent{k}=cent{k}(inx,:);
end

%combining the points with multiple rotations
for i=1:nimag;
    comb=sortcent{i};    
    for j=2:nrot;
        temp=sortcent{i+((j-1)*nimag)};
        comb=cat(1,comb,temp);
    end
    s(i,:)=size(comb);
    f{i}=[1:s(i,1)]';
    %f{i}(1)=i*100+1;
    l{i}(1:s(i,1),1)=0.0000;
    l{i}(1:s(i,1),2)=0.0000;
    l{i}(1:s(i,1),3)=30.0000;
    l{i}(1:s(i,1),4)=0.0000;
    combcent{i}=comb;
    centr{i}=[f{i},combcent{i},combcent{i},l{i}]';
    fprintf(cent_control, '%10.2f %10.2f %10.2f %10.2f %10.2f %10.2f %10.2f %10.2f %10.2f\r\n',centr{i});
    fprintf(cent_control, '\n');
end
fclose(cent_control);

%write number of points detected in an image
csvwrite('ss.csv',s);

end