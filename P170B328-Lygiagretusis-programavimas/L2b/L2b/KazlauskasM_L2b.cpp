/*
	KazlauskasM_L2b.cpp

	Mangirdas Kazlauskas IFF-4/1
	U�duotis L2b
*/

#include <iostream>
#include <iomanip>
#include <fstream>
#include <string>
#include <omp.h>

using namespace std;

// Fail� vardai
const string DUOMENU_FAILAS = "KazlauskasM_L2_dat_3.txt";
const string REZULTATU_FAILAS = "KazlauskasM_L2_rez.txt";
// Gamintoj� gij� skai�ius
const int N = 5;
// Vartotoj� gij� skai�ius
const int M = 4;
// Maksimalus element� skai�ius masyve
const int C_MAX = 10;
// Maksimalus element� skai�ius bendrame masyve B
const int C_B_MAX = 100;

/*
	Automobilio (gamintojo prek�s) strukt�ra
	pavadinimas - automobilio modelis
	metai - automobilio pagaminimo metai
	litrai - automobilio darbinis variklio t�ris
*/
struct Automobilis {
	string pavadinimas;
	int metai;
	double litrai;
};

/*
	Rikiavimo lauko (vartotojo) strukt�ra
	rikiavimoLaukas - laukas, pagal kur� bus rikiuojama ir �terpiama bendrame masyve
	kiekis - to paties rikiavimoLauko element� kiekis bendrame masyve ar kiekis, kur� nori suvartoti (pasiimti) vartotojas
*/
struct RikiavimoStruktura {
	int rikiavimoLaukas;
	int kiekis;
};

/*
	Gamintojo gijos strukt�ra
	D - Automobili� strukt�r� masyvas
	kiekis - element� skai�ius masyve D
*/
struct Gamintojas {
	Automobilis D[C_MAX];
	int kiekis = 0;
};

/*
	Vartotojo gijos strukt�ra
	D - Rikiavimo str�kt�ros masyvas
	kiekis - element� skai�ius masyve D
*/
struct Vartotojas {
	RikiavimoStruktura D[C_MAX];
	int kiekis = 0;
};

/*
	Monitoriaus klas�, kurioje atliekami visi veiksmai su gijomis
*/
class Monitorius {
private:
	// Bendras masyvas B, � kur� vienu metu talpinami bei i� jo �alinami elementai
	RikiavimoStruktura B[C_B_MAX];
	// Dabartinis esan�i� element� skai�ius bendrame masyve B
	int kiekis = 0;
	// Masyvas, saugantis login� reik�m�, ar i-tasis gamintojas vis dar talpina elementus � bendr� masyv�
	bool gamina[N];

	/*
		Funkcija, reikalinga reikiamai elemento �terpimo vietai bendrame masyve rasti
	*/
	int iterpimoVieta(int elem){
		// Jei masyvas tu��ias - gr��inama pirmoji masyvo vieta (indeksas 0)
		if (kiekis == 0)
			return 0;
		/* 
			Kadangi rikiuojama did�jimo tvarka, tai ie�koma, kol �terpiamas elementas
			yra ma�esnis u� jau esant� masyve, gr��inama rasta vieta
		*/
		for (int i = 0; i < kiekis; i++)
			if (elem <= B[i].rikiavimoLaukas)
				return i;
		// Jei elementas didesnis u� visus, esan�ius bendrame masyve, gr��inama vieta, esanti u� paskutinio elemento
		return kiekis;
	}
public:
	/*
		Monitoriaus konstruktorius
		@param G - gamintoj� gij� masyvas
		@param V - vartotoj� gij� masyvas
	*/
	Monitorius() {
		for (int i = 0; i < N; i++) {
			gamina[i] = true;
		}
	}
	// Destruktorius
	~Monitorius() {}

	/*
		Gr��ina vien� element� i� bendro masyvo (reikalinga rezultat� spausdinimui)
		@param i - elemento indeksas bendrame masyve B
	*/
	RikiavimoStruktura imtiBendroMasyvoElementa(int i) {
		return B[i];
	}

	/*
		Gr��ina element� kiek�, esant� bendrame masyve
	*/
	int imtiKieki() {
		return kiekis;
	}

