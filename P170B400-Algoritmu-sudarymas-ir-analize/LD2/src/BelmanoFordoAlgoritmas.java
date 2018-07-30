import java.util.Objects;
import java.util.Random;
import java.util.concurrent.ThreadLocalRandom;

/**
 * Created by Mangirdas on 2016-05-07.
 */
public class BelmanoFordoAlgoritmas {
    //-------------------Testai-------------------------------------
    public static Grafas sukurtiGrafaSuNeigiamomisBriaunomis(){
        Grafas grafas;
        int v = 7;
        int b = 12;
        grafas = new Grafas(v, b);
        // Briauna 1-2
        grafas.briaunos[0].pr = 1;
        grafas.briaunos[0].pb = 2;
        grafas.briaunos[0].svoris = 7;
        // Briauna 1-3
        grafas.briaunos[1].pr = 1;
        grafas.briaunos[1].pb = 3;
        grafas.briaunos[1].svoris = 5;
        // Briauna 2-3
        grafas.briaunos[2].pr = 2;
        grafas.briaunos[2].pb = 3;
        grafas.briaunos[2].svoris = -3;
        // Briauna 2-5
        grafas.briaunos[3].pr = 2;
        grafas.briaunos[3].pb = 5;
        grafas.briaunos[3].svoris = -4;
        // Briauna 3-4
        grafas.briaunos[4].pr = 3;
        grafas.briaunos[4].pb = 4;
        grafas.briaunos[4].svoris = 10;
        // Briauna 3-5
        grafas.briaunos[5].pr = 3;
        grafas.briaunos[5].pb = 5;
        grafas.briaunos[5].svoris = 3;
        // Briauna 4-2
        grafas.briaunos[6].pr = 4;
        grafas.briaunos[6].pb = 2;
        grafas.briaunos[6].svoris = -2;
        // Briauna 5-4
        grafas.briaunos[7].pr = 5;
        grafas.briaunos[7].pb = 4;
        grafas.briaunos[7].svoris = 12;
        // Briauna 5-6
        grafas.briaunos[8].pr = 5;
        grafas.briaunos[8].pb = 6;
        grafas.briaunos[8].svoris = 4;
        // Briauna 5-7
        grafas.briaunos[9].pr = 5;
        grafas.briaunos[9].pb = 7;
        grafas.briaunos[9].svoris = 2;
        // Briauna 6-4
        grafas.briaunos[10].pr = 6;
        grafas.briaunos[10].pb = 4;
        grafas.briaunos[10].svoris = 3;
        // Briauna 7-6
        grafas.briaunos[11].pr = 7;
        grafas.briaunos[11].pb = 6;
        grafas.briaunos[11].svoris = 3;

        return grafas;
    }
    public static Grafas generuotiGrafa(int n){
        int b = 2*n-1;
        Grafas grafas = new Grafas(n, b);
        for (int i = 1; i <= n-1; i++){
            int pr, pb, svoris;
            Random rnd = new Random();
            pr = i+1;
            pb = i;
            svoris = rnd.nextInt(n+1);
            grafas.briaunos[i-1].pr = pr;
            grafas.briaunos[i-1].pb = pb;
            grafas.briaunos[i-1].svoris = svoris;
        }
        for (int i = 1; i <= n; i++){
            int pr, pb, svoris;
            Random rnd = new Random();
            pr = rnd.nextInt(n+1);
            pb = i;
            while (pr == i){
                pr = rnd.nextInt(n+1);
            }
            svoris = rnd.nextInt(n+1);
            if (pr == 0)
                pr += 1;
            grafas.briaunos[n-2+i].pr = pr;
            grafas.briaunos[n-2+i].pb = pb;
            grafas.briaunos[n-2+i].svoris = svoris;
        }
        return grafas;
    }
    //--------------------------------------------------------------
    public static int[][] trumpiausiKeliai(Grafas grafas, int k){
        int v = grafas.v;
        int b = grafas.b;
        int atstumai[] = new int[v];
        int prec[] = new int[v];
        int ats[][] = new int[2][v];

        boolean pakeitimas;
        boolean turiNeigiamaCikla = false;

        for (int i = 0; i < v; i++){
            atstumai[i] = Integer.MAX_VALUE;
            prec[i] = 0;
        }
        atstumai[k-1] = 0;
        prec[k-1] = k-1;
        // Briaunu relaksacija
        for (int i = 1; i < v; i++) {
            pakeitimas = false;
            for (int j = 0; j < b; j++) {
                int pr = grafas.briaunos[j].pr-1;
                int pb = grafas.briaunos[j].pb-1;
                int svoris = grafas.briaunos[j].svoris;
                if (atstumai[pb] != Integer.MAX_VALUE && atstumai[pb] + svoris < atstumai[pr]) {
                    atstumai[pr] = atstumai[pb] + svoris;
                    prec[pr] = pb+1;
                    pakeitimas = true;
                }
            }
            if (!pakeitimas)
                break;
        }
        // Patikrinimas del neigiamu ciklu
        for (int i = 0; i < b; i++){
            int pr = grafas.briaunos[i].pr-1;
            int pb = grafas.briaunos[i].pb-1;
            int svoris = grafas.briaunos[i].svoris;
            if (atstumai[pb] != Integer.MAX_VALUE && atstumai[pb] + svoris < atstumai[pr]) {
                turiNeigiamaCikla = true;
                break;
            }
        }
        if (turiNeigiamaCikla) {
            ats = null;
            return ats;
        }
        else {
            ats[0] = atstumai;
            ats[1] = prec;
            return ats;
        }
    }
    public static void spausdinti(int atstumai[], int v, int k, int prec[]){
        for (int i = 0; i < v; i++) {
            int einamasis = prec[i];
            if (atstumai[i] != Integer.MAX_VALUE) {
                System.out.print("Atstumas nuo virsunes " + (i+1) + " iki " + k + " = " + atstumai[i] + ";\t");
                if ((i+1) != k) {
                    System.out.print("Kelias: " + (i + 1) + "->");
                    while (einamasis != k) {
                        System.out.print(einamasis + "->");
                        einamasis = prec[einamasis - 1];
                    }
                    System.out.print(k);
                }
                System.out.println();
            }
            else
                System.out.println("Atstumas nuo virsunes " + (i + 1) + " iki " + k + ": NEIMANOMA PRIEITI");
        }
    }

