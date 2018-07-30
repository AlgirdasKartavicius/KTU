/* Failas: KazlauskasM_L3a.java
   Laboratorinis darbas: L3a
   Mangirdas Kazlauskas IFF-4/1
*/
package L3a;

import org.jcsp.lang.*;
import java.io.*;
import java.util.*;
import org.jcsp.util.InfiniteBuffer;

// Klasė, sauganti reikiamų rikiavimo laukų ir jų kiekių objektus
class RikiavimoStruktura {
    private int rikiavimoLaukas;
    private int kiekis;

    // Klasės konstruktoriai
    public RikiavimoStruktura() {}

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

    public Automobilis() {}
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

// Duomenų skaitymo/rašymo bei rezultatų spausdinimo klasė
class Procesas_00 implements CSProcess{
    // Gamintojams skirtos informacijos siuntimo kanalas
    private final ChannelOutput gamintojai_out;
    // Vartotojams skirtos informacijos siuntimo kanalas
    private final ChannelOutput vartotojai_out;
    // Rezultatų gavimo iš valdytojo kanalas
    private final AltingChannelInput rezultatai_in;
    
    // Gamintojų duomenys
    public static List<Automobilis[]> Procesai_N_Duomenys = new ArrayList<>();
    // Vartotojų duomenys
    public static List<RikiavimoStruktura[]> Procesai_M_Duomenys = new ArrayList<>();
    
    public static PrintWriter writer;
    
    // Konstruktorius
    public Procesas_00(ChannelOutput gamintojai_out, ChannelOutput vartotojai_out, AltingChannelInput rezultatai_in){
        this.gamintojai_out = gamintojai_out;
        this.vartotojai_out = vartotojai_out;
        this.rezultatai_in = rezultatai_in;
    }
    
