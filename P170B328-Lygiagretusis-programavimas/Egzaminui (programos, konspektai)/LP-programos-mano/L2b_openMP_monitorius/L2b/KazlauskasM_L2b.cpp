/*
	KazlauskasM_L2b.cpp

	Mangirdas Kazlauskas IFF-4/1
	Uþduotis L2b
*/

#include <iostream>
#include <iomanip>
#include <fstream>
#include <string>
#include <omp.h>

using namespace std;

// Failø vardai
const string DUOMENU_FAILAS = "KazlauskasM_L2_dat_3.txt";
const string REZULTATU_FAILAS = "KazlauskasM_L2_rez.txt";
// Gamintojø gijø skaièius
const int N = 5;
// Vartotojø gijø skaièius
const int M = 4;
// Maksimalus elementø skaièius masyve
const int C_MAX = 10;
// Maksimalus elementø skaièius bendrame masyve B
const int C_B_MAX = 100;

/*
	Automobilio (gamintojo prekës) struktûra
	pavadinimas - automobilio modelis
	metai - automobilio pagaminimo metai
	litrai - automobilio darbinis variklio tûris
*/
struct Automobilis {
	string pavadinimas;
	int metai;
	double litrai;
};

/*
	Rikiavimo lauko (vartotojo) struktûra
	rikiavimoLaukas - laukas, pagal kurá bus rikiuojama ir áterpiama bendrame masyve
	kiekis - to paties rikiavimoLauko elementø kiekis bendrame masyve ar kiekis, kurá nori suvartoti (pasiimti) vartotojas
*/
struct RikiavimoStruktura {
	int rikiavimoLaukas;
	int kiekis;
};

/*
	Gamintojo gijos struktûra
	D - Automobiliø struktûrø masyvas
	kiekis - elementø skaièius masyve D
*/
struct Gamintojas {
	Automobilis D[C_MAX];
	int kiekis = 0;
};

/*
	Vartotojo gijos struktûra
	D - Rikiavimo strûktûros masyvas
	kiekis - elementø skaièius masyve D
*/
struct Vartotojas {
	RikiavimoStruktura D[C_MAX];
	int kiekis = 0;
};

/*
	Monitoriaus klasë, kurioje atliekami visi veiksmai su gijomis
*/
class Monitorius {
private:
	// Bendras masyvas B, á kurá vienu metu talpinami bei ið jo ðalinami elementai
	RikiavimoStruktura B[C_B_MAX];
	// Dabartinis esanèiø elementø skaièius bendrame masyve B
	int kiekis = 0;
	// Masyvas, saugantis loginæ reikðmæ, ar i-tasis gamintojas vis dar talpina elementus á bendrà masyvà
	bool gamina[N];

	/*
		Funkcija, reikalinga reikiamai elemento áterpimo vietai bendrame masyve rasti
	*/
	int iterpimoVieta(int elem){
		// Jei masyvas tuðèias - gràþinama pirmoji masyvo vieta (indeksas 0)
		if (kiekis == 0)
			return 0;
		/* 
			Kadangi rikiuojama didëjimo tvarka, tai ieðkoma, kol áterpiamas elementas
			yra maþesnis uþ jau esantá masyve, gràþinama rasta vieta
		*/
		for (int i = 0; i < kiekis; i++)
			if (elem <= B[i].rikiavimoLaukas)
				return i;
		// Jei elementas didesnis uþ visus, esanèius bendrame masyve, gràþinama vieta, esanti uþ paskutinio elemento
		return kiekis;
	}
public:
	/*
		Monitoriaus konstruktorius
		@param G - gamintojø gijø masyvas
		@param V - vartotojø gijø masyvas
	*/
	Monitorius() {
		for (int i = 0; i < N; i++) {
			gamina[i] = true;
		}
	}
	// Destruktorius
	~Monitorius() {}

