% Jautrumas paklaidoms
clc
% A=[ 1   2  3.0001;
%     1   2  3;
%     1.0001 2  3 ]
% A=[ 1 2 -3;
%     -4 5 6;
%     7 -8 9 ]
% A=[ 1 0 0;
%     0 5 0;
%     0 0 9 ]
A=[ 11  -5 12;
     6  -2 10;
     0  13 29 ]
norm1=norm(A)*norm(inv(A))
norm2=cond(A)

