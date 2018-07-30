package kazlauskasm_l2a;

import java.io.*;
import java.util.*;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

// Klasė, sauganti reikiamų rikiavimo laukų ir jų kiekių objektus
class RikiavimoStruktura {
    private int rikiavimoLaukas;
    private int kiekis;

    // Klasės konstruktoriai
    public RikiavimoStruktura() {

    }

    public RikiavimoStruktura(int rikiavimoLaukas, int kiekis) {
        this.rikiavimoLaukas = rikiavimoLaukas;
        this.kiekis = kiekis;
    }
    
    // Duomenų ėmimo bei talpinimo metodai
    public int imtiRikiavimoLauka() {
        return rikiavimoLaukas;
    }
    
    public int imtiKieki() {
        return kiekis;
    }
    
    public void detiRikiavimoLauka(int rikiavimoLaukas) {
        this.rikiavimoLaukas = rikiavimoLaukas;
    }

    public void detiKieki(int kiekis) {
        this.kiekis = kiekis;
    }
}

// Klasė, skirta gamintojų gaminamų produktų objektams saugoti
// automobilio pavadinimas, jo metai bei variklio tūris litrais
class Automobilis {
    private String pavadinimas;
    private int metai;
    private double litrai;

    // Klasės konstruktoriai
    public Automobilis(String pavadinimas, int metai, double litrai) {
        this.pavadinimas = pavadinimas;
        this.metai = metai;
        this.litrai = litrai;
    }

    public Automobilis() {

    }
    
    // Duomenų ėmimo bei dėjimo metodai
    public String imtiPavadinima() {
        return pavadinimas;
    }
    
    public int imtiMetus() {
        return metai;
    }
    
    public double imtiLitrus() {
        return litrai;
    }

    public void detiPavadinima(String pavadinimas) {
        this.pavadinimas = pavadinimas;
    }

    public void detiMetus(int metai) {
        this.metai = metai;
    }

    public void detiLitrus(double litrai) {
        this.litrai = litrai;
    }
}

// Monitorius, skirtas veiksmų sinchronizacijai
class Monitorius {
    // Saugomi tie gamintojai, kurie vis dar kažką gamina ir talpina objektus
    // į bendrą masyvą
    private boolean[] gamina;
    // Šiuo metu bendrame masyve esančių duomenų kiekis
    private int kiekis;
    // Bendras masyvas monitorius, į kurį gamintoaji talpina duomenis, o skaitytojai iš 
    // jo ima
    private RikiavimoStruktura[] B;

//    Monitoriaus konstruktorius
//    @param n - n procesų skaičius
//    @param m - m proecsų skaičius
    public Monitorius(int n, int m) {
        B = new RikiavimoStruktura[100];
        gamina = new boolean[n];
        for (boolean g : gamina) g = true;
        kiekis = 0;
    }
    
    // Grąžina bendrą masyvą monitorius
    public RikiavimoStruktura[] imtiB() {
        return B;
    }
    