    // Duomenų skaitymo funkcija
    // @param df - duomenų failo vardas
    private static void duomenuSkaitymas(String df){
        try (Scanner scanner = new Scanner(new File(df))) {
            scanner.nextLine();
            for (int i = 0; i < KazlauskasM_L3a.N; i++) {
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
            for (int i = 0; i < KazlauskasM_L3a.M; i++) {
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
    
    // Duomenų spausdinimo į rezultatų failą funkcija
    private static void duomenuSpausdinimas(){
        try{
            writer = new PrintWriter(KazlauskasM_L3a.F_REZ);
        } catch(IOException e){
            System.out.println(e);
        }
        int lineNr = 1;
        writer.println("     |Automobilių duomenų rinkiniai|");
        writer.println("     -------------------------------");
        for (int i = 0; i < KazlauskasM_L3a.N; i++){
            writer.println(String.format("     |%-12s|%-8s|%-7s|", "Pavadinimas", "Metai", "Litrai"));
            writer.println("     -------------------------------");
            for (Automobilis get : Procesai_N_Duomenys.get(i)) {
                writer.println(String.format("%3d) |%-12s|%-8s|%-7s|", lineNr++, get.imtiPavadinima(), get.imtiMetus(), get.imtiLitrus()));
            }
            lineNr = 1;
            writer.println("     -------------------------------");
        }
        writer.println("     | Rikiavimo struktūros|");
        writer.println("     -----------------------");
        for (int i = 0; i < KazlauskasM_L3a.M; i++){
            writer.println(String.format("     |%-12s|%-8s|", "Rik. Laukas", "Kiekis"));
            writer.println("     -----------------------");
            for (RikiavimoStruktura get : Procesai_M_Duomenys.get(i)) {
                writer.println(String.format("%3d) |%-12s|%-8s|", lineNr++, get.imtiRikiavimoLauka(), get.imtiKieki()));
            }
            lineNr = 1;
            writer.println("     -----------------------");
        }
    }
    
    // Rezultatų (galutinio bendro masyvo) spausdinimo į rezultatų failą funkcija
    public void rezultatuSpausdinimas(){
        RikiavimoStruktura[] rezultatai = gautiRezultatus();
        
        int lineNr = 1;
        writer.println("*******************************************");
        writer.println("                REZULTATAI      ");
        writer.println("*******************************************");
        writer.println("     |Masyvas B            |");
        writer.println("     -----------------------");
        writer.println(String.format("     |%-12s|%-8s|", "Rik. Laukas", "Kiekis"));
        writer.println("     -----------------------");
        for (int i = 0; i < Valdytojas.imtiKieki(); i++) {
            int rikiuojamasLaukas = rezultatai[i].imtiRikiavimoLauka();
            int kiekis = rezultatai[i].imtiKieki();
            writer.println(String.format("%3d) |%-12s|%-8s|", lineNr++, rikiuojamasLaukas, kiekis));
        }
        writer.println("     -----------------------");
    }
    
    // Funkcija, siunčianti iš duomenų failo nuskaitytą informaciją gamintojų ir vartotojų kanalais
    private void siustiNuskaitytusDuomenis(){
        gamintojai_out.write(Procesai_N_Duomenys);
        vartotojai_out.write(Procesai_M_Duomenys);
    }
    
    // Rezultatų gavimo (bendro masyvo B) iš valdytojo kanalo funkcija
    // return rezultatai - grąžinamas rezultatas (bendras masyvas B)
    private RikiavimoStruktura[] gautiRezultatus(){
        RikiavimoStruktura[] rezultatai = null;
        while(rezultatai == null){
            if(rezultatai_in.pending()){
                rezultatai = (RikiavimoStruktura[]) rezultatai_in.read();
            }
        }
        return rezultatai;
    }
    
    // Proceso metodo run užklojimas
    @Override
        public void run() {
            duomenuSkaitymas(KazlauskasM_L3a.DUOMENU_FAILAS);
            duomenuSpausdinimas();
            siustiNuskaitytusDuomenis();
            rezultatuSpausdinimas();
            writer.close();
        }
}

// Gamintojo proceso klasė
class Gamintojas implements CSProcess{
    // Proceso id
    private final int id;
    // Gamintojo proceso duomenys
    private Automobilis[] d;
    
    // Kanalas, skirtas informacijai iš proceso_00 gauti
    private final AltingChannelInput kanalas_in;
    // Kanalas, skirtas valdytojui siųsti duomenis įterpimui į masyvą
    private final ChannelOutput kanalas_out;
    // Kanalas, skirtas valdytojui siųsti informaciją, ar atitinkamas 
    // gamintojas vis dar įterpinėja duomenis
    private final ChannelOutputInt gamina_out;
    
    // Konstruktorius
    public Gamintojas(int id, AltingChannelInput kanalas_in,
                        ChannelOutput kanalas_out,
                        ChannelOutputInt gamina_out){
        this.id = id;
        d = new Automobilis[10];
        this.kanalas_in = kanalas_in;
        this.kanalas_out = kanalas_out;
        this.gamina_out = gamina_out;
    }
    
    // Duomenų skaitymo iš proceso_00 funkcija
    private void skaitytiIsProceso_00(){
        Object duomenys = null;
        while (duomenys == null){
            duomenys = kanalas_in.read();
        }
        List<Automobilis[]> visiGamintojuDuomenys = (List<Automobilis[]>) duomenys;
        d = visiGamintojuDuomenys.get(id);
    }
    
    // Duomenų siuntimo valdytojui funkcija
    private void siusti(){
        for(Automobilis a : d){
            kanalas_out.write(a);
        }
        gamina_out.write(id);
    }
    
    // Proceso metodo run užklojimas
    @Override
        public void run() {
            skaitytiIsProceso_00();
            siusti();
        }   
    
}

// Vartotojo proceso klasė
class Vartotojas implements CSProcess{
    // Vartotojo proceso id
    private final int id;
    // Vartotojo proceso duomenys
    private RikiavimoStruktura[] d;
    
    // Kanalas, skirtas duomenims iš proceso_00 gauti
    private final AltingChannelInput kanalas_in;
    // Kanalas, skirtas vartotojų duomenims (iš bendro masyvo trinamų elementų)
    // perduoti valdytojui
    private final ChannelOutput kanalas_out;
    // Kanalas, skirtas gauti informaciją iš valdytojo, kad jau yra siunčiami rezultatai
    private final AltingChannelInput rezultatai_in;
    
    // Konstruktorius
    public Vartotojas(int id, AltingChannelInput kanalas_in,
                        ChannelOutput kanalas_out,
                        AltingChannelInput rezultatai_in){
        this.id = id;
        d = new RikiavimoStruktura[10];
        this.kanalas_in = kanalas_in;
        this.kanalas_out = kanalas_out;
        this.rezultatai_in = rezultatai_in;
    }
    
    // Funkcija, skirta skaityti duomenis iš proceso_00
    private void skaitytiIsProceso_00(){
        Object duomenys = null;
        while(duomenys == null){
            duomenys = kanalas_in.read();
        }
        List<RikiavimoStruktura[]> visiVartotojuDuomenys = (List<RikiavimoStruktura[]>) duomenys;
        d = visiVartotojuDuomenys.get(id);
    }
    
    // Funkcija, skirta siųsti duomenis (ką reikia šalinti iš bendro masyvo) valdytojo procesui
    private void siusti(){
        while(true){
            for(RikiavimoStruktura rs : d){
                kanalas_out.write(rs);
            }
            if(rezultatai_in.pending()){
                for(RikiavimoStruktura rs : d){
                    kanalas_out.write(rs);
                }
                break;
            }
        }
    }
    
    // Proceso paleidimo metodo užklojimas
    @Override
    public void run() {
        skaitytiIsProceso_00();
        siusti();
    }    
}

// Valdytojas, skirtas veiksmų sinchronizacijai
class Valdytojas implements CSProcess{
    // Saugomi tie gamintojai, kurie vis dar kažką gamina ir talpina objektus
    // į bendrą masyvą
    private final boolean gamina[];
    
    // Bendras masyvas B
    private final RikiavimoStruktura B[];
    // Bendrame masyve esančių elementų kiekis
    private static int kiekis;
    
    // Kanalas, skirtas gauti informacijai iš gamintojų procesų
    private final AltingChannelInput kanalas_gamintojai_in;
    // Kanalas, skirtas gauti informacijai iš vartotojų procesų
    private final AltingChannelInput kanalas_vartotojai_in;
    // Kanalas, skirtas rezultatų siuntimui
    private final ChannelOutput kanalas_out;
    // Kanalas, skirtas gauti informacijai, ar atitinkamas gamintojas vis dar gamina
    private final AltingChannelInputInt gamintojuBusenos_in;
    
    // Kintamasis, saugantis skaičių, kiek kartu iš eilės vartotojas nieko nepašalino
    private int neistryne_kartu_is_eiles_sk;

    // Konstruktorius
    public Valdytojas(AltingChannelInput kanalas_gamintojai_in,
                        AltingChannelInput kanalas_vartotojai_in,
                        SharedChannelOutput kanalas_out,
                        AltingChannelInputInt gamintojuBusenos_in) {
        this.kanalas_gamintojai_in = kanalas_gamintojai_in;
        this.kanalas_vartotojai_in = kanalas_vartotojai_in;
        this.kanalas_out = kanalas_out;
        this.gamintojuBusenos_in = gamintojuBusenos_in;
        B = new RikiavimoStruktura[100];
        gamina = new boolean[KazlauskasM_L3a.N];
        for (int i = 0; i < KazlauskasM_L3a.N; i++) {
            gamina[i] = true;
        }
        this.neistryne_kartu_is_eiles_sk = 0;
        this.kiekis = 0;
    }
    
    // Grąžina bendro masyvo elementų kiekį
    // return kiekis - bendrame masyve esančių elementų kiekis
    public static int imtiKieki(){ return kiekis; }
    
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

//    Metodas, reikalingas elementui įterpti į bendrą masyvą
    public void iterpti(int laukas) {
        // Pasiimama per funkciją grąžinta įterpimo vieta
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
                B[i] = B[i-1];
            }
            B[vieta] = new RikiavimoStruktura(laukas, 1);
            kiekis++;
        }
    }

//    Metodas, reikalingas vartotojams, kurie nori iš bendro
//    masyvo imti (šalinti) elementus.
    public boolean salinti(RikiavimoStruktura elem) {
        if(kiekis == 0 && !this.yraGamintojas()){
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
                            B[j] = B[j+1];
                        B[kiekis-1] = null;
                        kiekis--;
                    }
                }
                pasalinta = true;
            }
        }
//      grąžinama true, jei funkcijos vykdymo metu buvo kažkas pašalinta
        return pasalinta;
    }

