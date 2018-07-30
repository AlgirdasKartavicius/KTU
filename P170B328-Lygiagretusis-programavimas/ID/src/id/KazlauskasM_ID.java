/*
    Mangirdas Kazlauskas IFF-4/1
    Individualus darbas
    Programa: "Iš dainos žodžių neišmesi"
*/
package id;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.Scanner;
import java.util.regex.Pattern;
import org.jcsp.lang.*;
import org.jcsp.util.InfiniteBuffer;
import org.jcsp.util.ints.InfiniteBufferInt;

//Konstantų klasė, naudojama pradinėms duomenų reikšmės (demonstracijai)
class Konstantos{ 
    // Dainos Bohemian Rhapsody pavadinimas
    public static final String DAINA_BOHEMIAN_RHAPSODY = "Bohemian Rhapsody";
    // Dainos test pavadinimas
    public static final String DAINA_TEST = "test";
    // Gijų (prodiuserių) skaičius
    public static final int PRODIUSERIU_SK = 256;
}

// Klasė, skirta saugoti vienos dainos žodžio struktūrai
class DainosZodis{ 
    // Žodžio reikšmė (pats žodis)
    private final String zodis;
    // Žodžio būsena: true - jei jau sukurtas, false - priešingu atveju
    private boolean sukurtas;
    
    // Konstruktorius su parametrais
    // @param zodis - dainos zodis
    // @param sukurtas - loginė reikšmė, ar žodis sukurtas
    public DainosZodis(String zodis, boolean sukurtas){
        this.zodis = zodis;
        this.sukurtas = sukurtas;
    }
    
    // Grąžina loginę reikšmę: true - jei dainos žodis sukurtas, false - priešingu atveju
    // return this.sukurtas
    public boolean sukurtas(){
        return this.sukurtas;
    }
    
    // Keičia žodžio būseną į sukurtą (sukurtas = true)
    public void keistiSukurtas(){
        this.sukurtas = true;
    }
    
    // Grąžinama žodžio reikšmė
    // return this.zodis
    public String imtiZodi(){
        return this.zodis;
    }
}

// CSProcess sąsajos proceso klasė, aprašanti prodiuserį
class Prodiuseris implements CSProcess{
    // Prodiuserio identifikacinis numeris
    private final int id;
    // Prodiuserio sukurtų žodžių sąrašas
    private final List<String> sukurtiZodziai;
    // Kanalas, skirtas perduoti žodžius vadybininko procesui
    private final ChannelOutput kanalas_zodziai_out;
    // Kanalas, skirtas perduoti prodiuserio būseną vadybininko procesui
    private final ChannelOutputInt kanalas_kuria_out;
    // Kanalas, skirtas gauti žinutei iš vadybininko proceso, ar reikia 
    // baigti darbą
    private final AltingChannelInputInt kanalas_stabdyti_in;
    
    // Konstruktorius su parametrais
    // @param id - prodiuserio identifikacinis numeris
    // @param sukurtiZodziai - prodiuserio sukurtų žodžių sąrašas
    // @param kanalas_zodziai_out - kanalas, skirtas perduoti žodžius vadybininko procesui
    // @param kanalas_kuria_out - kanalas, skirtas perduoti prodiuserio būseną vadybininko procesui
    // @param kanalas_stabdyti_in - kanalas, skirtas gauti žinutei iš vadybininko proceso, ar reikia 
    //                              baigti darbą
    public Prodiuseris(int id,
                        List<String> sukurtiZodziai,
                        ChannelOutput kanalas_zodziai_out,
                        ChannelOutputInt kanalas_kuria_out,
                        AltingChannelInputInt kanalas_stabdyti_in){
        this.id = id;
        this.sukurtiZodziai = sukurtiZodziai;
        this.kanalas_zodziai_out = kanalas_zodziai_out;
        this.kanalas_kuria_out = kanalas_kuria_out;
        this.kanalas_stabdyti_in = kanalas_stabdyti_in;
    }
    