    // Grąžina šiuo metu bendrame masyve esančių objektų kiekį
    public int imtiKieki() {
        return kiekis;
    }
    
//    Funkcija, reikalinga objekto įterpimo vietai rasti bendrame masyve ir ją
//    grąžina
//    @param elem - elementas, kuriam ieškoma vieta įterpimui
    private int iterpimoVieta(int elem) {
        // Jei masyvas vis dar tuščias, elementas įterpiamas į pirmą vietą (indeksas 0)
        if (kiekis == 0) {
            return 0;
        }
        for (int i = 0; i < kiekis; i++) {
            if (elem <= B[i].imtiRikiavimoLauka()) {
                // Jei rado vietą, ją ir grąžina
                return i;
            }
        }
        /* Jei vieta nebuvo rasta, reiškia, elementas buvo didesnis už visus
           buvusius, todėl jį reikės įterpti į galą*/
        return kiekis;
    }

//    Sinchronizuotas metodas, reikalingas elementui įterpti į bendrą masyvą
//    Duomenys talpinami, kai bendrame masyve yra vietos arba jau toks elementas
//    yra ir padidinamas tik jo kiekis - kitu atveju metodas laukia, kad bus
//    galima patalpinti objektą Automobilis
    public synchronized void iterpti(Automobilis a) {
        // Pasiimama per funkciją grąžinta įterpimo vieta
        int laukas = a.imtiMetus();
        int vieta = iterpimoVieta(laukas);
        
        if(vieta == 0 && kiekis == 0 || vieta == kiekis){
            B[vieta] = new RikiavimoStruktura(laukas, 1);
            kiekis++;
        }
        else if(B[vieta].imtiRikiavimoLauka() == laukas){
            B[vieta] = new RikiavimoStruktura(laukas, B[vieta].imtiKieki()+1);
        }
        else{
            for (int i = kiekis; i > vieta; i--) {
                B[i] = B[i - 1];
            }
            B[vieta] = new RikiavimoStruktura(laukas, 1);
            kiekis++;
        }
        notifyAll();
    }

//    Sinchronizuotas metodas, reikalingas vartotojams, kurie nori iš bendro
//    masyvo imti (šalinti) elementus.
    public synchronized boolean salinti(RikiavimoStruktura elem) {
//        Laukiama, jei masyvas yra tuščias (nėra ko pasiimti), bet dar yra 
//        gamintojų (tikimasi, kad dar bus talpinama į bendrą masyvą)
        while(kiekis == 0 && this.yraGamintojas()) {
            try {
                wait();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        if(kiekis == 0 && !this.yraGamintojas()){
            notifyAll();
            return false;
        }
        boolean pasalinta = false;
        // Einama pro visą bendrą masyvą ir ieškoma reikiamos prekės (objekto)
        for (int i = 0; i < kiekis; i++) {
            // Vartotojas randa norimą prekę (rastas tinkamas laukas)
            if (B[i].imtiRikiavimoLauka() == elem.imtiRikiavimoLauka()) {
                int salinamasKiekis = B[i].imtiKieki();
                if (elem.imtiKieki() < B[i].imtiKieki()){
                    B[i].detiKieki(salinamasKiekis - elem.imtiKieki());
                }
                else{
                    if (i == 0 && kiekis == 1 || i == kiekis - 1){
                        B[i] = null;
                        kiekis--;
                    }
                    else{
                        for (int j = i; j < kiekis - 1; j++)
                            B[j] = B[j + 1];
                        B[kiekis-1] = null;
			kiekis--;
                    }
                }
                pasalinta = true;
            }
        }
//      Pranešama kitoms laukiančioms gijoms, kad išeinama iš kritinės sekcijos
        notifyAll();
        return pasalinta;
    }

    // Sinchronizuotas metodas, kuriame gamintojas nustato reikšmę gamintojų 
//    masyve, ar vis dar gamins prekes (talpins į bendrą masyvą)
    public synchronized void nustatytiKadNebegamina(int gamintojas) {
        gamina[gamintojas] = false;
        notifyAll();
    }
    
//  Tikrinama, ar dar yra gaminančių gamintojų (sinchronizuotas)
    public synchronized boolean yraGamintojas() {
        for (boolean g : gamina)
            if (g){
                notifyAll();
                return true;
            }
        notifyAll();
        return false;
    }
}

// Klasė, skirta gamintojų duomenims saugoti
class Gamintojas extends Thread {
    private Automobilis[] d;
    private int gamintojas;

//    Klasės konstruktorius
    public Gamintojas(int gamintojas, Automobilis[] duomenys) {
        this.d = duomenys;
        this.gamintojas = gamintojas;
    }

    // Gijos paleidimo metodas, kuriame gamina į bendrą masyvą lygiagrečiai
//    talpina prekes (objektus)
    @Override
    public void run() {
        for (Automobilis duom : d) {
            KazlauskasM_L2a.monitorius.iterpti(duom);
        }
        // Nustatoma, kad gamintojas daugiau nebetalpins duomenų
        KazlauskasM_L2a.monitorius.nustatytiKadNebegamina(gamintojas);
    }
}

// Klasė, skirta vartotojų duomenims saugoti
class Vartotojas extends Thread {
    private RikiavimoStruktura[] d;
    private int vartotojas;

    // Klasės konstruktorius
    public Vartotojas(int vartotojas, RikiavimoStruktura[] duomenys) {
        this.vartotojas = vartotojas;
        this.d = duomenys;
    }

//    Gijos paleidimo metodas, kuriame vartotojai iš bendro masyvo lygiagrečiai
//    ima prekes (objektus)
    @Override
    public void run() {
        boolean pabaiga = false;
        while(!pabaiga){
            boolean rado = false;
            for (RikiavimoStruktura d1 : d) {
                boolean istryne = KazlauskasM_L2a.monitorius.salinti(d1);
                if(istryne)
                    rado = true;
            }
            if (!rado && !KazlauskasM_L2a.monitorius.yraGamintojas()){
		for (RikiavimoStruktura d1 : d)
                    rado = KazlauskasM_L2a.monitorius.salinti(d1);
		pabaiga = true;
            }
        }
    }
}

// Pagrindinė klasė, sauganti N bei M procesų duomenis, failų vardus, skaitymo/
// rezultatų rašymo funkcijas
public class KazlauskasM_L2a {
    public static final String DUOMENU_FAILAS = "KazlauskasM_L2_dat_1.txt";
//    public static final String DUOMENU_FAILAS = "KazlauskasM_L2_dat_2.txt";
//    public static final String DUOMENU_FAILAS = "KazlauskasM_L2_dat_3.txt";
    public static final String F_REZ = "KazlauskasM_L2a_rez.txt";
    // N procesų skaičius
    public static final int N = 5;
    // M procesų skaičius
    public static final int M = 4;
    public static final int N_PROCESU_DUOMENU_KIEKIS = 31;
    public static List<Automobilis[]> Procesai_N_Duomenys = new ArrayList<>();
    public static List<RikiavimoStruktura[]> Procesai_M_Duomenys = new ArrayList<>();
    // Monitorius
    public static Monitorius monitorius = new Monitorius(N, M);
    // Reikalinga rezultatų rašymui
    public static PrintWriter writer;

    // Duomenų skaitymo funckija
    // @param df - duomenų failo vardas
    private static void duomenuSkaitymas(String df){
        try (Scanner scanner = new Scanner(new File(df))) {
            scanner.nextLine();
            for (int i = 0; i < N; i++) {
                int kiekis = scanner.nextInt();
                Automobilis[] rinkinys = new Automobilis[kiekis];
                for (int j = 0; j < kiekis; j++) {
                    String pavadinimas = scanner.next();
                    int metai = scanner.nextInt();
                    double litrai = scanner.nextDouble();
                    rinkinys[j] = new Automobilis(pavadinimas, metai, litrai);
                }
                Procesai_N_Duomenys.add(rinkinys);
            }
            scanner.nextLine();
            scanner.nextLine();
            for (int i = 0; i < M; i++) {
                int kiekis = scanner.nextInt();
                RikiavimoStruktura[] rinkinys = new RikiavimoStruktura[kiekis];
                for (int j = 0; j < kiekis; j++) {
                    int rikiavimoLaukas = scanner.nextInt();
                    int kiek = scanner.nextInt();
                    rinkinys[j] = new RikiavimoStruktura(rikiavimoLaukas, kiek);
                }
                Procesai_M_Duomenys.add(rinkinys);
            }
        } catch (Exception ex) {
            System.out.println(ex);
        }
    }
    
    // Duomenų spausdinimo rezultatų faile funkcija
    private static void duomenuSpausdinimas(){
        int lineNr = 1;
        writer.println("     |Automobilių duomenų rinkiniai|");
        writer.println("     |-----------------------------------");
        for (int i = 0; i < N; i++){
            writer.println(String.format("     |%-12s|%-8s|%-7s|", "Pavadinimas", "Metai", "Litrai"));
            writer.println("     |-----------------------------------");
            for (Automobilis get : Procesai_N_Duomenys.get(i)) {
                writer.println(String.format("%3d) |%-12s|%-8s|%-7s|", lineNr++, get.imtiPavadinima(), get.imtiMetus(), get.imtiLitrus()));
            }
            lineNr = 1;
            writer.println("     |-----------------------------------");
        }
        writer.println("     | Rikiavimo struktūros|");
        writer.println("     |-----------------------------------");
        for (int i = 0; i < M; i++){
            writer.println(String.format("     |%-12s|%-8s|", "Rik. Laukas", "Kiekis"));
            writer.println("     |-----------------------------------");
            for (RikiavimoStruktura get : Procesai_M_Duomenys.get(i)) {
                writer.println(String.format("%3d) |%-12s|%-8s|", lineNr++, get.imtiRikiavimoLauka(), get.imtiKieki()));
            }
            lineNr = 1;
            writer.println("     |-----------------------------------");
        }
    }

    // Rezultatų (galutinio bendro masyvo) spausdinimo funkcija
    public static void rezultatuSpausdinimas(){
        int lineNr = 1;
        writer.println("*******************************************");
        writer.println("                REZULTATAI      ");
        writer.println("*******************************************");
        writer.println("     |Masyvas B            |");
        writer.println("     |-----------------------------------");
        writer.println(String.format("     |%-12s|%-8s|", "Rik. Laukas", "Kiekis"));
        writer.println("     |-----------------------------------");
        for (int i = 0; i < monitorius.imtiKieki(); i++) {
            int rikiuojamasLaukas = monitorius.imtiB()[i].imtiRikiavimoLauka();
            int kiekis = monitorius.imtiB()[i].imtiKieki();
            writer.println(String.format("%3d) |%-12s|%-8s|", lineNr++, rikiuojamasLaukas, kiekis));
        }
    }
    
    // Procesų (n ir m) paleidimo funkcija
    private static void paleistiProcesus() {
        ExecutorService es = Executors.newCachedThreadPool();

        for (int i = 0; i < N; i++) {
            es.execute(new Gamintojas(i, Procesai_N_Duomenys.get(i)));
        }

        for (int i = 0; i < M; i++) {
            es.execute(new Vartotojas(i, Procesai_M_Duomenys.get(i)));
        }

        es.shutdown();
        try {
            es.awaitTermination(1, TimeUnit.MINUTES);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
    
    // Pagrindinis programos metodas - main funkcija
    public static void main(String[] args) {
        try{
            writer = new PrintWriter(F_REZ);
        } catch(IOException e){
            System.out.println(e);
            return;
        }
        duomenuSkaitymas(DUOMENU_FAILAS);
        System.out.println("Domenys nuskaityti.");
        duomenuSpausdinimas();
        System.out.println("Duomenys surašyti į failą.");
        paleistiProcesus();
        rezultatuSpausdinimas();
        System.out.println("Rezultatai surašyti į failą.");
        writer.close();
        System.out.println("Pabaiga.");
    }
}