	/*
		Nustato, jog i-tasis gamintojas baig� darb�
	*/
	void nustatytiKadNebegamina(int i){
		gamina[i] = false;
	}

	/*
	Funkcija, talpinanti elementus � bendr� masyv�
	@param laukas - rikiavimo lauko reik�m�, kuri� norima �terpti � bendr� masyv�
	*/
	void talpinti(int laukas){
		#pragma omp critical
		{
			// Randama �terpimo vieta
			int vieta = iterpimoVieta(laukas);
			// Jei lauko reik�m� sutampa su jau esan�ia masyve, kiekis padidinamas
			if (B[vieta].rikiavimoLaukas == laukas){
				B[vieta].kiekis++;
			}
			// Jei �terpiame kaip pat� pirm� element� � tu��i� masyv� arba � masyvo gal�
			else if (vieta == 0 && kiekis == 0 || vieta == kiekis){
				B[vieta].kiekis = 1;
				B[vieta].rikiavimoLaukas = laukas;
				kiekis++;
			}
			// Kitais atvejais masyve atlaisvinama vieta �terpiamam elementui
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
	Funkcija, i� bendro masyvo �alinanti element�.
	@param elem - norimas pa�alinti elementas
	Gr��ina true, jei element� pavyko pa�alinti arba pavyko rasti element� ir suma�inti jo kiek� masyve
	*/
	bool salinti(RikiavimoStruktura elem){
		while (kiekis == 0 && yraGamintojas()) {}
		bool pasalinta = false;
		#pragma omp critical
		{
			// Bendrame masyve ie�komas norimas elementas
			for (int i = 0; i < kiekis; i++){
				if (B[i].rikiavimoLaukas == elem.rikiavimoLaukas){
					/*
					Jei vartotojas nori pasiimti ma�iau nei yra bendrame masyve,
					bendrame masyve suma�inamas element� kiekis
					*/
					if (elem.kiekis < B[i].kiekis){
						B[i].kiekis -= elem.kiekis;
					}
					/*
					Jei vartotojas nori pasiimti daugiau arba tiek, kiek yra
					bendrame masyve - elementas i� bendro masyvo �alinamas
					*/
					else{
						/*
						Jei �alinamas pirmasis elementas, kai bendr� masyv� sudaro vienas elementas
						arba �alinamas paskutinis elementas
						*/
						if (i == 0 && kiekis == 1 || i == kiekis - 1)
							kiekis--;
						/*
						Kitu atveju, kai elementas �alinamas i� masyvo vidurio
						*/
						else{
							for (int j = i; j < kiekis - 1; j++)
								B[j] = B[j + 1];
							kiekis--;
						}
					}
					// Buvo ka�kas pa�alinta
					pasalinta = true;
				}
			}	
		}
		// Jei ka�kas buvo pa�alinta ar pama�intas kiekis, gr��inamas true, kitu atveju - false
		if (pasalinta)
			return true;
		else
			return false;
	}

	/*
	Funkcija, gr��inanti true, jei vis dar yra gaminan�i� gamintoj�.
	Jei visi gamintojai baig� darb� - false
	*/
	bool yraGamintojas(){
		for (int i = 0; i < N; i++)
			if (gamina[i])
				return true;
		return false;
	}
};

/*
	Funkcij� prototipai
*/
void skaitytiDuomenis(string fv, Gamintojas G[], Vartotojas V[]);
void spausdintiDuomenis(string fv, Gamintojas G[], Vartotojas V[]);
void spausdintiRezultatus(string fv, Monitorius *monitorius);
void paleistiGijas(Gamintojas G[], Vartotojas V[], Monitorius *monitorius);

/*
	Pagrindin� programos funkcija (master gija)
*/
int main() {
	// Masyvai, kuriuose saugoma gamintoj� ir vartotoj� gij� informacija
	Gamintojas G[N];
	Vartotojas V[M];

	// Duomen� skaitymas bei �ra�ymas � rezultat� fail�
	skaitytiDuomenis(DUOMENU_FAILAS, G, V);
	spausdintiDuomenis(REZULTATU_FAILAS, G, V);

	// Monitoriaus suk�rimas bei gij� paleidimas
	Monitorius *monitorius = new Monitorius();

	// Pradedamas gij� darbas
	paleistiGijas(G, V, monitorius);

	// Gaut� rezultat� spausdinimas
	spausdintiRezultatus(REZULTATU_FAILAS, monitorius);

	// Atlaisvinama atmintis
	delete(monitorius);
	return 0;
}

/*
	Duomen� skaitymo i� failo funkcija
	@param fv - failo vardas
	@param G - gamintoj� masyvas, kuriame bus i�saugotos nuskaitytos reik�m�s
	@param V - vartotoj� masyvas, kuriame bus i�saugotos nuskaitytos reik�m�s
*/
void skaitytiDuomenis(string fv, Gamintojas G[], Vartotojas V[]) {
	ifstream F(fv);
	/*
	Gamintojo duomen� nuskaitymas
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
	Pradini� duomen� spausdinimas rezultat� faile lentel�mis
	@param fv - failo vardas
	@param G - gamintoj� masyvas, kuriame saugomi gamintoj� gij� duomenys
	@param V - vartotoj� masyvas, kuriame saugomi vartotoj� gij� duomenys
*/
void spausdintiDuomenis(string fv, Gamintojas G[], Vartotojas V[]) {
	ofstream R(fv);
	R << string(40, '*') << endl;
	R << "Automobili� (gamintoj�) duomenys" << endl;
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
	R << "Rikiavimo strukt�r� (vartoj�) duomenys" << endl;
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
	Gaut� rezultat� spausdinimo funkcija
	@param fv - failo vardas
	@param monitorius - Monitoriaus klas�s objektas, kuriame saugomas bendras masyvas
*/
void spausdintiRezultatus(string fv, Monitorius *monitorius){
	ofstream R(fv, ios::app);
	R << string(40, '*') << endl;
	R << "Bendras rezultat� masyvas" << endl;
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
	Funkcija, pradedanti lygiagre�iai vykdom� gamintoj� ir vartotoj� gij� darb�
	@param G - gamintoj� gij� duomen� masyvas
	@param V - vartotoj� gij� duomen� masyvas
	@param monitorius - monitoriaus klas�s objektas
*/
void paleistiGijas(Gamintojas G[], Vartotojas V[], Monitorius *monitorius){
	#pragma omp parallel num_threads(N + M)
	{
		// Gr��inamas gijos identifikacinis numeris nuo 0 iki N+M
		int gijosId = omp_get_thread_num();
		// Kintamasis, reikalingas tinkamai indeksuoti gamintoj� ir vartotoj� gijas
		int gijosNr = gijosId % N;
		// Kadangi bendrai yra vykdomos N + M gij�, tai priskiriame, kad pirmosios N gij� - gamintoj�, likusios - vartotoj�
		if (gijosId < N) {
			for (int i = 0; i < G[gijosNr].kiekis; i++) {
				// Gamintojai talpina duomenis � bendr� masyv�
				monitorius->talpinti(G[gijosNr].D[i].metai);
			}
			// Pakei�iama reik�m�, parodanti, kad gamintojas daugiau nebegamina
			monitorius->nustatytiKadNebegamina(gijosNr);
		}
		else {
			bool pabaiga = false;
			while (!pabaiga) {
				/*
				Kintamasis, reikalingas nustatyti, ar vartotojas, atlik�s visas savo norim�
				�alinti element� paie�kos iteracijas, ka�k� rado bendrame masyve
				*/
				bool rado = false;
				for (int i = 0; i < V[gijosNr].kiekis; i++) {
					// I� bendro masyvo �alinami elementai
					bool istryne = monitorius->salinti(V[gijosNr].D[i]);
					if (istryne)
						rado = true;
				}
				// Jei vartotojas bendrame masyve jau nieko reikalingo neberado ir neb�ra gamintoj�
				if (!rado && !monitorius->yraGamintojas()){
					for (int i = 0; i < V[gijosNr].kiekis; i++)
						rado = monitorius->salinti(V[gijosNr].D[i]);
					pabaiga = true;
				}
			}
		}
	}
}