/**
 * Created by Mangirdas Kazlauskas IF-4/12.
 */
public class Grafas extends Briauna{
    int v;              // virsuniu sk.
    int b;              // briaunu sk.
    Briauna briaunos[]; // briaunu masyvas

    Grafas(){
        this.v = 0;
        this.b = 0;
    }
    // Konstruktorius
    Grafas(int v, int b){
        this.v = v;
        this.b = b;
        this.briaunos = new Briauna[b];
        for (int i = 0; i < b; i++)
            this.briaunos[i] = new Briauna();
    }
}
