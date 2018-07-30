% Dvilypio integralas baricentrinese koordinatese

function main
clc,clear all,close all

A=[0 0; 
   1 2;
   2 1 ];
figure (1),hold on, grid on , axis equal
fill(A(:,1),A(:,2),'y')
for i=1:3,text(A(i,1),A(i,2),sprintf('A%1d(%d,%d)',i,A(i,:)),'Color','r','FontSize',18);end

bbb=[1/8,1/2,3/8]
B=bbb*A;
plot(B(1),B(2),'b*','MarkerSize',18)
text(B(1)+0.1,B(2),sprintf('B(%3.2g,%3.2g)',B),'Color','b','FontSize',18);
text(B(1)+0.1,B(2)-0.1,sprintf('B(%3.2g,%3.2g,%3.2g)',bbb),'Color','m','FontSize',18);

figure (2),hold on, grid on , axis equal
fill(A(:,1),A(:,2),'y');

n=1
switch n
    case 1
    bbb=[1/3 1/3 1/3]
    w=[1]
    case 3
    bbb=[0.5 0.5 0;
     0 0.5 0.5;
     0.5 0 0.5]
 w=[1/3,1/3,1/3]
 
    case 4
 bbb=[1/3	1/3	1/3;
     0.6	0.2	0.2;
     0.2	0.6	0.2;
     0.2	0.2	0.6]
 w=[-27/48,25/48,25/48,25/48]
 
    case 7
  a1=0.0597150717;a2=0.7974269853;b1=0.4701420641;b2=0.1012865073;
 bbb=[1/3	1/3	1/3;
     a1 b1 b1;
     b1 a1 b1;
     b1 b1 a1;
     a2 b2 b2
     b2 a2 b2;
     b2 b2 a2;]
 w=[0.225 ,0.1323941527,0.1323941527,0.1323941527,0.1259391805,0.1259391805,0.1259391805]
end
 for i=1:n
     B=bbb*A;
     plot(B(i,1),B(i,2),'b*','MarkerSize',18);
     text(B(i,1)+0.1,B(i,2),sprintf('B(%3.2g,%3.2g,%3.2g,%3.2g,%3.2g,%3.2g,%3.2g)',bbb(i,:)),'Color','b','FontSize',18);
     text(B(i,1)+0.1,B(i,2)-0.1,sprintf('w=%10.7g',w(i)),'Color','k','FontSize',18);
 end