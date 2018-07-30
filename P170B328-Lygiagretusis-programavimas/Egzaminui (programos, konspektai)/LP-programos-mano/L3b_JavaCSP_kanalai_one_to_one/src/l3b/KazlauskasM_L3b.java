/* Failas: KazlauskasM_L3b.java
   Laboratorinis darbas: L3b
   Mangirdas Kazlauskas IFF-4/1
*/
package L3b;

import org.jcsp.lang.*;
import java.io.*;
import java.util.*;
import org.jcsp.util.InfiniteBuffer;
import org.jcsp.util.ints.InfiniteBufferInt;

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
    // Gamintojams skirtos informacijos siuntimo kanalų masyvas
    private final One2OneChannel[] gamintojai_out;
    // Vartotojams skirtos informacijos siuntimo kanalų masyvas
    private final One2OneChannel[] vartotojai_out;
    // Rezultatų gavimo iš valdytojo kanalas
    private final AltingChannelInput rezultatai_in;
    
    // Gamintojų duomenys
    public static List<Automobilis[]> Procesai_N_Duomenys = new ArrayList<>();
    // Vartotojų duomenys
    public static List<RikiavimoStruktura[]> Procesai_M_Duomenys = new ArrayList<>();
    
    public static PrintWriter writer;
    
    // Konstruktorius
    public Procesas_00(One2OneChannel[] gamintojai_out, One2OneChannel[] vartotojai_out, AltingChannelInput rezultatai_in){
        this.gamintojai_out = gamintojai_out;
        this.vartotojai_out = vartotojai_out;
        this.rezultatai_in = rezultatai_in;
    }
    
    // Duomenų skaitymo funkcija
    // @param df - duomenų failo vardas
    private static void duomenuSkaitymas(String df){
        try (Scanner scanner = new Scanner(new File(df))) {
            scanner.nextLine();
            for (int i = 0; i < KazlauskasM_L3b.N; i++) {
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
            for (int i = 0; i < KazlauskasM_L3b.M; i++) {
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
            writer = new PrintWriter(KazlauskasM_L3b.F_REZ);
        } catch(IOException e){
            System.out.println(e);
        }
        int lineNr = 1;
        writer.println("     |Automobilių duomenų rinkiniai|");
        writer.println("     -------------------------------");
        for (int i = 0; i < KazlauskasM_L3b.N; i++){
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
        for (int i = 0; i < KazlauskasM_L3b.M; i++){
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
        // Gamintojų duomenų siuntimas atskirais kanalais
        for(int i = 0; i < Procesai_N_Duomenys.size(); i++)
            gamintojai_out[i].out().write(Procesai_N_Duomenys.get(i));
        // Vartotojų duomenų siuntimas atskirais kanalais
        for(int i = 0; i < Procesai_M_Duomenys.size(); i++)
            vartotojai_out[i].out().write(Procesai_M_Duomenys.get(i));
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
            duomenuSkaitymas(KazlauskasM_L3b.DUOMENU_FAILAS);
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
        d = (Automobilis[]) duomenys;
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
    private final AltingChannelInputInt stabdyti_vartojima_in;
    
    // Konstruktorius
    public Vartotojas(int id, AltingChannelInput kanalas_in,
                        ChannelOutput kanalas_out,
                        AltingChannelInputInt stabdyti_vartojima_in){
        this.id = id;
        d = new RikiavimoStruktura[10];
        this.kanalas_in = kanalas_in;
        this.kanalas_out = kanalas_out;
        this.stabdyti_vartojima_in = stabdyti_vartojima_in;
    }
    
    // Funkcija, skirta skaityti duomenis iš proceso_00
    private void skaitytiIsProceso_00(){
        Object duomenys = null;
        while(duomenys == null){
            duomenys = kanalas_in.read();
        }
        d = (RikiavimoStruktura[]) duomenys;
    }
    
    // Funkcija, skirta siųsti duomenis (ką reikia šalinti iš bendro masyvo) valdytojo procesui
    private void siusti(){
        while(true){
            for(RikiavimoStruktura rs : d){
                kanalas_out.write(rs);
            }
            if(stabdyti_vartojima_in.pending()){
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
    
    // Kanalų masyvas, skirtas gauti informacijai iš gamintojų procesų
    private final One2OneChannel[] kanalas_gamintojai_in;
    // Kanalų masyvas, skirtas gauti informacijai iš vartotojų procesų
    private final One2OneChannel[] kanalas_vartotojai_in;
    // Kanalas, skirtas rezultatų siuntimui
    private final ChannelOutput rezultatai_out;
    // Kanalų masyvas, skirtas siųsti informacijai vartotojams, kad šie baigtų darbą
    private final One2OneChannelInt[] stabdyti_vartotojus_out;
    // Kanalų masyvas, skirtas gauti informacijai, ar atitinkamas gamintojas vis dar gamina
    private final One2OneChannelInt[] gamintojuBusenos_in;
    
    // Kintamasis, saugantis skaičių, kiek kartu iš eilės vartotojas nieko nepašalino
    private int neistryne_kartu_is_eiles_sk;

    // Konstruktorius
    public Valdytojas(One2OneChannel[] kanalas_gamintojai_in,
                        One2OneChannel[] kanalas_vartotojai_in,
                        ChannelOutput rezultatai_out,
                        One2OneChannelInt[] gamintojuBusenos_in,
                        One2OneChannelInt[] stabdyti_vartotojus_out) {
        this.kanalas_gamintojai_in = kanalas_gamintojai_in;
        this.kanalas_vartotojai_in = kanalas_vartotojai_in;
        this.rezultatai_out = rezultatai_out;
        this.gamintojuBusenos_in = gamintojuBusenos_in;
        this.stabdyti_vartotojus_out = stabdyti_vartotojus_out;
        B = new RikiavimoStruktura[100];
        gamina = new boolean[KazlauskasM_L3b.N];
        for (int i = 0; i < KazlauskasM_L3b.N; i++) {
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
        return neistryne_kartu_is_eiles_sk >= KazlauskasM_L3b.N * KazlauskasM_L3b.M * faktorialas(KazlauskasM_L3b.M);
    }
    
    // Valdytojo valdymo procesas
    private void valdyti(){
        // Alternatyvos ir apsaugos sukūrimas
        Guard[] apsauga = new Guard[KazlauskasM_L3b.N + KazlauskasM_L3b.M];
        int id = 0;
        for (int i = 0; i < KazlauskasM_L3b.N; i++){
            apsauga[id++] = kanalas_gamintojai_in[i].in();
        }
        for (int i = 0; i < KazlauskasM_L3b.M; i++){
            apsauga[id++] = kanalas_vartotojai_in[i].in();
        }
        Alternative alternatyvos = new Alternative(apsauga);
        //-----------------------------------------------------------------
        boolean pabaiga = false;
        while(!pabaiga){
            int alternatyva_id = alternatyvos.fairSelect();
            int procesas_id = alternatyva_id % KazlauskasM_L3b.N;
            if (alternatyva_id < KazlauskasM_L3b.N){
                if(kanalas_gamintojai_in[procesas_id].in().pending()){
                    Object duomenys = kanalas_gamintojai_in[procesas_id].in().read();
                    Automobilis a = (Automobilis) duomenys;
                    iterpti(a.imtiMetus());
                }
            }
            else{
                if(kanalas_vartotojai_in[procesas_id].in().pending()){
                    Object duomenys = kanalas_vartotojai_in[procesas_id].in().read();
                    RikiavimoStruktura rs = (RikiavimoStruktura) duomenys;
                    neistryne_kartu_is_eiles_sk = salinti(rs) ? 0 : neistryne_kartu_is_eiles_sk + 1;
                }
            }
            for (int i = 0; i < KazlauskasM_L3b.N; i++){
                if(gamintojuBusenos_in[i].in().pending()){
                    nustatytiKadNebegamina(i); 
                }
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
    private void baigtiDarba(){
        for (int i = 0; i < KazlauskasM_L3b.M; i++){
            stabdyti_vartotojus_out[i].out().write(i);
        }
        rezultatai_out.write(B); 
    }
    
    // Proceso metodo run užklojimas
    @Override
    public void run() {     
        valdyti();
        baigtiDarba();
    }
}

public class KazlauskasM_L3b {
//    public static final String DUOMENU_FAILAS = "KazlauskasM_L2_1.txt";
    public static final String DUOMENU_FAILAS = "KazlauskasM_L2_2.txt";
//    public static final String DUOMENU_FAILAS = "KazlauskasM_L2_3.txt";
    public static final String F_REZ = "KazlauskasM_L3b_rez.txt";
        // N procesų skaičius
    public static final int N = 5;
        // M procesų skaičius
    public static final int M = 4;
    
    // Pagrindinė programos funkcija
    public static void main(String[] args) {
        Parallel visiProcesai = new Parallel();
        // Sukuriami kanalai
        One2OneChannel[] kanalasGamintojai = Channel.one2oneArray(N);
        One2OneChannel[] kanalasGamintojuValdymui = Channel.one2oneArray(N);
        One2OneChannel[] kanalasVartotojai = Channel.one2oneArray(M);        
        One2OneChannel[] kanalasVartotojuValdymui = Channel.one2oneArray(M, new InfiniteBuffer());
        One2OneChannel kanalasRezultatai = Channel.one2one();
        One2OneChannelInt[] kanalasStabdytiVartotojus = Channel.one2oneIntArray(M, new InfiniteBufferInt());
        One2OneChannelInt[] kanalasGamintojuBusenos = Channel.one2oneIntArray(N, new InfiniteBufferInt());
        
        // Prie visų procesų pridedami gamintojų procesai su savo id
        for (int i = 0; i < KazlauskasM_L3b.N; i++) {
            visiProcesai.addProcess(new Gamintojas(i, kanalasGamintojai[i].in(), kanalasGamintojuValdymui[i].out(),
                    kanalasGamintojuBusenos[i].out()));
        }
        // Prie visų procesų pridedami vartotojų procesai su savo id
        for (int i = 0; i < KazlauskasM_L3b.M; i++) {
            visiProcesai.addProcess(new Vartotojas(i, kanalasVartotojai[i].in(), kanalasVartotojuValdymui[i].out(),
                    kanalasStabdytiVartotojus[i].in()));
        }  
        // Prie visų procesų pridedamas duomenų skaitymo/rašymo procesas - procesas_00
        visiProcesai.addProcess(new Procesas_00(kanalasGamintojai,
                kanalasVartotojai, kanalasRezultatai.in()));
        // Prie visų procesų pridedamas valdytojo procesas
        visiProcesai.addProcess(new Valdytojas(kanalasGamintojuValdymui, kanalasVartotojuValdymui,
                kanalasRezultatai.out(), kanalasGamintojuBusenos, kanalasStabdytiVartotojus));     
        visiProcesai.run();
    }
}