	/*
		Gràþina vienà elementà ið bendro masyvo (reikalinga rezultatø spausdinimui)
		@param i - elemento indeksas bendrame masyve B
	*/
	RikiavimoStruktura imtiBendroMasyvoElementa(int i) {
		return B[i];
	}

	/*
		Gràþina elementø kieká, esantá bendrame masyve
	*/
	int imtiKieki() {
		return kiekis;
	}

	/*
		Nustato, jog i-tasis gamintojas baigë darbà
	*/
	void nustatytiKadNebegamina(int i){
		gamina[i] = false;
	}

	/*
	Funkcija, talpinanti elementus á bendrà masyvà
	@param laukas - rikiavimo lauko reikðmë, kurià norima áterpti á bendrà masyvà
	*/
	void talpinti(int laukas){
		#pragma omp critical
		{
			// Randama áterpimo vieta
			int vieta = iterpimoVieta(laukas);
			// Jei lauko reikðmë sutampa su jau esanèia masyve, kiekis padidinamas
			if (B[vieta].rikiavimoLaukas == laukas){
				B[vieta].kiekis++;
			}
			// Jei áterpiame kaip patá pirmà elementà á tuðèià masyvà arba á masyvo galà
			else if (vieta == 0 && kiekis == 0 || vieta == kiekis){
				B[vieta].kiekis = 1;
				B[vieta].rikiavimoLaukas = laukas;
				kiekis++;
			}
			// Kitais atvejais masyve atlaisvinama vieta áterpiamam elementui
			else{
				for (int i = kiekis; i > vieta; i--)
					B[i] = B[i - 1];
				B[vieta].kiekis = 1;
				B[vieta].rikiavimoLaukas = laukas;
				kiekis++;
			}
		}
	}

	/*
	Funkcija, ið bendro masyvo ðalinanti elementà.
	@param elem - norimas paðalinti elementas
	Gràþina true, jei elementà pavyko paðalinti arba pavyko rasti elementà ir sumaþinti jo kieká masyve
	*/
	bool salinti(RikiavimoStruktura elem){
		while (kiekis == 0 && yraGamintojas()) {}
		bool pasalinta = false;
		#pragma omp critical
		{
			// Bendrame masyve ieðkomas norimas elementas
			for (int i = 0; i < kiekis; i++){
				if (B[i].rikiavimoLaukas == elem.rikiavimoLaukas){
					/*
					Jei vartotojas nori pasiimti maþiau nei yra bendrame masyve,
					bendrame masyve sumaþinamas elementø kiekis
					*/
					if (elem.kiekis < B[i].kiekis){
						B[i].kiekis -= elem.kiekis;
					}
					/*
					Jei vartotojas nori pasiimti daugiau arba tiek, kiek yra
					bendrame masyve - elementas ið bendro masyvo ðalinamas
					*/
					else{
						/*
						Jei ðalinamas pirmasis elementas, kai bendrà masyvà sudaro vienas elementas
						arba ðalinamas paskutinis elementas
						*/
						if (i == 0 && kiekis == 1 || i == kiekis - 1)
							kiekis--;
						/*
						Kitu atveju, kai elementas ðalinamas ið masyvo vidurio
						*/
						else{
							for (int j = i; j < kiekis - 1; j++)
								B[j] = B[j + 1];
							kiekis--;
						}
					}
					// Buvo kaþkas paðalinta
					pasalinta = true;
				}
			}	
		}
		// Jei kaþkas buvo paðalinta ar pamaþintas kiekis, gràþinamas true, kitu atveju - false
		if (pasalinta)
			return true;
		else
			return false;
	}

	/*
	Funkcija, gràþinanti true, jei vis dar yra gaminanèiø gamintojø.
	Jei visi gamintojai baigë darbà - false
	*/
	bool yraGamintojas(){
		for (int i = 0; i < N; i++)
			if (gamina[i])
				return true;
		return false;
	}
};

