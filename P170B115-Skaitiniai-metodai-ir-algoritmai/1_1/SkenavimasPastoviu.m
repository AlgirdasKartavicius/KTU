function [intervalai]=SkenavimasPastoviu(xmin, xmax, zingsnis, f)
    intervalai = [];
    x = xmin;
    while (x < xmax)
        if (sign(f(x)) ~= sign(f(x + zingsnis)))
            intervalai = [intervalai; x x+zingsnis];
        end
        x = x + zingsnis;
    end
end