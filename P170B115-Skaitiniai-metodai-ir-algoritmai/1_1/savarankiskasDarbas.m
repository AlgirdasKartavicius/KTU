function savarankiskasDarbas
clc ;
close all;
format long;
% -------------------------------------------------
  f='x.^4+5*x.^3-2*x.^2-24*x';
  range=[-6,6]; %pirmam range
%--------------------------------------------------
 options = 0; % 1 bus antra lygtis;
%--------------------------------------------------
if options == 1
   f='sin(x).*log(x)-(x./6)';
   range=[1,20]; %antram range
end  
name='savarankiskasDarbas';
% braizomas funkcijos grafikas f
npoints=10000; x=range(1): (range(2)-range(1))/(npoints-1) :range(2);  
figure(1); grid on; hold on;
str=[f,' ',name]; title(str);
plot(x,eval(f),'r-');
plot(range,[0 0],'g-');

%grubus ivertinimas
 grubus = 25; %24+1/1;
% figure(1);grid on;hold on

%tiklesnis ivertinimas
% teigimiem
% k = didziausias is neigiamu koficientu (pirmas neimamas)
% k  = 2; nes  4 - 2 nes -2 x indeksas 2
% B = diziausias is neigiamu moduliu
% B = 24
Rteig = (24/1)^(1/2) + 1;

% Neigiamiem 
%  neigiamom reikalingas daugianario  x.^4+5*x.^3-2*x.^2-24*x
%  perskaiciuoti indeksai
%  (-x)^4 = x taigi 1
%  (-x)^3 = -x taigi -5
%  (-x)^2 = x taigi -2
%  (-x)^1 = -x taigi 24
%  tada B = 5
%  k = 1 nes -5 didziausias indeksas yra 3( 4 - 3 = 1 )
Rneig = 1+(5/1)^(1/1);
% pirmos papildomi braizymai
if options == 0
  plot(-min(grubus,Rneig),0,'bp')
  plot(min(grubus,Rteig),0,'bp')
  plot([-grubus,grubus],[0 0],'r*')
end
% --------------------------------------------------
% Skenavimas nekintaciu zingsniu
% a - pradzia intervalo b - pabaiga step - greitis ejimo
step = 0.5;
  a = Rteig;
  b = Rneig;
  if options == 1
  a = 1;
  b = 20;
  end
%------------
 xBegin = -ceil(a)-0.1;
 xEnd = ceil(b)+0.1;
 if options == 1
 xBegin = ceil(a);
 xEnd = ceil(b);
 end
xMiddle = 0;
cnt = 1;
roots=zeros(2,1);
while xBegin < xEnd
    xMiddle = xBegin+step;
        fxBegin = feval(inline(f),xBegin);
        fxMiddle = feval(inline(f),xMiddle);
    if sign(fxBegin) ~=  sign(fxMiddle)
         roots(1,cnt) = xBegin;
         roots(2,cnt) = xMiddle;
         cnt = cnt + 1;
     end
    xBegin = xMiddle;
end
roots
disp( sprintf( 'Skaicius saknu: '));
[dontCare,numberOfRoots] = size(roots);
% --------------------------------------------------
% saknu tikslinimas kintaciu zingsiu
% prec  - tikslumas
% eps - siekiamas tikslumas
disp( sprintf( 'Tikslinimas skenavimu: '));
disp( sprintf( '-------------------------------------------------- : '));
  eps=1e-9;
  prec=1;
  xRoot = zeros(1,numberOfRoots);
  for i = 1:numberOfRoots
          xBegin = roots(1,i);
          xEnd = roots(2,i);
          prec = 1;
          int  = 0 ;
      while prec > eps
          step = abs(xEnd - xBegin)/20;
          while xBegin < xEnd
            xMiddle = xBegin+step;
            fxBegin = feval(inline(f),xBegin);
            fxMiddle = feval(inline(f),xMiddle);
             if sign(fxBegin) ~=  sign(fxMiddle)
                xEnd = xMiddle;
                break;
             end
                xBegin = xMiddle;
                int = int + 1;
          end
         prec = abs(feval(inline(f),xBegin));
         xRoot(i) = xBegin;
      end
     disp( sprintf( 'Number of iterations %d ', int ));
     disp( sprintf( 'Precision %d ', prec ));
  end 
  disp( sprintf( 'Final roots: '));
  xRoot'
% --------------------------------------------------  
  disp( sprintf( 'Tikslinimas stygu metodu: '));
  disp( sprintf( '-------------------------------------------------- : '));
% saknu tikslinimas stygu metodu
xRootChords = zeros(1,numberOfRoots);
for i = 1:numberOfRoots
          xBegin = roots(1,i);
          xEnd = roots(2,i);
          prec = 1;
          int  = 0 ;
      while prec > eps
            fxBegin = feval(inline(f),xBegin);
            fxEnd = feval(inline(f),xEnd);
            k = abs(fxBegin/fxEnd);
            xMiddle = (xBegin + k*xEnd)/(1+k);
            fxMiddle = feval(inline(f),xMiddle);
             if sign(fxBegin) ==  sign(fxMiddle)
                xBegin = xMiddle;
             else
                 xEnd = xMiddle;
            
             end
                xBegin = xMiddle;
                int = int + 1;
       if int > 200
           disp( sprintf( 'Operation overflow %d ', int ));
           break;
       end
         prec = abs(feval(inline(f),xBegin));
         xRootChords(i) = xBegin;
      end
      if int < 200
     disp( sprintf( 'Number of iterations %d ', int ));
     
      end
      disp( sprintf( 'Precision %d ', prec ));
end 
  disp( sprintf( 'Final roots: '));
  xRootChords'
  % --------------------------------------------------  
  disp( sprintf( 'Tikslinimas kirstiniu metodu: '));
  disp( sprintf( '-------------------------------------------------- : '));
% saknu tikslinimas kirstiniu metodu
xRootSecants = zeros(1,numberOfRoots);
for i = 1:numberOfRoots
    cls1 = roots(1,i) - 0.2;
    cls0 = roots(1,i) - 0.1;
    fcls0 = feval(inline(f),cls0);
    fcls1 = feval(inline(f),cls1);
    deltax = (fcls1-fcls0)/(cls1-cls0);
    int  = 0 ;
    prec = 1;
    while prec > eps
        cls1 = cls0 - fcls0/deltax;
        fcls1 = feval(inline(f),cls1);
        deltax = (fcls1-fcls0)/(cls1-cls0);
        cls0 = cls1;
        fcls0 = fcls1;
        int = int + 1;
        prec = abs(feval(inline(f),fcls1));
        xRootSecants(i) = cls1;
        if int > 200
           disp( sprintf( 'Operation overflow %d ', int ));
           break;
        end
    end
    if int < 200
     disp( sprintf( 'Number of iterations %d ', int ));
     
    end
    disp( sprintf( 'Precision %d ', prec ));
end
disp( sprintf( 'Final roots: '));
xRootSecants'
% -------------------------------------------------- 
g=@(x)(x.^4+5*x.^3-2*x.^2-24*x);
if options == 1
  g=@(x)(sin(x).*log(x)-(x./6));
end
for i=1:numberOfRoots
    x0 = (roots(2,i)+roots(1,i))/2;
    fzero(g,x0)
end
end