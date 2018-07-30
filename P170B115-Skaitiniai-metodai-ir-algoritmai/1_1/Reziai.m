function [R_grub, R_neig, R_teig] = Reziai(n, a)
    %Rgrub
    R_grub = 1 + max(abs(a(2:end)))/a(1);
    % Rteig skaiciavimas
    b = a(2:end);
    B = max(abs(b(b<0)));
    k = n - (n - (find(b<0, 1)));
    R_teig = 1 + (B/a(1))^(1/k);
    % Rneig skaiciavimas
    if mod(n, 2) == 0
        a(end:-2:1) = -a(end:-2:1);
        b = a(2:end);
        B = max(abs(b(b<0)));
        k = n - (n - (find(b<0, 1)));
        R_neig = 1 + (B/a(1))^(1/k);
        R_neig = -R_neig;
    else
        a(end:-2:1) = -a(end:-2:1);
        a = a.*-1;
        b = a(2:end);
        B = max(abs(b(b<0)));
        k = n - (n - (find(b<0, 1)));
        R_neig = 1 + (B/a(1))^(1/k);
        R_neig = -R_neig;
    end;
end