    public static void main(String[] args) {
        if (args.length == 1) {
            if (Objects.equals(args[0], "b")) {
                int ats[][];
                Grafas grafas = sukurtiGrafaSuNeigiamomisBriaunomis();
                ats = trumpiausiKeliai(grafas, 6);
                if (ats != null)
                    spausdinti(ats[0], 7, 6, ats[1]);
                else
                    System.out.println("Grafas turi neigiama cikla, trumpiausiu keliu tiksliai apskaiciuoti negalima.");
            }
        }
        else if (args.length == 3) {
            if (Objects.equals(args[0], "a")) {
                int ats[][];
                Grafas grafas = generuotiGrafa(Integer.parseInt(args[1]));
                ats = trumpiausiKeliai(grafas, Integer.parseInt(args[2]));
                if (ats != null)
                    spausdinti(ats[0], Integer.parseInt(args[1]), Integer.parseInt(args[2]), ats[1]);
                else
                    System.out.println("Grafas turi neigiama cikla, trumpiausiu keliu tiksliai apskaiciuoti negalima.");
            }
        }
        /*int ats[][];
        Grafas grafas = sukurtiGrafaSuNeigiamomisBriaunomis();
        ats = trumpiausiKeliai(grafas, 6);
        if (ats != null)
            spausdinti(ats[0], 7, 6, ats[1]);
        else
            System.out.println("Grafas turi neigiama cikla, trumpiausiu keliu tiksliai apskaiciuoti negalima.");*/
    }
}