    // Metodas, skirtas siųsti prodiuserio proceso pagamintus žodžius vadybininkui
    private void siusti(){
        // Einama per visus prodiuserio sukurtus žodžius
        for (String zodis : sukurtiZodziai){
            // Tikrinama, ar negauta žinutė iš vadybininko, kad reikia nutraukti
            // gamybos procesą
            if (kanalas_stabdyti_in.pending()){
                // Jei žinutė gauta - darbas nutraukiamas
                if (kanalas_stabdyti_in.read() == -1){
                    break;
                }
            }
            // Kanalu išsiunčiamas prodiuserio sukurtas žodis vadybininkui
            kanalas_zodziai_out.write(zodis);
        }
        // Pabaigus siųsti visus prodiuserio sukurtus žodžius, vadybininkui
        // išsiunčiama žinutė, kad prodiuserio procesas baigė darbą
        kanalas_kuria_out.write(id);
    }
    
    // Užklotas CSProcess sąsajos metodas run()
    @Override
    public void run(){
        siusti();
    }
}

// CSProcess sąsajos proceso klasė, aprašantį vadybininką
class Vadybininkas implements CSProcess{
    // Sąrašas, saugantis visų dainos žodžių struktūras
    public List<DainosZodis> dainosZodziai = new ArrayList<>();
    // Masyvas, saugantis pagal indeksą atitinkamų prodiuserių būsenas
    // jei kuria[id] = true - indekso id prodiuseris vis dar kuria žodžius
    private final boolean kuria[];
    // Kanalas, skirtas gauti žodžius iš prodiuserių procesų
    private final AltingChannelInput kanalas_zodziai_in;
    // Kanalas, skirtas gauti prodiuserių procesų būsenas iš prodiuserių
    private final AltingChannelInputInt kanalas_produseriai_kuria_in;
    // Kanalų masyvas, skirtas išsiųsti žinutę prodiuseriams, kad jie baigtų darbą
    // (nustotų kurti ir siųsti vadybininkui kuriamus žodžius)
    private final One2OneChannelInt[] kanalas_stabdyti_out;
    
    // Konstruktorius su parametrais
    // @param dainosZodziai - dainos žodžių struktūrų sąrašas
    // @param kanalas_zodziai_in - kanalas, skirtas gauti žodžius iš prodiuserių procesų
    // @param kanalas_prodiuseriai_kuria_in - kanalas, skirtas gauti prodiuserių procesų būsenas iš prodiuserių
    // @param kanalas_stabdyti_out - kanalų masyvas, skirta stabdyti prodiuserių procesus
    // @param giju_sk - prodiuserių procesų (gijų) skaičius
    public Vadybininkas(List<DainosZodis> dainosZodziai,
                        AltingChannelInput kanalas_zodziai_in,
                        AltingChannelInputInt kanalas_prodiuseriai_kuria_in,
                        One2OneChannelInt[] kanalas_stabdyti_out,
                        int giju_sk){
        this.dainosZodziai = dainosZodziai;
        kuria = new boolean[giju_sk];
        // Visos prodiuserių būsenos nustatomos į kuriančius (kuria[id] = true) 
        for (int i = 0; i < giju_sk; i++){
            kuria[i] = true;
        }
        this.kanalas_zodziai_in = kanalas_zodziai_in;
        this.kanalas_produseriai_kuria_in = kanalas_prodiuseriai_kuria_in;
        this.kanalas_stabdyti_out = kanalas_stabdyti_out;
    }
    
    // Funkcija, grąžinanti true, jei daina jau yra sukurta
    // return true - jei sukurta, return false - jei daina vis dar turi nesukurtų žodžių
    private boolean dainaSukurta(){
        // Ciklas eina per visas sąrašo dainosZodziai žodžių struktūras
        for (DainosZodis dz : dainosZodziai){
            if (!dz.sukurtas()){
                // Jei bent vienas dainos žodis nesukurtas, grąžinama false
                return false;
            }
        }
        // Grąžinama true, jei nerastas nė vienas nesukurtas dainos žodis
        return true;
    }
    
