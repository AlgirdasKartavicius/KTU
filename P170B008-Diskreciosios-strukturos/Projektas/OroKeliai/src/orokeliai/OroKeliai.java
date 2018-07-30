/**
 *
 * @author Mangirdas
 */
package orokeliai;

import java.util.*;
import studijosKTU.*;

public class OroKeliai{
    
    static int n = 10; // Čia nustatomas viršūnių skaičius
    static int[][] vertCordinates = new int[n][2];
    static List<int[]> keyRoutes = new ArrayList<>();
    static int[] path = new int[n+1];
    
    // Iš visų galimų maršrutų grąžinamas trumpiausiojo indeksas
    public static int shortestPath(ArrayList<int[]> aPaths){
        int minIndex = 0;
        System.out.println("Galimų maršrutų ilgiai:");
        double min = findLength(aPaths.get(0));
        System.out.println(1 + "-ojo: " + min);
        for (int i = 1; i < aPaths.size(); i++){
            double length = findLength(aPaths.get(i));
            System.out.println(i+1 + "-ojo: " + length);
            if (length < min){
                minIndex = i;
                min = length;
            }
        }
        System.out.println();
        return minIndex;      
    }
    
    // Randamas atstumas tarp dviejų miestų
    private static double findLength(int[] vertices){
        double length = 0;
        for (int i = 0; i < vertices.length-1; i++)
            length += Math.sqrt(Math.abs((Math.pow(vertCordinates[vertices[i+1]-1][0],2) 
                      - Math.pow(vertCordinates[vertices[i]-1][0],2)))+
                      (Math.abs(Math.pow(vertCordinates[vertices[i+1]-1][1],2) - 
                       Math.pow(vertCordinates[vertices[i]-1][1],2))));
        return length;
        
    }
    
    // Gražiau išveda masyvo reikšmes
    public static void toString(int[] Array){
        System.out.print(Array[0]);
        for (int i = 1; i < Array.length; i++)
            System.out.print(" -> " + Array[i]);
        System.out.println();
    }
    
    // Tikrina, ar maršrute yra privalomas tiesioginis skrydis
    public static boolean checkRoute(int first, int second){
        for (int i = 0; i < n; i++){
            if (path[i] == first && path[i+1] == second)
                return true;
        }
        return false;
    }
    
    // Priverstinių tiesioginių skrydžių sąrašo įvedimas
    public static void dialogas(){
        int variantas;
        boolean marsrutas = true;
        System.out.println("Įveskite priverstinius tiesioginius maršrutus. Jei "
                + "daugiau maršrutų įvesti nebenorite, įveskite 0.");
        while (marsrutas){
            String route = Ks.giveString("Įveskite pradinio ir galutinio "
                + "priverstinio maršruto miestų numerius (nuo 1 iki " + n + "): ");
            if (route.equals("0"))
                break;
      
            Scanner ed = new Scanner(route);
            int[] keyRoute = new int[2];
            keyRoute[0] = ed.nextInt(); keyRoute[1] = ed.nextInt();
            keyRoutes.add(keyRoute);
        }
        System.out.println();
    }
    
    // Visų įmanomų maršrutų generavimas
    public static void generate(List<int[]> aPaths){
        path[path.length - 1] = 1;
        for (int i = 0; i < n; i++)
            path[i] = i+1;
        boolean t = true;
        while(t){
            boolean yra = true;
            for (int[] i : keyRoutes)
                if (i[0] != 0){
                    yra = checkRoute(i[0], i[1]);
                    if (!yra)
                        break;
                }
            if (yra){
                int[] newPath = new int[n+1];
                System.arraycopy(path, 0, newPath, 0, n+1);
                aPaths.add(newPath);
            }   
            //----------------------------
            int i = n - 1;
            while (path[i] > path[i+1])
                i--;
            if (i == 0)
                t = false;
            else{
                int j = n - 1;
                while (path[j] < path[i])
                    j--;
                int tarp = path[i];
                path[i] = path[j];
                path[j] = tarp;
                int k = i + 1; 
                int l = n - 1;
                while (k < l){
                    tarp = path[k];
                    path[k] = path[l];
                    path[l] = tarp;
                    k++;
                    l--;
                }
            }
        } 
    }
    
    // Pagrindinė programa
    public static void main(String[] args) {
        System.out.println("Miestų skaičius: " + n);
        System.out.println("");
        // Miestų koordinačių generavimas (nuo to priklauso atstumai tarp miestų)
        int[] ints = new Random().ints(1, n+1).distinct().limit(n).toArray(); 
        for (int i = 0; i < n; i++)
            vertCordinates[i][0] = ints[i];
        ints = new Random().ints(1, n+1).distinct().limit(n).toArray();
        for (int i = 0; i < n; i++)
            vertCordinates[i][1] = ints[i];
        for (int i = 0; i < n; i++){
            System.out.print((i+1) + "-ojo miesto koordinatės (x ir y): ");
            System.out.println(vertCordinates[i][0] + " " + vertCordinates[i][1]);
        }
        System.out.println();
        
        // Dvimačio masyvo, kuriame saugomi privalomi maršrutai, generavimas
        dialogas();
        
        System.out.println("Privalomi tiesioginiai maršrutai:");
        keyRoutes.stream().filter((k) -> (k[0] != 0)).forEach((k) -> {
            System.out.println(k[0] + " -> " + k[1]);
        });
        System.out.println();
        
        // Visų įmanomų maršrutų generavimas (kėlinių generavimas)
        List<int[]> aPaths = new ArrayList<>();
        
        generate(aPaths);
        
        System.out.println("Galimi maršrutai:");
        for (int i = 0; i < aPaths.size(); i++){
            System.out.print(i+1 +": ");
            toString(aPaths.get(i));
        }
        System.out.println();
        
        // Iš tinkamų maršrutų randamas trumpiausias
        int shortestIndex;
        if (!aPaths.isEmpty()){
            shortestIndex = shortestPath((ArrayList<int[]>)aPaths);
            System.out.println("Iš galimų maršrutų, trumpiausias yra " + 
                (shortestIndex+1) + "-asis: ");
            toString(aPaths.get(shortestIndex));
        }
        else
            System.out.println("NĖRA JOKIO GALIMO MARŠRUTO!!!");
    }    
}
