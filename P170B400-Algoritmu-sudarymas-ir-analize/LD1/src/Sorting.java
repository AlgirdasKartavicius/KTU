/**
 * Created by Mangirdas on 2016-03-19.
 */
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.ObjectStreamClass;
import java.io.RandomAccessFile;
import java.text.ParseException;
import java.util.Objects;

public class Sorting extends Generator {
    public static String dataName = "Data.txt";
    public static String linksName = "Links.txt";

    public static void main(String[] args) throws ParseException, IOException {
        long start = System.currentTimeMillis();
        if (args.length == 3) {
            if (Objects.equals(args[0], "List")) insertionSortList(args[1], args[2]);
        } else if (args.length == 2) {
            if (Objects.equals(args[0], "Array")) insertionSortArray(args[1]);
        }
        //insertionSortTest();
        long end = System.currentTimeMillis();
        System.out.println("Rikiavimo laikas: " + (end - start) + "ms");
    }

    private static void insertionSortTest() {
        int test[] = new int[]{4, 6, 9, 8, 8, 1};
        int key, j;
        for (int i = 1; i < test.length; i++) {
            key = test[i];
            for (j = i - 1; (j >= 0) && (test[j] > key); j--) // (test[j] < key) - rikiuos mazejanciai
                test[j + 1] = test[j];
            test[j + 1] = key;
        }
        System.out.print("Surusiuotas masyvas:");
        for (int i : test)
            System.out.print(" " + i);
    }

    private static void insertionSortArray(String dataName) throws FileNotFoundException, IOException {
        RandomAccessFile raf = new RandomAccessFile(dataName, "rw");
        int key, j;
        for (int i = 1; i < raf.length() / 4; i++) {
            key = getNumber(raf, i);
            for (j = i - 1; (j >= 0) && (getNumber(raf, j) > key); j--)
                setNumber(raf, j + 1, getNumber(raf, j));
            setNumber(raf, j + 1, key);
        }
        raf.close();
    }

    private static void insertionSortList(String dataName, String linksName) throws FileNotFoundException, IOException {
        RandomAccessFile rafd = new RandomAccessFile(dataName, "rw");
        RandomAccessFile rafl = new RandomAccessFile(linksName, "r");
        int key, currentId, previousId;
        int head = getFirstLink(rafl);
        int currentLinkF = getLinkNext(rafl, head);
        do {
            currentId = currentLinkF;
            previousId = currentLinkF - 1;
            int previousLinkP;
            currentLinkF = getLinkNext(rafl, currentId);
            key = getNumber(rafd, currentId);
            do {
                previousLinkP = getLinkPrevious(rafl, previousId);
                if (getNumber(rafd, previousId) > key) {
                    setNumber(rafd, previousId + 1, getNumber(rafd, previousId));
                    previousId = previousLinkP;
                }
            } while (previousLinkP != -1 && getNumber(rafd, previousId) > key);
            setNumber(rafd, previousId + 1, key);
        } while (currentLinkF != -1);
        rafd.close();
        rafl.close();
    }

    // nuskaitome i-taji elementa is binarinio failo (zinome, kad visi elementai uzima po 4 bitus, todel i-tojo reiksmes pradzia bus i*4)
    public static int getNumber(RandomAccessFile raf, int i) throws IOException {
        raf.seek(i*4);
        return raf.readInt();
    }

    // priskiriame i-tajam elementui nauja reiksme
    public static void setNumber(RandomAccessFile raf, int i, int value) throws IOException {
        raf.seek(4 * i);
        raf.writeInt(value);
    }

    public static int getFirstLink(RandomAccessFile raf) throws IOException {
        raf.seek(0);
        return raf.readInt();
    }

    public static int getLinkNext(RandomAccessFile raf, int current) throws IOException {
        raf.seek(current * 8 + 8);
        return raf.readInt();
    }

    public static int getLinkPrevious(RandomAccessFile raf, int current) throws IOException {
        raf.seek(current * 8 + 4);
        return raf.readInt();
    }
}