    // Funkcija, grąžinanti true, jei vis dar yra dainos žodžius kuriančių 
    // (dainos žodžius siunčiančių) prodiuserio procesų
    // return true - jei randamas bent vienas žodžius kuriantis prodiuseris
    // return false - jei nėra nė vieno kuriančio prodiuserio
    private boolean yraProdiuseris(){
        // Ciklas eina per prodiuserių būsenų masyvą
        for (boolean k : kuria){
            // Jei randama bent viena būsena - true, reiškia, kad yra bent
            // vienas dainos žodžius siunčiantis prodiuserio procesas
            if(k){
                return true;
            } 
        }
        // Grąžinama false, jei visos prodiuserių procesų būsenos - false
        return false;
    }
    
    // Funkcija, nustatanti parametru nurodyto id prodiuserio proceso būseną
    // @param id - prodiuserio proceso identifikacinis numeris
    private void nustatytiKadProdiuserisNebekuria(int id){
        kuria[id] = false;
    }
    
    // Funkcija, sąraše dainosZodziai ieškanti parametru nurodyto dainos žodžio
    // @param zodis - dainoje ieškomas prodiuserio proceso atsiųstas dainos žodis
    private void ieskotiDainoje(String zodis){
        // Ciklas eina per sąrašą dainosZodziai
        for (DainosZodis dz : dainosZodziai){
            // Tikrinama, ar žodžiai sutampa ir ar atitinkamas dainos teksto 
            // žodis dar nėra sukurtas
            if (Objects.equals(dz.imtiZodi(), zodis) && !dz.sukurtas()){
                // Jei tinkamas žodis randamas dainos tekste, jo būsena pakeičiama
                // į sukurtą
                dz.keistiSukurtas();
                return;
            }
        }
    }
    
    // Funkcija, vykdanti dainos kūrimo veiksmus, t.y., tikrina, ar prodiuserių
    // procesai siunčia žodžius, ar prodiuserių procesai kanalu siunčia žinutę,
    // jog jau baigė darbą bei kanalu siunčia žinutes prodiuserių procesams, jog
    // daina jau sukurta ir reikia nutraukti žodžių kūrimo darbą
    private void kurti(){
        while(true){
            // Tikrinama, ar prodiuserių žodžių siuntimo kanale yra nenuskaitytų
            // žodžių
            if(kanalas_zodziai_in.pending()){
                // Žodis skaitomas iš kanalo
                Object duomenys = kanalas_zodziai_in.read();
                String zodis = (String) duomenys;
                // Žodis ieškomas kuriamos dainos tekste
                ieskotiDainoje(zodis);
            }
            // Tikrinama, ar kažkuris prodiuseris kanalu siunčia būseną, jog
            // baigė dainos žodžių kūrimą
            if(kanalas_produseriai_kuria_in.pending()){
                int id = kanalas_produseriai_kuria_in.read();
                nustatytiKadProdiuserisNebekuria(id);
            }
            // Tikrinama, ar daina jau sukurta
            if(dainaSukurta()){
                // Jei daina sukurta, prodiuserių procesams siunčama žinutė,
                // kad šie nustotų kanalu siųsti žodžius
                for (int i = 0; i < kuria.length; i++){
                    kanalas_stabdyti_out[i].out().write(-1);
                }
                break;
            }
            // Tikrinama sąlyga, ar vis dar yra žodžius kuriančių prodiuserių
            // ir ar žodžių siuntimo kanale yra dar nenuskaitytų žodžių
            else if(!yraProdiuseris() && !kanalas_zodziai_in.pending()){
                break;
            }
        }
    }
    
    // Užklotas CSProcess sąsajos metodas run()
    @Override
    public void run(){
        kurti();
        // Spausdinami rezultatai pagal tai, ar dainą pavyko sukurti, ar ne
        if (dainaSukurta()){
            System.out.println("Dainos kūrimo pabaiga.");
            System.out.println("\nRezultatas: DAINA SUKURTA");
        }
        else{
            System.out.println("Dainos kūrimo pabaiga.");
            System.out.println("\nRezultatas: DAINOS SUKURTI NEPAVYKO");
            
        }
    }
}

