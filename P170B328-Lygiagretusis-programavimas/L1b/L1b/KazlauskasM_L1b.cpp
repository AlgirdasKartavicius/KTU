/*
Laboratorinio darbo u�duotis: L1b
Mangirdas Kazlauskas IFF-4/1 
Atsakymai � klausimus:
1) Visi vienu metu (tokio atsakymo varianto n�ra, bet pagal teorij� yra taip)
2) Atsitiktine
3) Vienos dal�
4) Atsitiktine
*/
#include <iostream>
#include <fstream>
#include <iomanip>
#include <thread>
#include <string>
#include <omp.h>

using namespace std;

// konstanta, sauganti nuskaitom� element� bei kuriam� gij� skai�i�
const int n = 19;

// strukt�ra, skirta rezultat� strukt�rai (gijos id bei duomen� rinkinio informacijai) saugoti
struct Rez 
{
	int id;
	string pav;
	int metai;
	double v;
};

/*
Duomen� rinkinio skaitymo funkcija
@param S - masyvas, saugantis automobili� pavadinimus
@param I - masyvas, saugantis automobili� pagaminimo metus
@param D - masyvas, saugantis automobili� variklio t�ri� reik�mes
*/
void Skaityti(string S[], int I[], double D[]);
/*
Duomen� spausdinimo funkcija
@param S - masyvas, saugantis automobili� pavadinimus
@param I - masyvas, saugantis automobili� pagaminimo metus
@param D - masyvas, saugantis automobili� variklio t�ri� reik�mes
*/
void SpausdintiDuom(string S[], int I[], double D[]);
/*
Rezultat� spausdinimo funkcija
@param P - rezultat� strukt�r� maasyvas
*/
void SpausdintiRez(Rez P[]);

int main() {
	setlocale(LC_ALL, "Lithuanian");
	string S[n];
	int I[n];
	double D[n];
	Rez P[n];
	Skaityti(S, I, D);
	SpausdintiDuom(S, I, D);
	int i = 0;
	// sukuriama n gij�, � galutin� masyv� informacij� �ra�ant � masyvo pabaig�
	#pragma omp parallel num_threads(n)
	{
		int nr = omp_get_thread_num();
		Rez R;
		R.id = nr;
		R.pav = S[nr];
		// Papildomas darbas
		for (int j = 0; j < (nr + 1) * 10000; j++) {
			int x = sqrt(j);
		}
		R.metai = I[nr];
		R.v = D[nr];
		P[i++] = R;
	}
	SpausdintiRez(P);
	return 0;
}

void Skaityti(string S[], int I[], double D[]) 
{
	ifstream F("KazlauskasM_L1b_dat.txt");
	for (int i = 0; i < n; i++)
		F >> S[i] >> I[i] >> D[i];
	F.close();
}

void SpausdintiDuom(string S[], int I[], double D[]) 
{
	ofstream R("KazlauskasM_L1b_rez.txt");
	R << "Duomen� rinkinys" << endl;
	R << string(40, '-') << endl;
	R << setw(11) << right << "Modelis" << setw(7) << right << "Metai" << setw(15) << right << "Variklio t�ris" << endl;
	for (int i = 0; i < n; i++)
		R << setw(4) << left << to_string(i + 1) + ")" << setw(10) << left << S[i] << setw(7) << I[i] << D[i] << endl;
	R << string(40, '-') << endl;
	R.close();
}

void SpausdintiRez(Rez P[]) {
	ofstream R("KazlauskasM_L1b_rez.txt", ios::app);
	R << setw(11) << right << "Gijos nr." << setw(8) << right << "Modelis" << setw(7) << right << "Metai" << setw(15) << right << "Variklio t�ris" << endl;
	for (int i = 0; i < n; i++) {
		R << setw(6) << left << to_string(i + 1) + ")" << setw(6) << left << P[i].id << setw(10) << left << P[i].pav << setw(7) << P[i].metai << P[i].v << endl;
	}
	R << string(40, '-') << endl;
	R.close();
}