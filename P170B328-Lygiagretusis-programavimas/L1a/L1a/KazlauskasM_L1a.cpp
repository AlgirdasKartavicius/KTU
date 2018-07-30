/*
Laboratorinio darbo uþduotis: L1a
Mangirdas Kazlauskas IFF-4/1
Atsakymai á klausimus:
1) Tokia, kokia uþraðyti
2) Atsitiktine
3) Atsitiktiná skaièiø
4) Tokia, kokia suraðyti duomenø masyve
*/
#include <iostream>
#include <fstream>
#include <string>
#include <iomanip>
#include <thread>

using namespace std;

// globalus kintamasis, kad gijos galëtø pasiekti rezultatø masyvo paskutinio elemento indeksà
int arr_size;

// struktûra, sauganti nuskaitomus duomenis
struct Automobilis {
	string modelis;
	int metai;
	double turis;
};

// struktûra, sauganti informacijà apie automobilio kategorijà (markæ) bei elementø kieká viename duomenø rinkinyje
struct Info {
	string marke;
	int kiekis;
};

// struktûra, skirta galutiniam rezultatø spausdinimui bei informacijos saugojimui
struct Rezultatai{
	string pav;
	int nr;
	string modelis;
	int metai;
	double turis;
};

/*
Duomenø skaitymo funkcija
@param P1, P2, P3, P4, P5 - duomenø rinkiniø masyvai
@param I - automobilio kategorijos (markës) informacijos masyvas
*/
void Skaityti(Automobilis P1[], Automobilis P2[], Automobilis P3[], Automobilis P4[], Automobilis P5[], Info I[]);
/*
Duomenø raðymo funkcija
@param P1, P2, P3, P4, P5 - duomenø rinkiniø struktûrø masyvai
@param I - automobilio kategorijø (markiø) informacijos struktûrø masyvas
*/
void RasytiDuom(Automobilis P1[], Automobilis P2[], Automobilis P3[], Automobilis P4[], Automobilis P5[], Info I[]);
/*
Rezultatø raðymo funkcija
@param P - rezultatø struktûrø masyvas
*/
void RasytiRez(Rezultatai P[]);
/*
Gijai paduodama funkcija, pildanti rezultatø masyvà
@param P - rezultatø struktûrø masyvas
@param Pk - vienodos markës automobiliø struktûrø masyvas
@param n - vienodos markës automobiliø skaièius masyve Pk
@param gija - vykdomos gijos pavadinimas
*/
void Pildyti(Rezultatai P[], Automobilis Pk[], int n, string gija);

int main() {
	Automobilis P1[9], P2[9], P3[9], P4[9], P5[9];
	Info I[5];
	Rezultatai P[45];
	arr_size = 0; // galutinio rezultatø masyvo paskutinio elemento indeksas nustatomas á pirmàjá elementà
	Skaityti(P1, P2, P3, P4, P5, I);
	RasytiDuom(P1, P2, P3, P4, P5, I);
	thread gija_1(Pildyti, P, P1, I[0].kiekis, "gija_1");
	thread gija_2(Pildyti, P, P2, I[1].kiekis, "gija_2");
	thread gija_3(Pildyti, P, P3, I[2].kiekis, "gija_3");
	thread gija_4(Pildyti, P, P4, I[3].kiekis, "gija_4");
	thread gija_5(Pildyti, P, P5, I[4].kiekis, "gija_5");
	gija_1.join();
	gija_2.join();
	gija_3.join();
	gija_4.join();
	gija_5.join();
	RasytiRez(P);
	return 0;
}

