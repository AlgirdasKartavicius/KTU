    
% Apibreztinio integralo skaitinio apskaiciavimo formules 
% svorio koeficientu apskaiciavimas Hemingo metodu

function Hemming

a=-1
b=1 

for n=1:10
    if n > 1,  dx=(b-a)/(n-1); x=[a:dx:b]; else, x=a; end
    for i=1:n  % sukuriama l.s. matrica
        G(i,1:n)=x.^(i-1);
        m(i)=(b^i-a^i)/i;
    end
    w=(G\m')/(b-a);
    fprintf('\n integravimo tasku skaicius = %d,   koeficientai   ',n)
    fprintf('  %d  ',w)
end

end