/*
	Funkcijø prototipai
*/
void skaitytiDuomenis(string fv, Gamintojas G[], Vartotojas V[]);
void spausdintiDuomenis(string fv, Gamintojas G[], Vartotojas V[]);
void spausdintiRezultatus(string fv, Monitorius *monitorius);
void paleistiGijas(Gamintojas G[], Vartotojas V[], Monitorius *monitorius);

/*
	Pagrindinë programos funkcija (master gija)
*/
int main() {
	// Masyvai, kuriuose saugoma gamintojø ir vartotojø gijø informacija
	Gamintojas G[N];
	Vartotojas V[M];

	// Duomenø skaitymas bei áraðymas á rezultatø failà
	skaitytiDuomenis(DUOMENU_FAILAS, G, V);
	spausdintiDuomenis(REZULTATU_FAILAS, G, V);

	// Monitoriaus sukûrimas bei gijø paleidimas
	Monitorius *monitorius = new Monitorius();

	// Pradedamas gijø darbas
	paleistiGijas(G, V, monitorius);

	// Gautø rezultatø spausdinimas
	spausdintiRezultatus(REZULTATU_FAILAS, monitorius);

	// Atlaisvinama atmintis
	delete(monitorius);
	return 0;
}

/*
	Duomenø skaitymo ið failo funkcija
	@param fv - failo vardas
	@param G - gamintojø masyvas, kuriame bus iðsaugotos nuskaitytos reikðmës
	@param V - vartotojø masyvas, kuriame bus iðsaugotos nuskaitytos reikðmës
*/
void skaitytiDuomenis(string fv, Gamintojas G[], Vartotojas V[]) {
	ifstream F(fv);
	/*
	Gamintojo duomenø nuskaitymas
	*/
	F.ignore(256, '\n');
	int kiekis;
	for (int i = 0; i < N; i++) {
		F >> kiekis;
		G[i].kiekis = kiekis;
		for (int j = 0; j < kiekis; j++) {
			Automobilis a;
			string pav;
			int metai;
			double litrai;
			F >> pav >> metai >> litrai;
			a.pavadinimas = pav;
			a.metai = metai;
			a.litrai = litrai;
			G[i].D[j] = a;
		}
	}
	F.ignore(256, '\n');
	F.ignore(256, '\n');
	for (int i = 0; i < M; i++) {
		F >> kiekis;
		V[i].kiekis = kiekis;
		for (int j = 0; j < kiekis; j++) {
			RikiavimoStruktura rs;
			int rikiavimoLaukas;
			int kiekis;
			F >> rikiavimoLaukas >> kiekis;
			rs.rikiavimoLaukas = rikiavimoLaukas;
			rs.kiekis = kiekis;
			V[i].D[j] = rs;
		}
	}
	F.close();
}

/*
	Pradiniø duomenø spausdinimas rezultatø faile lentelëmis
	@param fv - failo vardas
	@param G - gamintojø masyvas, kuriame saugomi gamintojø gijø duomenys
	@param V - vartotojø masyvas, kuriame saugomi vartotojø gijø duomenys
*/
void spausdintiDuomenis(string fv, Gamintojas G[], Vartotojas V[]) {
	ofstream R(fv);
	R << string(40, '*') << endl;
	R << "Automobiliø (gamintojø) duomenys" << endl;
	R << string(40, '*') << endl;
	R << string(40, '-') << endl;
	for (int i = 0; i < N; i++) {
		int lineNr = 1;
		R << setw(16) << right << "Pavadinimas" << setw(7) << right << "Metai" << setw(7) << right << "Litrai" << endl;
		R << string(40, '-') << endl;
		for (int j = 0; j < G[i].kiekis; j++) {
			R << setw(3) << right << lineNr++ << left << ")" << setw(12) << right << G[i].D[j].pavadinimas << setw(7) << right << G[i].D[j].metai << setw(7) << right << G[i].D[j].litrai << endl;
		}
		R << string(40, '-') << endl;
	}
	R << string(40, '*') << endl;
	R << "Rikiavimo struktûrø (vartojø) duomenys" << endl;
	R << string(40, '*') << endl;
	R << string(40, '-') << endl;
	for (int i = 0; i < M; i++) {
		int lineNr = 1;
		R << setw(16) << right << "Rik. Laukas" << setw(10) << right << "Kiekis" << endl;
		R << string(40, '-') << endl;
		for (int j = 0; j < V[i].kiekis; j++){
			R << setw(3) << right << lineNr++ << left << ")" << setw(12) << right << V[i].D[j].rikiavimoLaukas << setw(10) << right << V[i].D[j].kiekis << endl;
		}
		R << string(40, '-') << endl;
	}
	R.close();
}

