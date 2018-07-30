function [a, b, i, tikslumas]=SkenavimasRekursija(xmin, xmax, zingsnis, tol, f, iteracijos_sk, draw)
    x = xmin;
    iteracijos_sk = iteracijos_sk + 1;
    while x < xmax
        if zingsnis < tol
            a = xmin; 
            b = xmax; 
            i = iteracijos_sk;
            tikslumas = abs(f(xmax));
            return;
        end
        if (sign(f(x))~=sign(f(x+zingsnis)))
            if (draw == 1 && iteracijos_sk < 7)
                plot(xmin, 0, 'go', 'LineWidth', 2); h = findobj(gca,'Type','line');h1=h(1);
                plot(xmax, 0, 'go', 'LineWidth', 2); h = findobj(gca,'Type','line');h2=h(1);
                input('Press Enter'), figure(1);
                delete(h1); delete(h2);
            end
            [a,b,i,tikslumas]=SkenavimasRekursija(x, x+zingsnis, zingsnis/10, tol, f, iteracijos_sk, draw);
        end
        x=x+zingsnis;
    end
end