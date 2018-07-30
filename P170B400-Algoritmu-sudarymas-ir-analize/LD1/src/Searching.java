/**
 * Created by Mangirdas on 2016-03-21.
 */
import java.awt.*;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.util.Random;
import java.util.Arrays;
import java.io.File;

public class Searching {
    private static long tableSize = 20;

    public static void main(String[] args) throws IOException{
        long start = System.currentTimeMillis();
        Searching s = new Searching();
        s.generateStudents("Studentai.data", 6400);
        s.studentuPaieska("Studentai.data", "hash.data");
        s.atvaizduotiElementus("hash.data");
        /*if (args.length == 3) {
            Searching s = new Searching();
            s.generateStudents(args[0], Integer.parseInt(args[2]));
            s.studentuPaieska(args[0], args[1]);
            s.atvaizduotiElementus(args[1]);
        }
        else if (args.length == 2) {
            Searching s = new Searching();
            s.generateStudents(args[0], 1000);
            s.studentuPaieska(args[0], args[1]);
            s.atvaizduotiElementus(args[1]);
        }
        else if (args.length == 1) {
            Searching s = new Searching();
            s.generateStudents(args[0], 1000);
            s.studentuPaieska(args[0], "hash.data");
            s.atvaizduotiElementus("hash.data");
        }
        else if (args.length == 0) {
            Searching s = new Searching();
            s.generateStudents("Studentai.data", 1000);
            s.studentuPaieska("Studentai.data", "hash.data");
            s.atvaizduotiElementus("hash.data");
        }*/
        long end = System.currentTimeMillis();
        System.out.println("Paieskos laikas: " + (end - start) + "ms");
    }

    // Studentu generacija
    private static void generateStudents(String fileName, long n) throws FileNotFoundException, IOException{
        // Pirmojo ir paskutinio studento pavardes vienodos, kitos - random
        RandomAccessFile raf = new RandomAccessFile(fileName, "rw");
        raf.setLength(n*20);
        raf.seek(0);
        raf.writeChar('P');
        for (int i = 1; i < 10; i++) {
            raf.seek(i * 2);
            raf.writeChar('a');
        }
        for (long i = 1; i < n; i++){
            char []pav = new char [10];
            // Generacija
            pav[0] = 'P';
            for (int j = 1; j < pav.length; j++){
                Random rand = new Random();
                int value = rand.nextInt(122 - 97 + 1) + 97;
                // Padaroma taip, kas paskutine pavarde sutaptu su pirmaja
                if (i != n-1)
                    pav[j] = (char)value;
                else
                    pav[j] = 'a';
                // atkomentuoti, jei norime, kad kazkuri pavarde pasikartotu daugiau nei 2 kartus
                 /*if (i == n/2 || i == n/3 || i == n/4)
                    pav[j] = 'a';
                else if (i == n-1)
                    pav[j] = 'a';
                else
                    pav[j] = (char)value;*/
            }
            // Irasymas i faila (viena pavarde faile uzima 20 bitu)
            for (int j = 0; j < pav.length; j++){
                raf.seek(j*2 + i*20);
                raf.writeChar(pav[j]);
            }
        }
        raf.close();
    }

    // Sukurti nauja lentele
    public static void createEmpty(RandomAccessFile raf, float loadFactor, long size) throws FileNotFoundException, IOException{
        raf.setLength(20 + 8*size);
        raf.seek(0);
        raf.writeFloat(loadFactor); // lenteles uzpildymas
        raf.writeLong(size); // lenteles dydis
        raf.writeLong(0); // nariu skaicius
        for (int i = 0; i < size; i++) raf.writeLong(-1); // tuscia vieta
    }

    // hesavimo funkcija
    public static long hash(char []masyvas) {
        long h = Arrays.hashCode(masyvas);
        return Math.abs(h) % tableSize;
    }