/*
	Gautø rezultatø spausdinimo funkcija
	@param fv - failo vardas
	@param monitorius - Monitoriaus klasës objektas, kuriame saugomas bendras masyvas
*/
void spausdintiRezultatus(string fv, Monitorius *monitorius){
	ofstream R(fv, ios::app);
	R << string(40, '*') << endl;
	R << "Bendras rezultatø masyvas" << endl;
	R << string(40, '*') << endl;
	R << string(40, '-') << endl;
	R << setw(16) << right << "Rik. Laukas" << setw(10) << right << "Kiekis" << endl;
	R << string(40, '-') << endl;
	int lineNr = 1;
	for (int i = 0; i < monitorius->imtiKieki(); i++) {
		R << setw(3) << right << lineNr++ << left << ")" << setw(12) << right << monitorius->imtiBendroMasyvoElementa(i).rikiavimoLaukas << setw(10) << right << monitorius->imtiBendroMasyvoElementa(i).kiekis << endl;
	}
	R << string(40, '-') << endl;
	R.close();
}

/*
	Funkcija, pradedanti lygiagreèiai vykdomø gamintojø ir vartotojø gijø darbà
	@param G - gamintojø gijø duomenø masyvas
	@param V - vartotojø gijø duomenø masyvas
	@param monitorius - monitoriaus klasës objektas
*/
void paleistiGijas(Gamintojas G[], Vartotojas V[], Monitorius *monitorius){
	#pragma omp parallel num_threads(N + M)
	{
		// Gràþinamas gijos identifikacinis numeris nuo 0 iki N+M
		int gijosId = omp_get_thread_num();
		// Kintamasis, reikalingas tinkamai indeksuoti gamintojø ir vartotojø gijas
		int gijosNr = gijosId % N;
		// Kadangi bendrai yra vykdomos N + M gijø, tai priskiriame, kad pirmosios N gijø - gamintojø, likusios - vartotojø
		if (gijosId < N) {
			for (int i = 0; i < G[gijosNr].kiekis; i++) {
				// Gamintojai talpina duomenis á bendrà masyvà
				monitorius->talpinti(G[gijosNr].D[i].metai);
			}
			// Pakeièiama reikðmë, parodanti, kad gamintojas daugiau nebegamina
			monitorius->nustatytiKadNebegamina(gijosNr);
		}
		else {
			bool pabaiga = false;
			while (!pabaiga) {
				/*
				Kintamasis, reikalingas nustatyti, ar vartotojas, atlikæs visas savo norimø
				ðalinti elementø paieðkos iteracijas, kaþkà rado bendrame masyve
				*/
				bool rado = false;
				for (int i = 0; i < V[gijosNr].kiekis; i++) {
					// Ið bendro masyvo ðalinami elementai
					bool istryne = monitorius->salinti(V[gijosNr].D[i]);
					if (istryne)
						rado = true;
				}
				// Jei vartotojas bendrame masyve jau nieko reikalingo neberado ir nebëra gamintojø
				if (!rado && !monitorius->yraGamintojas()){
					for (int i = 0; i < V[gijosNr].kiekis; i++)
						rado = monitorius->salinti(V[gijosNr].D[i]);
					pabaiga = true;
				}
			}
		}
	}
}