    // Metodas, kuriame nustatoma reikšmė masyve
//    ar vis dar gamins prekes (talpins į bendrą masyvą)
    public void nustatytiKadNebegamina(int gamintojas) {
        gamina[gamintojas] = false;
    }
    
//  Tikrinama, ar dar yra gaminančių gamintojų (sinchronizuotas)
    public boolean yraGamintojas() {
        for (boolean g : gamina)
            if (g){
                return true;
            }
        return false;
    }
    
    // Faktorialo skaičiavimo funkcija
    private int faktorialas(int n){
        int result;
        if(n==1)
            return 1;
        result = faktorialas(n-1) * n;
        return result;
    }
    // Funkcija, grąžinanti true, jei vartotojai jau neberanda, ką šalinti
    // Nustatoma remiantis galimybėmis: jei turime N gamintojų, ir M vartotojų,
    // tai galimų porų skaičius: N * M. Tačiau vartotojų procesai gali nebūtinai
    // ateiti ta pačia tvarka, jie gali maišytis tarpusavyje, sudarydami papildomų
    // M! kombinacijų. Todėl bendras galimybių skaičius = N * M * M!
    public boolean vartotojaiNeberanda(){
        return neistryne_kartu_is_eiles_sk >= KazlauskasM_L3a.N * KazlauskasM_L3a.M * faktorialas(KazlauskasM_L3a.M);
    }
    