    // pavardes itraukimas i lentele
    public static void put(RandomAccessFile raf, char []masyvas) throws IOException {
        /* Lenteles failo sudetis:
        * pirmi 4 bitai - load Factor
        * tolesni 8 bitai - lenteles dydis
        * tolesni 8 bitai - nariu skaicius lenteleje
        * Viso: 20 pirmu failo bitu uzimta
        * Kiekviena grandinele turi savo indeksa, todel viso tokiu indeksu - 8 bitai*lenteles dydis
        * Kiekviena grandinėle viduje talpina pavardes (10 * 2 bitai),
        * tokiu paciu pavardziu kieki - 8 bitai, adresas i kita - 8 bitai
        * Viso: 20 + 8 + 8 = 36 bitai vienam nariui, is viso bitu nariams - 36 bitai * nariu skaicius */
        raf.seek(4);
        tableSize = raf.readLong();
        raf.seek(12);
        long nariuSk = raf.readLong();
        long pabPos = 20+8*tableSize+36*nariuSk;
        long hash = hash(masyvas);
        raf.seek(hash*8+20);
        long kitasNarys = raf.readLong();
        if (kitasNarys==-1) {
            raf.seek(hash*8+20);
            raf.writeLong(pabPos);
            for (int i = 0; i < 10; i++) {
                raf.seek(i*2+pabPos);
                raf.writeChar(masyvas[i]);
            }
            raf.seek(pabPos+20);
            raf.writeLong(1);
            raf.seek(pabPos+20+8);
            raf.writeLong(-1);
            nariuSk++;
            raf.seek(12);
            raf.writeLong(nariuSk);
        }
        else {
            boolean radau = false;
            while (!radau) {
                char []t = new char[10];
                for (int i = 0; i < 10; i++) {
                    raf.seek(i*2+kitasNarys);
                    t[i] = raf.readChar();
                }
                if (Arrays.equals(t, masyvas)) {
                    raf.seek(20+kitasNarys);
                    long kiekis = raf.readLong()+1;
                    raf.seek(20+kitasNarys);
                    raf.writeLong(kiekis);
                    radau = true;
                }
                else {
                    raf.seek(kitasNarys+28);
                    long kitasT = raf.readLong();
                    if (kitasT==-1) {
                        raf.seek(kitasNarys+28);
                        raf.writeLong(pabPos);
                        for (int i = 0; i < 10; i++) {
                            raf.seek(i*2+pabPos);
                            raf.writeChar(masyvas[i]);
                        }
                        raf.seek(pabPos+20);
                        raf.writeLong(1);
                        raf.seek(pabPos+20+8);
                        raf.writeLong(-1);
                        radau = true;
                        nariuSk++;
                        raf.seek(12);
                        raf.writeLong(nariuSk);
                    }
                    else
                        kitasNarys = kitasT;
                }
            }
        }
    }

    /* Vienodu studentu radimo principas: sugeneruotos studentu pavardes po viena talpinamos i lentele,
    * put metodas viduje tikrina, ar tokia pavarde jau yra, jei yra - prie tam tikros pavardes esantis indeksas
    * padidinamas vienetu ir ta pati pavarde i lentele neiterpiama. Todel turint galutine pavardziu lentele,
    * einant per pavardziu pasikartojimo kiekiu indeksus, galima pamatyti, kiek kartu pasikartojo tam tikra pavarde
    * */
    public static void studentuPaieska(String dataName, String hashName) throws IOException {
        RandomAccessFile rafData = new RandomAccessFile(dataName, "rw");
        RandomAccessFile raf = new RandomAccessFile(hashName, "rwd");
        tableSize = 0;
        createEmpty(raf,0.75f,20);
        long n = rafData.length()/20;
        for (long i = 0; i < n; i++) {
            char []p = new char[10];
            for (int j = 0; j < 10; j++) {
                rafData.seek(j*2+i*20);
                p[j] = rafData.readChar();
            }
            put(raf,p);
        }
        rafData.close();
        raf.close();
    }

    // atvaizduoja gautos lenteles duomenis
    public static void atvaizduotiElementus(String name) throws IOException {
        RandomAccessFile raf = new RandomAccessFile(name, "rw");
        raf.seek(4); // suranda dydi
        long dydisT = raf.readLong();
        System.out.println("Lenteles dydis: " + dydisT);
        long next;
        long kiekis;
        char []t = new char[10];
        for (long i = 0; i < dydisT; i++) {
            raf.seek(20+i*8);
            next = raf.readLong();
            while (next!=-1) {
                for (int j = 0; j < 10; j++) {
                    raf.seek(j*2+next);
                    t[j] = raf.readChar();
                }
                // kiekis
                raf.seek(next+20);
                kiekis = raf.readLong();
                String pavarde = new String(t);
                if (kiekis > 1)
                    System.out.println("Pavarde: " + pavarde + " lenteleje pasikartoja " + kiekis + " kartus(-u).");
                // rodykle i kita
                raf.seek(next+20+8);
                next = raf.readLong();
            }
        }
        raf.close();
    }
}
