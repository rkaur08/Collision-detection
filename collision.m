clc
clear all
close all
vid=videoinput('winvideo',1, 'YUY2_640x480');

set(vid,'ReturnedColorSpace','rgb');

set(vid,'FramesPerTrigger',1);
set(vid,'TriggerRepeat',Inf);
/+The set(vid,’FramesPerTrigger’,1) will set the capture rate to 1 i.e. each time we trigger the camera device it will capture single frame.*/


start(vid);
trigger(vid);


im=getdata(vid,1);


s=size(im);


thr=0.85;  //variables
thr1=0.50;
thr2=0.80;



[x,y,k]=impixel(im); //selection


[x1,y1,k1]=impixel(im); 

[x2,y2,k2]=impixel(im); 


r_min=k(1)-thr*(k(1));
r_max=k(1)+thr*(k(1));
g_min=k(2)-thr*(k(2));
g_max=k(2)+thr*(k(2));
b_min=k(3)-thr*(k(3));
b_max=k(3)+thr*(k(3));


[x1,y1,k1]=impixel(im);
r_min1=k1(1)-thr1*(k1(1));
r_max1=k1(1)+thr1*(k1(1));
g_min1=k1(2)-thr1*(k1(2));
g_max1=k1(2)+thr1*(k1(2));
b_min1=k1(3)-thr1*(k1(3));
b_max1=k1(3)+thr1*(k1(3));
 
[x2,y2,k2]=impixel(im);
r_min2=k2(1)-thr2*(k2(1));
r_max2=k2(1)+thr2*(k2(1));
g_min2=k2(2)-thr2*(k2(2));
g_max2=k2(2)+thr2*(k2(2));
b_min2=k2(3)-thr2*(k2(3));
b_max2=k2(3)+thr2*(k2(3));


im_new=zeros(s(1),s(2));
im_new1=zeros(s(1),s(2));
im_new2=zeros(s(1),s(2));


for kk=1:100
    
  trigger(vid);
 im=getdata(vid,1);
 s=size(im);
 
 
r_min=k(1)-thr*(k(1));
r_max=k(1)+thr*(k(1));
g_min=k(2)-thr*(k(2));
g_max=k(2)+thr*(k(2));
b_min=k(3)-thr*(k(3));
b_max=k(3)+thr*(k(3));
 
r_min1=k1(1)-thr1*(k1(1));
r_max1=k1(1)+thr1*(k1(1));
g_min1=k1(2)-thr1*(k1(2));
g_max1=k1(2)+thr1*(k1(2));
b_min1=k1(3)-thr1*(k1(3));
b_max1=k1(3)+thr1*(k1(3));
 
r_min2=k2(1)-thr2*(k2(1));
r_max2=k2(1)+thr2*(k2(1));
g_min2=k2(2)-thr2*(k2(2));
g_max2=k2(2)+thr2*(k2(2));
b_min2=k2(3)-thr2*(k2(3));
b_max2=k2(3)+thr2*(k2(3));
 
im_r=im(: , : , 1);
im_g=im(: , : , 2);
im_b=im(: , : , 3);
im_new=zeros(s(1),s(2));
im_new1=zeros(s(1),s(2));
im_new2=zeros(s(1),s(2));
 
ind=find(im(:,:,1)<=r_max & im(:,:,1)>=r_min & im(:,:,2)<=g_max & im(:,:,2)>=g_min & im(:,:,3)<=b_max & im(:,:,3)>=b_min );
 
im_new(ind)=1;
 
ind1=find(im(:,:,1)<=r_max1 & im(:,:,1)>=r_min1 & im(:,:,2)<=g_max1 & im(:,:,2)>=g_min1 & im(:,:,3)<=b_max1 & im(:,:,3)>=b_min1 );
 
im_new1(ind1)=1;
 
ind2=find(im(:,:,1)<=r_max2 & im(:,:,1)>=r_min2 & im(:,:,2)<=g_max2 & im(:,:,2)>=g_min2 & im(:,:,3)<=b_max2 & im(:,:,3)>=b_min2 );
 
im_new2(ind2)=1;
                                                                                                                                                                                         

im_bw=im_new;
im_bw1=im_new1;
im_bw2=im_new2;
 
imshow(im);


if(s1(1)>15)
val1=regionprops(im_bw,'Centroid');
c1=val1.Centroid(1);
c2=val1.Centroid(2);
plot(c1,c2,'r*');
end
if(s2(1)>15)
val2=regionprops(im_bw1,'Centroid');
c11=val2.Centroid(1);
c21=val2.Centroid(2);
plot(c11,c21,'g*');
end
if(s3(1)>15)
val3=regionprops(im_bw2,'Centroid');
c12=val3.Centroid(1);
c22=val3.Centroid(2);
plot(c12,c22,'b*');
end

//for each white region regionprops variable are created to get the centroid for the object regions and plot an ‘*’ on them.//


kk1=[ c1 c11 c12 c1];
kk2=[ c2 c21 c22 c2];
d1=sqrt(power(c1-c11,2)+power(c2-c21,2));
d2=sqrt(power(c11-c12,2)+power(c21-c22,2));
d3=sqrt(power(c12-c1,2)+power(c22-c2,2));
d1 = d1*0.02890625;//converting pixels into cm.
d2 = d2*0.02890625;
d3 = d3*0.02890625;
if(d1<3.5 || d2<3.5 || d3<3.5)
text(550,14,'COLLISION!!!!!','Color','R');
//if the distance between objects goes below a minimum limit, it shows that collision has occurred.
end
d1=num2str(d1);
d2=num2str(d2);
d3=num2str(d3);
d1 = strcat(d1,'cm');
d2 =strcat(d2,'cm');
d3 =strcat(d3,'cm');
j1=(c1+c11)/2;
j2=(c2+c2)/2;
text(j1,j2,d1,'Color','Y');//printing the measurements.
j3=(c11+c12)/2;
j4=(c21+c22)/2;
text(j3,j4,d2,'Color','g');
j5=(c12+c1)/2;
j6=(c22+c2)/2;
text(j5,j6,d3,'Color','r');
plot(kk1,kk2)



kk=[ c1 c11 c12 c1];
kk2=[ c2 c21 c22 c2];
 
plot(kk,kk2)
hold off;

end
 stop(vid);
 delete vid;