    // Valdytojo valdymo procesas
    private void valdyti(){
        Alternative alternatyvos = new Alternative(new Guard[] {kanalas_gamintojai_in, kanalas_vartotojai_in});
        boolean pabaiga = false;
        while(!pabaiga){
            switch(alternatyvos.fairSelect()){
                case(0):
                    if(kanalas_gamintojai_in.pending()){
                        Object duomenys = kanalas_gamintojai_in.read();
                        Automobilis a = (Automobilis) duomenys;
                        iterpti(a.imtiMetus());
                    }
                    break;
                case(1):
                    if(kanalas_vartotojai_in.pending()){
//                        System.out.println("Vartotojai vis dar kažką veikia...");
                        Object duomenys = kanalas_vartotojai_in.read();
                        RikiavimoStruktura rs = (RikiavimoStruktura) duomenys;
                        neistryne_kartu_is_eiles_sk = salinti(rs) ? 0 : neistryne_kartu_is_eiles_sk + 1;
                    }
                    break;
            }
            if(gamintojuBusenos_in.pending()){
                int gamintojo_id = gamintojuBusenos_in.read();
                nustatytiKadNebegamina(gamintojo_id); 
            }
            if(vartotojaiNeberanda() && !yraGamintojas()){
                pabaiga = true;
            }
        }
    }
    
    // Funkcija, siunčianti rezultatus dvejomis porcijomis:
    // 1 porcija skirta procesui_00, kad spausdintų rezultatus
    // 2 porcija skirta vartotojų procesams, kad jie matytų, jog rezultatai jau
    // gauti ir vartotojų procesai baigtų šalinimą
    private void siustiRezultatus(){
        for (int i = 0; i < 2; i++) {
            kanalas_out.write(B); 
        }
    }
    
    // Proceso metodo run užklojimas
    @Override
    public void run() {     
        valdyti();
        siustiRezultatus();
    }
}

public class KazlauskasM_L3a {
    public static final String DUOMENU_FAILAS = "KazlauskasM_L2_1.txt";
//    public static final String DUOMENU_FAILAS = "KazlauskasM_L2_2.txt";
//    public static final String DUOMENU_FAILAS = "KazlauskasM_L2_3.txt";
    public static final String F_REZ = "KazlauskasM_L3a_rez.txt";
        // N procesų skaičius
    public static final int N = 5;
        // M procesų skaičius
    public static final int M = 4;
    
    // Pagrindinė programos funkcija
    public static void main(String[] args) {
        Parallel visiProcesai = new Parallel();
        // Sukuriami kanalai
        Any2OneChannel kanalasGamintojai = Channel.any2one();
        Any2OneChannel kanalasGamintojuValdymui = Channel.any2one();
        Any2OneChannel kanalasVartotojai = Channel.any2one();        
        Any2OneChannel kanalasVartotojuValdymui = Channel.any2one(new InfiniteBuffer());
        Any2OneChannel kanalasRezultatai = Channel.any2one(new InfiniteBuffer());
        Any2OneChannelInt kanalasGamintojuBusenos = Channel.any2oneInt();
        
        // Prie visų procesų pridedami gamintojų procesai su savo id
        for (int i = 0; i < KazlauskasM_L3a.N; i++) {
            visiProcesai.addProcess(new Gamintojas(i, kanalasGamintojai.in(), kanalasGamintojuValdymui.out(),
                    kanalasGamintojuBusenos.out()));
        }
        // Prie visų procesų pridedami vartotojų procesai su savo id
        for (int i = 0; i < KazlauskasM_L3a.M; i++) {
            visiProcesai.addProcess(new Vartotojas(i, kanalasVartotojai.in(), kanalasVartotojuValdymui.out(),
                    kanalasRezultatai.in()));
        }  
        // Prie visų procesų pridedamas duomenų skaitymo/rašymo procesas - procesas_00
        visiProcesai.addProcess(new Procesas_00(kanalasGamintojai.out(),
                kanalasVartotojai.out(), kanalasRezultatai.in()));
        // Prie visų procesų pridedamas valdytojo
        visiProcesai.addProcess(new Valdytojas(kanalasGamintojuValdymui.in(), kanalasVartotojuValdymui.in(),
                kanalasRezultatai.out(),
                kanalasGamintojuBusenos.in()));     
        visiProcesai.run();
    }
}
