/* Baltulionis Simonas IFF-4/1 Komp: 26 */
package baltulionissimonas_l2g;

import static java.lang.Math.abs;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.logging.Level;
import java.util.logging.Logger;

// Monitoriaus klasė
class BendrasMasyvas {
    private int a = 100;
    private int b = 0;
    // Masyvas skirtas išsisaugoti, kurie procesai jau nuskaitė a ir b reikšmes.
    // Pakeitus a ir b reikšmes, visos šio masyvo reikšmes nustatomos false, nes nė vienas procesas
    // dar nebuvo neskaitęs.
    private boolean arNuskaiteVisi[] = new boolean[BaltulionisS_L2g.SkaitytojuProcesuKiekis];
    public synchronized void keistiReiksmes() {
        while(!arVisiPerskaite() && paiimtiAirBSkirtuma() > 20) {
            try {
                wait();
            } catch (InterruptedException ex) {
                Logger.getLogger(BendrasMasyvas.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        if(!(paiimtiAirBSkirtuma() > 20)) {
            return;
        }
        a = a - 10;
        b = b + 10;
        // Nustatome visas reikšmes į false, kadangi dar nė vienas procesas nenuskaitė naujų reikšmių.
        for (int i = 0; i < arNuskaiteVisi.length; i++) {
            arNuskaiteVisi[i] = false;
        }
        notifyAll();
    }
    public synchronized void skaitytiReiksmes(int procesoNr) {
        while(arVisiPerskaite()) {
            try {
                wait();
            } catch (InterruptedException ex) {
                Logger.getLogger(BendrasMasyvas.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        // Tas pačias a ir b reikšmes spausdiname tik vieną kartą
        if(!BaltulionisS_L2g.BendrasMasyvas.arBentVienasPerskaite()) {
            System.out.println(procesoNr + ": a = " + a + ", b = " + b + ";");
        }
        // Nustatome, kad procesas nuskaitė
        arNuskaiteVisi[procesoNr - BaltulionisS_L2g.KeitejuProcesuKiekis - 1] = true;
        notifyAll();
    }
    // Grąžina a ir b skirtumą
    public synchronized int paiimtiAirBSkirtuma() {
        notifyAll();
        return abs(a - b);
    }
    public synchronized boolean arBentVienasPerskaite() {
        for (int i = 0; i < arNuskaiteVisi.length; i++) {
            if(arNuskaiteVisi[i]) {
                notifyAll();
                return true;
            }
        }
        notifyAll();
        return false;
    }
    public synchronized boolean arVisiPerskaite() {
        for (int i = 0; i < arNuskaiteVisi.length; i++) {
            if(!arNuskaiteVisi[i]) {
                notifyAll();
                return false;
            }
        }
        notifyAll();
        return true;
    }
}
// Proceso klasė, kuri keičia a ir b reikšmes
class Keitejas extends Thread {
    @Override
    public void run() {
        while(BaltulionisS_L2g.BendrasMasyvas.paiimtiAirBSkirtuma() > 20) {
            BaltulionisS_L2g.BendrasMasyvas.keistiReiksmes();
        }
    }
}

// Proceso klasė, kuri skaito ir spausdina a ir b reikšmes
class Skaitytojas extends Thread {
    private int procesoNr;
    public Skaitytojas(int procesoNr) {
        this.procesoNr = procesoNr;
    }
    @Override
    public void run() {
        while(BaltulionisS_L2g.BendrasMasyvas.paiimtiAirBSkirtuma() > 20) {
            BaltulionisS_L2g.BendrasMasyvas.skaitytiReiksmes(procesoNr);
        }
    }
}
public class BaltulionisS_L2g {
    // Monitoriaus kintamasis
    public static BendrasMasyvas BendrasMasyvas = new BendrasMasyvas();
    public static final int KeitejuProcesuKiekis = 2;
    public static final int SkaitytojuProcesuKiekis = 3;
    public static void main(String[] args) throws InterruptedException {
        ExecutorService es = Executors.newCachedThreadPool();
        for (int i = 0; i < KeitejuProcesuKiekis; i++) {
            es.execute(new Keitejas());
        }
        for (int i = KeitejuProcesuKiekis + 1; i < SkaitytojuProcesuKiekis + KeitejuProcesuKiekis + 1; i++) {
            es.execute(new Skaitytojas(i));
        }
        es.shutdown();
        es.awaitTermination(1, TimeUnit.MINUTES);
    }   
}
