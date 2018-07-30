/**
 * Created by Mangirdas on 2016-03-20.
 */
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.util.Objects;
import java.util.zip.Inflater;


public class Printing extends Sorting{

    public static String dataName = "Data.txt";
    public static String linksName = "Links.txt";

    public static void main(String[] args) throws IOException {
        if (args.length == 2) {
            if (Objects.equals(args[0], "Array"))
                spausdintiMasyva(args[1]);
        }
        else if (args.length == 3) {
            if (Objects.equals(args[0], "List"))
                spausdintiSarasa(args[1], args[2]);
            }
    }
    private static void spausdintiMasyva(String dataName) throws FileNotFoundException, IOException{
        RandomAccessFile raf = new RandomAccessFile(dataName, "r");
        for (int i = 0; i < 40; i++){
            System.out.print(i + "= " + getNumber(raf, i) + " :");
        }
        raf.close();
    }
    private static void spausdintiSarasa(String dataName, String linksName) throws FileNotFoundException, IOException{
        RandomAccessFile rafd = new RandomAccessFile(dataName, "r");
        RandomAccessFile rafl = new RandomAccessFile(linksName, "r");
        System.out.print(getFirstLink(rafl) + " -> ");
        for (int i = 0; i < 40; i++){
            System.out.print("<- " + getLinkPrevious(rafl, i) + ":" +
                    getNumber(rafd, i) + ":" + getLinkNext(rafl, i) + " -> ");
        }
        System.out.print("...");
        rafd.close();
        rafl.close();
    }
}