void Skaityti(Automobilis P1[], Automobilis P2[], Automobilis P3[], Automobilis P4[], Automobilis P5[], Info I[]) {
	ifstream F("KazlauskasM_L1a_dat.txt");
	for (int i = 0; i < 5; i++) {
		string marke;
		int kiekis;
		Info inf;
		F >> marke >> kiekis;
		//F.ignore();
		inf.marke = marke;
		inf.kiekis = kiekis;
		I[i] = inf;
		switch (i) {
			case 0:
				for (int j = 0; j < kiekis; j++) {
					string mod;
					int m;
					double v;
					Automobilis a;
					F >> mod >> m >> v;
					a.modelis = mod;
					a.metai = m;
					a.turis = v;
					P1[j] = a;
				}
				break;
			case 1:
				for (int j = 0; j < kiekis; j++) {
					string mod;
					int m;
					double v;
					Automobilis a;
					F >> mod >> m >> v;
					a.modelis = mod;
					a.metai = m;
					a.turis = v;
					P2[j] = a;
				}
				break;
			case 2:
				for (int j = 0; j < kiekis; j++) {
					string mod;
					int m;
					double v;
					Automobilis a;
					F >> mod >> m >> v;
					a.modelis = mod;
					a.metai = m;
					a.turis = v;
					P3[j] = a;
				}
				break;
			case 3:
				for (int j = 0; j < kiekis; j++) {
					string mod;
					int m;
					double v;
					Automobilis a;
					F >> mod >> m >> v;
					a.modelis = mod;
					a.metai = m;
					a.turis = v;
					P4[j] = a;
				}
				break;
			case 4:
				for (int j = 0; j < kiekis; j++) {
					string mod;
					int m;
					double v;
					Automobilis a;
					F >> mod >> m >> v;
					a.modelis = mod;
					a.metai = m;
					a.turis = v;
					P5[j] = a;
				}
		}
	}
	F.close();
}
void RasytiDuom(Automobilis P1[], Automobilis P2[], Automobilis P3[], Automobilis P4[], Automobilis P5[], Info I[]) {
	ofstream R("KazlauskasM_L1a_rez.txt");
	for (int i = 0; i < 5; i++) {
		R << "*** " << I[i].marke << " ***" << endl;
		R << setw(10) << right << "Modelis" << setw(7) << right << "Metai" << setw(15) << right << "Variklio tûris" << endl;
		for (int j = 0; j < I[i].kiekis; j++) {
			switch (i) {
				case 0:
					R << setw(1) << to_string(j+1) + ") " << setw(10) << left << P1[j].modelis << setw(7) << P1[j].metai << P1[j].turis << endl;
					break;
				case 1:
					R << setw(1) << to_string(j+1) + ") " << setw(10) << left << P2[j].modelis << setw(7) << P2[j].metai << P2[j].turis << endl;
					break;
				case 2:
					R << setw(1) << to_string(j+1) + ") " << setw(10) << left << P3[j].modelis << setw(7) << P3[j].metai << P3[j].turis << endl;
					break;
				case 3:
					R << setw(1) << to_string(j+1) + ") " << setw(10) << left << P4[j].modelis << setw(7) << P4[j].metai << P4[j].turis << endl;
					break;
				case 4:
					R << setw(1) << to_string(j+1) + ") " << setw(10) << left << P5[j].modelis << setw(7) << P5[j].metai << P5[j].turis << endl;
			}
			
		}
	}
	R << string(40, '-') << endl;
	R.close();
}
void RasytiRez(Rezultatai P[]){
	ofstream R("KazlauskasM_L1a_rez.txt", ios::app);
	for (int i = 0; i < arr_size; i++) {
		R << P[i].pav << " " << P[i].nr << " " << setw(20) << left << P[i].modelis << 
			setw(5) << left << P[i].metai << setw(4) << left << P[i].turis << endl;
	}
	R << endl << "Pabaiga";
	R.close();
}
void Pildyti(Rezultatai P[], Automobilis Pk[], int n, string gija){
	int i = 0;
	Rezultatai R;
	while (i < n) {
		R.metai = Pk[i].metai;
		R.modelis = Pk[i].modelis;
		R.turis = Pk[i++].turis;
		R.nr = i;
		R.pav = gija;
		P[arr_size++] = R;
		for (int j = 0; j < 10000; j++) {
			double k = sqrt(j);
		}
	}
}