// Pagrindinė programos klasė
public class KazlauskasM_ID {
    // Kintamieji, kurie pagal nutylėjima priskiriami iš karto
    private static String dainosPavadinimas = Konstantos.DAINA_BOHEMIAN_RHAPSODY;
    private static int giju_sk = 9;
    private static boolean generuoti = false;
    private static int generavimo_budas = 2;
    // Programos pagrindinis metodas
    // @param args - komandinėje eilutėje įvestų parametrų masyvas
    public static void main(String[] args) {
        // Skaitomi programos naudotojo įvesti parametrai
        //skaitytiParametrus(args);
        // Į ekraną išvedama informaciją apie vykdomos programos pagrindinius
        // parametrus
        System.out.println("Pradedama vykdyti programa su šiais duomenimis:");
        System.out.format("   Dainos pavadinimas: %s\n", dainosPavadinimas);
        System.out.format("   Gijų skaičius: %d\n", giju_sk);
        System.out.format("   Ar vykdomas prodiuserių kuriamų žodžių generavimas?: %s\n", (generuoti) ? "Taip" : "Ne");
        if(generuoti) System.out.format("   Prodiuserių kuriamų žodžių generavimo būdas: %s\n", (generavimo_budas == 1) ? "Žodžiai suskaidomi blokais" : "Žodžiai prodiuseriams skirstomi po vieną");
        
        // Sukuriamas naujas Parallel objektas, neturintis jokių gijų
        Parallel visiProcesai = new Parallel();
        
        // Sukuriamas kanalas, skirtas žodžių siuntimui vadybininko procesui
        Any2OneChannel kanalas_zodziaiVadybininkui = Channel.any2one(new InfiniteBuffer());
        // Sukuriamas kanalas, skirtas prodiuserių procesų būsenų siuntimui 
        // vadybininko procesui
        Any2OneChannelInt kanalas_kuria = Channel.any2oneInt(new InfiniteBufferInt());
        // Sukuriamas kanalų masyvas, skirtas vadybininko procesui siųsti žinutes 
        // prodiuserio procesams, kad šie baigtų darbą
        One2OneChannelInt[] kanalas_stabdyti = Channel.one2oneIntArray(giju_sk, new InfiniteBufferInt());
        
        // Generuojami duomenys (prodiuserių kuriami žodžiai)
        if (generuoti) duomenuGeneravimas(dainosPavadinimas, giju_sk, generavimo_budas);
        
        // Sukuriami sąrašai, skirti saugoti dainos bei prodiuserių kuriamiems
        // žodžiams
        List<DainosZodis> dainosZodziai = new ArrayList<>();
        List<List<String>> visuProdiuseriuZodziai = new ArrayList<>();
        
        // Skaitomas dainos tekstas
        skaitytiDainosTeksta(dainosPavadinimas, dainosZodziai);
        // Skaitomi prodiuserių kuriami žodžiai
        skaitytiProdiuseriuZodzius(visuProdiuseriuZodziai, dainosPavadinimas, giju_sk);
        
        // Prie Parallel objekto pridedamas vadybininko procesas
        visiProcesai.addProcess(
               new Vadybininkas(
                       dainosZodziai,
                       kanalas_zodziaiVadybininkui.in(),
                       kanalas_kuria.in(),
                       kanalas_stabdyti,
                       giju_sk
               )
        );
        // Prie Parallel objekto pridedami prodiuserių procesai 
        for (int i = 0; i < giju_sk; i++){
           visiProcesai.addProcess(
                   new Prodiuseris(
                           i,
                           visuProdiuseriuZodziai.get(i),
                           kanalas_zodziaiVadybininkui.out(), 
                           kanalas_kuria.out(), 
                           kanalas_stabdyti[i].in()
                   )
           );
       }
       
       System.out.println("\nVykdomas dainos kūrimas...");
       // Pradedamas matuoti dainos kūrimo laikas
       long start = System.currentTimeMillis();
       visiProcesai.run();
       // Baigiamas matuoti dainos kūrimo laikas
       long finish = System.currentTimeMillis();
       System.out.format("Žodžių paieška dainos kūrimui (dainos kūrimo procesas) užtruko: %d ms\n", (finish-start));
    }
    // Duomenų generavimo funkcija
    // @param daina - dainos pavadinimas
    // @param n - prodiuserių (gijų) skaičius 
    // @param - prodiuserių dainos žodžių generavimo būdas
    private static void duomenuGeneravimas(String daina, int n, int generavimo_budas){
        List<DainosZodis> dainosZodziai = new ArrayList<>();
        // Apibrėžiamas regex šablonas žodžių išskyrimui iš teksto
        Pattern regex = Pattern.compile("[^\\p{Alnum}'-]+");
        String zodis;
        // Nurodomas katalogas, kuriame bus generuojami prodiuserių kuriami žodžiai
        File katalogas = new File("duomenys/" + daina + "/zodziai/");
        // Jei toks katalogas jau egzistuoja, ištrinami visi ten esantys failai
        if(katalogas.exists()){
            for(File file: katalogas.listFiles()) 
                if (!file.isDirectory()) 
                    file.delete();
        }
        // Kitu atveju katalogas sukuriamas naujai
        else{
            try{
                katalogas.mkdir();
            } 
            catch(SecurityException ex){
                System.out.println(ex);
                System.exit(1);
            }  
        }
        // Nurodoma daina, kuria remiantis bus generuojami prodiuserių kuriami 
        // dainos žodžiai
        try (Scanner scanner = new Scanner(new File("duomenys/" + daina + "/daina.txt"))) {
            // Ciklas vykdomas, kol nuskaitomi visi dainos žodžiai
            while (scanner.hasNext()){
                scanner.useDelimiter(regex);
                // Paimamas paskutinis nenuskaitytas dainos žodis
                zodis = scanner.next();
                if (!zodis.equals("")){
                    // Jei žodis nėra tuščia eilutė, jis pridedamas į dainos žodžių sąrašą
                    DainosZodis naujas = new DainosZodis(zodis.toLowerCase(), false);
                    dainosZodziai.add(naujas);
                }
            }
        } catch (Exception ex) {
            System.out.println(ex);
            System.exit(1);
        }
        // Apskaičiuojama, kiek žodžių bus skiriama vienam prodiuseriui (kad būtų
        // padalinta kiek galima tolygiau)
        int zodziu_sk_prodiuseriui = dainosZodziai.size()/n;
        // Žodžio indeksas, nuo kurio bus pradėta dalinti žodžius prodiuseriams
        int dabartinis_zodis = 0;
        // Einama per visus prodiuserius
        for (int i = 1; i <= n; i++){
            try(PrintWriter writer = new PrintWriter("duomenys/" + daina + "/zodziai/" + i + ".txt")) {
                // Jei prodiuserių yra daugiau nei dainos žodžių, tai kiekvienas prodiuseris
                // gaus po vieną dainos žodį, tačiau tie patys žodžiai kartosis
                if(dainosZodziai.size() < n){
                    writer.println(dainosZodziai.get(dabartinis_zodis).imtiZodi());
                    dabartinis_zodis = (dabartinis_zodis + 1) % dainosZodziai.size();
                }
                // Kitu atveju, žodžiai dalinami prodiuseriams, kad nesikartotų
                else{
                    // Jei pasirinktas pirmasis generavimo būdas (kai žodžiai prodiuseriams 
                    // skiriami blokais nuo pradžios
                    if(generavimo_budas == 1){
                        // Jei žodžiai skiriami ne paskutiniam prodiuseriui, tai
                        // skiriamas atitinkamas žodžių blokas
                        if (i != n){
                            while(dabartinis_zodis < (zodziu_sk_prodiuseriui*i)){
                                writer.println(dainosZodziai.get(dabartinis_zodis).imtiZodi());
                                dabartinis_zodis++;
                            }
                        }
                        // Paskutiniam prodiuseriui skiriami visi likę neišdalinti
                        // žodžiai
                        else{
                            while(dabartinis_zodis < dainosZodziai.size()){
                                writer.println(dainosZodziai.get(dabartinis_zodis).imtiZodi());
                                dabartinis_zodis++;
                            }
                        }
                    }
                    // Jei pasirinktas antrasis žodžių generavimo būdas, kai žodžiai
                    // prodiuseriams skirstomi po vieną, pradedant nuo pradžios
                    else if (generavimo_budas == 2){
                        dabartinis_zodis = (i-1);
                        while(dabartinis_zodis < dainosZodziai.size()){
                            writer.println(dainosZodziai.get(dabartinis_zodis).imtiZodi());
                            dabartinis_zodis += n;
                        }
                    }
                }   
            } catch(IOException ex){
                System.out.println(ex);
                System.exit(1);
            }
        }
    }
    // Funkcija, skaitanti dainos tekstą
    // @param dainosPavadinimas - dainos pavadinimas
    // @param dainosZodziai - sąrašas, kuriame bus saugomi dainos žodžiai
    private static void skaitytiDainosTeksta(String dainosPavadinimas, List<DainosZodis> dainosZodziai){
        // Apibrėžiamas regex šablonas žodžių išskyrimui iš teksto
        Pattern regex = Pattern.compile("[^\\p{Alnum}'-]+");
        String zodis;
        // Nurodoma daina, kurios žodžiai bus skaitomi
        try (Scanner scanner = new Scanner(new File("duomenys/" + dainosPavadinimas + "/daina.txt"))) {
            while (scanner.hasNext()){
                scanner.useDelimiter(regex);
                // Išskiriamas paskutinis dar neišskirtas dainos teksto žodis
                zodis = scanner.next();
                //System.out.println(zodis);
                if (!zodis.equals("")){
                    // Sukuriama nauja dainos žodžio struktūra
                    DainosZodis naujas = new DainosZodis(zodis.toLowerCase(), false);
                    // Naujas žodis pridedamas prie sąrašo
                    dainosZodziai.add(naujas);
                }
            }
            if (dainosZodziai.isEmpty()){
                System.out.println("Klaida skaitant dainos tesktą. Daina neturi nė vieno žodžio.");
                System.exit(1);
            }
        } catch (Exception ex) {
            System.out.println("Klaida skaitant dainos tesktą. Jei norite sužinoti, kaip naudotis programa, skaitykite programos instaliavimo bei vykdymo instrukciją.");
            System.out.println(ex);
            System.exit(1);
        }
    }
    // Funkcija, skirta skaityti prodiuserių kuriamus žodžius
    // @param visuProdiuseriuZodziai - sąrašų sąrašas, saugantis visų prodiuserių
    // kuriamus žodžius
    // @param dainosPavadinimas - dainos pavadinimas
    // @param n - prodiuserių skaičius
    private static void skaitytiProdiuseriuZodzius(List<List<String>> visuProdiuseriuZodziai, String dainosPavadinimas, int n){
        // Apibrėžiamas regex šablonas žodžių išskyrimui iš teksto
        Pattern regex = Pattern.compile("[^\\p{Alnum}'-]+");
        // Einama per visų prodiuserių kuriamų žodžių failus
        for (int i = 1; i <= n; i++){
            List<String> prodiuserioZodziai = new ArrayList<>();
            String zodis;
            // Nurodoma konkretaus prodiuserio kuriamų žodžių failas
            try (Scanner scanner = new Scanner(new File("duomenys/" + dainosPavadinimas + "/zodziai/" + i + ".txt"))) {
                while (scanner.hasNext()){
                    scanner.useDelimiter(regex);
                    // Išskiriamas paskutinis nenuskaitytas žodis
                    zodis = scanner.next();
                    if (!zodis.equals("")){
                        // Prodiuserio sukurtas žodis pridedamas į sarašą
                        prodiuserioZodziai.add(zodis.toLowerCase());
                    }
                }
                // Visų atitinkamo prodiuserio sukurtų žodžių sąrašas pridedamas
                // prie bendro sąrašo
                visuProdiuseriuZodziai.add(prodiuserioZodziai);
            } catch (Exception ex) {
                System.out.println("Klaida skaitant prodiuserio žodžius. Jei norite sužinoti, kaip naudotis programa, skaitykite programos instaliavimo bei vykdymo instrukciją.");
                System.out.println(ex);
                System.exit(1);
            }
        }
    }
    // Funkcija, skaitanti komandinėje eilutėje nurodytus parametrus
    // @para args[] - komandinėje eilutėje nurodyti parametrai
    private static void skaitytiParametrus(String args[]){
        // Tikrinama, ar nurodytas bent vienas parametras
        if (args.length == 0){
            System.out.println("Nepateikėte nė vieno parametro. Jei norite sužinoti, kaip naudotis programa, skaitykite programos instaliavimo bei vykdymo instrukciją.");
            System.exit(1);
        }
        else{
            // Tikrinamas pirmasis parametras
            switch(args[0]){
                // Ar pirmasis parametras yra -d (demonstracija)
                case "-d": {
                    // Tikrinama, ar nenurodyta per mažai parametrų (viso turi būti 2)
                    if(args.length < 2){
                        System.out.println("Nurodėte per mažai parametrų. Jei norite sužinoti, kaip naudotis programa, skaitykite programos instaliavimo bei vykdymo instrukciją.");
                        System.exit(1);
                    }
                    // Nurodytas procesų skaičiaus parametras verčiamas į sveikojo
                    // skaičiaus kintamąjį
                    int sk = Integer.parseInt(args[1]);
                    // Tikrinama, ar nurodytas procesų skaičius nėra lygus 0
                    if (sk == 0){
                        System.out.println("Gijų skaičius turi būti didesnis už 0.");
                        System.exit(1);
                    }
                    // Parametrams nustatomos reikšmės
                    dainosPavadinimas = Konstantos.DAINA_BOHEMIAN_RHAPSODY;
                    giju_sk = sk;
                    generuoti = true;
                    break;
                }
                // Ar pirmasis parametras yra -g (generacija)
                case "-g": {
                    // Tikrinama, ar nenurodyta per mažai parametrų (viso turi būti 4)
                    if(args.length < 4){
                        System.out.println("Nurodėte per mažai parametrų. Jei norite sužinoti, kaip naudotis programa, skaitykite programos instaliavimo bei vykdymo instrukciją.");
                        System.exit(1);
                    }
                    // Nurodytas procesų skaičiaus parametras verčiamas į sveikojo
                    // skaičiaus kintamąjį
                    int sk = Integer.parseInt(args[2]);
                    // Tikrinama, ar nurodytas procesų skaičius nėra lygus 0
                    if (sk == 0){
                        System.out.println("Gijų skaičius turi būti didesnis už 0.");
                        System.exit(1);
                    }
                    // Nurodytas duomenų generavimo būdas verčiamas į sveikojo
                    // skaičiaus kintamąjį
                    int budas = Integer.parseInt(args[3]);
                    // Tikrinama, ar nurodytas generavimo būdas yra 1 arba 2
                    if(budas <= 0 && budas > 2){
                        System.out.println("Įvestas netinkamas generavimo būdas. Jei norite sužinoti, kaip naudotis programa, skaitykite programos instaliavimo bei vykdymo instrukciją.");
                        System.exit(1);
                    }
                    // Parametrams nustatomos reikšmės
                    dainosPavadinimas = args[1];
                    giju_sk = sk;
                    generavimo_budas = budas;
                    generuoti = true;
                    break;
                }
                // Ar pirmasis parametras yra -p (pasirinktinis)
                case "-p": {
                    // Tikrinama, ar nenurodyta per mažai parametrų (viso turi būti 3)
                    if(args.length < 3){
                        System.out.println("Nurodėte per mažai parametrų. Jei norite sužinoti, kaip naudotis programa, skaitykite programos instaliavimo bei vykdymo instrukciją.");
                        System.exit(1);
                    }
                    // Nurodytas procesų skaičiaus parametras verčiamas į sveikojo
                    // skaičiaus kintamąjį
                    int sk = Integer.parseInt(args[2]);
                    // Tikrinama, ar nurodytas procesų skaičius nėra lygus 0
                    if (sk == 0){
                        System.out.println("Gijų skaičius turi būti didesnis už 0.");
                        System.exit(1);
                    }
                    // Parametrams nustatomos reikšmės
                    dainosPavadinimas = args[1];
                    giju_sk = sk;
                    generuoti = false;
                    break;
                }
            }
        }
    }
}
