/**
 * Created by Mangirdas on 2016-03-18.
 */
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Random;

// Sugeneruoja sveikuosius skaičius bei rodykles
public class Generator {

    private static int N = 1000;
    public static String dataName = "Data.txt";
    public static String linksName = "Links.txt";

    public static void main(String[] args) throws  ParseException, IOException{
        if (args.length == 3){
            generateNumbers(args[0], args[1], Integer.parseInt(args[2]));
            dataName = args[0];
            linksName = args[1];
            setN(Integer.parseInt(args[2]));
        }
        else if (args.length == 2){
            generateNumbers(args[0], args[1], getN());
            dataName = args[0];
            linksName = args[1];
        }
        else if (args.length == 1){
            generateNumbers(args[0], linksName, getN());
            dataName = args[0];
        }
        else{
            generateNumbers(dataName, linksName, getN());
        }
    }

    // generuojami sveikieji skaiciai (kiekis - N)
    private static void generateNumbers(String dataName, String linksName, int N) throws ParseException, IOException{
        RandomAccessFile raf = new RandomAccessFile(dataName, "rw");
        raf.setLength(N*4);
        Random rand = new Random();
        raf.seek(0);
        for (int i=0; i < N; i++) {
            int value = rand.nextInt(1000);
            //value = i;
            raf.writeInt(value);
        }
        System.out.print("Pirmu 20 sugeneruotu elementu seka:");
        for (int i = 0; i < 20; i++){
            raf.seek(i*4);
            int val = raf.readInt();
            System.out.print(" " + val);
        }
        System.out.println("...\nSugeneruotu duomenu kiekis: "+N);
        generateLinks(linksName, N);
        raf.close();
    }

    private static void setN(int value){
        N = value;
    }

    public static int getN(){
        return N;
    }

    // generuojamos rodykles
    private static void generateLinks(String linksName, int N) throws ParseException, IOException{
        RandomAccessFile raf = new RandomAccessFile(linksName, "rw");
        raf.writeInt(0);
        for (int i = 0; i < N; i++){
            if (i != N - 1) {
                raf.writeInt(i - 1);
                raf.writeInt(i + 1);
            }
            else{
                raf.writeInt(i-1);
                raf.writeInt(-1);
            }
        }
    }
}
