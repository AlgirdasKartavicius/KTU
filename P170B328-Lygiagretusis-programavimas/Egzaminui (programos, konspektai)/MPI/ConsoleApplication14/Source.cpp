/**
* Lygiagretus programavimas
* III laboratorinis darbas II dalis
* Lukas Skamarakas
*/
#include <iostream>
#include <mpi.h>
#include <fstream>
#include <algorithm>
#include <iomanip>
#include <cmath>
#include <string>
using namespace std;

const char duomenuFailas[] = "SkamarakasL_L3_3.txt";		// Duomenu failo vardas
const char rezultatuFailas[] = "SkamarakasL_L3a_rez.txt";	// Rezultatu failo vardas
const int maksimalusStudentuSkaiciusFakultete = 100;		// Maksimalus Studentu Skaicius Fakultete
const int maksimalusFakultetuSkaicius = 100;				// Maksimalus Fakultetu Skaicius
const int maksimalusGijuElementuSkaicius = 100;				// Maksimalus Giju Elementu Skaicius
const int RASYMO_GIJA_DARBA_BAIGE_TAG = 1;					// Rasyma baigusios gijos zyme
const int RASYMO_PABAIGA_TAG = 4;							// Rasymo pabaigos zyme
const int RASYTI_TAG = 2;									// Rasymo zyme
const int SKAITYTI_TAG = 3;									// Skaitymo zyme
const int SKAITYMO_PABAIGA_TAG = 5;							// Skaitymo pabaigos zyme
const int PABAIGA_TAG = 6;									// Darbo pabaigos zyme
const int SKAITYMO_PROCESU_SKAICIUS = 5;					// Skaitymo procesu skaicius
const int RASYMO_PROCESU_SKAICIUS = 5;						// Rasymo procesu skaicius
const int maksimalusSimboliuSkaiciusEiluteje = 20;

struct Studentas		// Studento duomenu struktura
{
	char vardas[maksimalusSimboliuSkaiciusEiluteje];		// Studento vardas
	int kursas;			// Studento kursas
	double vidurkis;	// Studento vidurkis
};

struct Fakultetas												// Fakulteto duomenu struktura
{
	char pavadinimas[maksimalusSimboliuSkaiciusEiluteje];		// Fakulteto pavadinimas
	int studentuSkaicius;										// Studentu skaicius
	Studentas studentai[maksimalusStudentuSkaiciusFakultete];	// Studentu masyvas
};

struct GijuMasyvoElementas	// Bendro masyvo elementas
{
	int kiekis;				// Elemento kiekis
	char vardas[maksimalusSimboliuSkaiciusEiluteje];			// Rikiuoja masyvo reiksmë
	int procesoNr;			// Proceso numeris
};
struct Vardas				// Rikiuojamo elemento duomenu struktura
{
	char vardas[maksimalusSimboliuSkaiciusEiluteje];			// Rikiuojamo elemento reiksme
	int kiekis;				// Rikiuojamo elemento kiekis
};

struct Vardai									// Rikiuojamu elementu duomenu struktura
{
	Vardas vardai[maksimalusFakultetuSkaicius];	// Rikiuojamu elementu masyvas
	int kiekis;									// Rikiuojamu elementu kiekis
};

/**
 *	Metodas grazinantis studento duomenis ir sumazinantis studentu skaiciu fakultete. 
 */
Studentas imtiStudenta(Fakultetas &fakultetas);

/*
 *  Metodas rikiuojanti fakulteto stuedntus
 */
void rikiuotiFakultetoStudentus(Fakultetas &fakultetas);

/*
 *  Metodas sumazinantis rikiuojamo elemento kieki.
 */
void mazintiVardoKieki(Vardas &vardas);

/*
 *  Metodas sumazinantis rikiuojamu elementu kieki.
 */
int mazintiVarduKieki(Vardai &vardai, int nr);

/*
 * Duomenu skaitymo metodas.
 */
void Skaityti(const char duomenuFailas[], int &fakultetuSkaicius, int &varduMasyvuSkaicius, Vardai vardai[], Fakultetas fakultetai[]);

/*
 *  Metodas spausdinantis fakultetu duomenis. 
 */
void SpausdintiFakultetus(const char duomenuFailas[], Fakultetas fakultetas);

/*
 *  Metodas spausdinantis bendro procesu masyvo duomenis. 
 */
void SpausdintiGijuMasyva(const char duomenuFailas[], GijuMasyvoElementas bendrasGijuMasyvas[], int elementuSkaiciusBendramGijuMasyve);

/*
 * Metodas spausdinantis rikiuojamu elementu duomenis.
 */
void SpausdintiVardus(const char duomenuFailas[], Vardai vardai);

/*
 *  Metodas grazinantis iterpiamo elemento vieta bendram masyve.
 */
int rastiIterpimoVietaBendramGijuMasyve(GijuMasyvoElementas bendrasGijuMasyvas[], GijuMasyvoElementas elementas, int elementuSkaiciusBendramGijuMasyve);

/*
 *  Metodas iterpiantis elementa i bendra giju masyva.
 */
int iterptiElemetaBendramGijuMasyve(GijuMasyvoElementas bendrasGijuMasyvas[], GijuMasyvoElementas elementas, int &elementuSkaiciusBendramGijuMasyve);

/*
 *  Metodas grazinantis elemento vieta bendram masyve.
 */
int rastiElementoVietaBendramGijuMasyve(GijuMasyvoElementas bendrasGijuMasyvas[], GijuMasyvoElementas elementas, int elementuSkaiciusBendramGijuMasyve);

/*
 *  Metodas salinantis elementa is bendro giju masyvo.
 */
int imtiElementaIsBendroGijuMasyvo(GijuMasyvoElementas bendrasGijuMasyvas[], GijuMasyvoElementas elementas, int &elementuSkaiciusBendramGijuMasyve);

int vykdytiPagrindiniProcesa(int world_rank, MPI_Comm pagr_komunikatoriai[]);

int vykdytiValdymoProcesa(int world_rank, MPI_Comm pagr_komunikatoriai[], MPI_Comm vald_komunikatoriai[]);

int vykdytiRasymoProcesa(int world_rank, MPI_Comm pagr_komunikatorius, MPI_Comm vald_komunikatorius);

int vykdytiRasymoProcesa(int world_rank, MPI_Comm pagr_komunikatorius, MPI_Comm vald_komunikatorius);

int vykdytiSkaitymoProcesa(int world_rank, MPI_Comm pagr_komunikatorius, MPI_Comm vald_komunikatorius);

int main(int argc, char *argv[])
{
	MPI_Init(&argc, &argv);
	int fakultetuSkaicius = 0;
	Vardai vardai[maksimalusFakultetuSkaicius];
	GijuMasyvoElementas bendrasGijuMasyvas[maksimalusGijuElementuSkaicius];
    int world_rank;
    MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);
	MPI_Group world_group;
	MPI_Comm_group(MPI_COMM_WORLD, &world_group);
	int ranks[2]; ranks[0]=0; ranks[1]=0;
	MPI_Group pagr_proc_grupes[RASYMO_PROCESU_SKAICIUS+SKAITYMO_PROCESU_SKAICIUS+1];
	for(int i = 0; i < RASYMO_PROCESU_SKAICIUS+SKAITYMO_PROCESU_SKAICIUS+1; i++){
		ranks[1]=i+1;
		MPI_Group_incl(world_group, 2, ranks, &pagr_proc_grupes[i]);
	}
	MPI_Comm pagr_komunikatoriai[1+RASYMO_PROCESU_SKAICIUS+SKAITYMO_PROCESU_SKAICIUS];
	for(int i = 0; i < 1+RASYMO_PROCESU_SKAICIUS+SKAITYMO_PROCESU_SKAICIUS; i++){
		if (pagr_proc_grupes[i] != MPI_GROUP_NULL) {
			MPI_Comm_create(MPI_COMM_WORLD, pagr_proc_grupes[i], &pagr_komunikatoriai[i]);
		}
	}
	ranks[0]=1+RASYMO_PROCESU_SKAICIUS+SKAITYMO_PROCESU_SKAICIUS;
	ranks[1]=0;
	MPI_Group vald_proc_grupes[RASYMO_PROCESU_SKAICIUS+SKAITYMO_PROCESU_SKAICIUS];
	for(int i = 0; i < RASYMO_PROCESU_SKAICIUS+SKAITYMO_PROCESU_SKAICIUS; i++){
		ranks[1] ++;
		MPI_Group_incl(world_group, 2, ranks, &vald_proc_grupes[i]);
	}
	MPI_Comm vald_komunikatoriai[RASYMO_PROCESU_SKAICIUS+SKAITYMO_PROCESU_SKAICIUS];
	for(int i = 0; i < RASYMO_PROCESU_SKAICIUS+SKAITYMO_PROCESU_SKAICIUS; i++){
		if (vald_proc_grupes[i] != MPI_GROUP_NULL) {
			MPI_Comm_create(MPI_COMM_WORLD, vald_proc_grupes[i], &vald_komunikatoriai[i]);
		}
	}

	if(world_rank == 0){
		vykdytiPagrindiniProcesa(world_rank, pagr_komunikatoriai);
	} else if (world_rank > 0 && world_rank <= 5) {
		vykdytiRasymoProcesa(world_rank, pagr_komunikatoriai[world_rank-1], vald_komunikatoriai[world_rank-1]);
	} else if (world_rank > 5 && world_rank <= 10) {
		vykdytiSkaitymoProcesa(world_rank, pagr_komunikatoriai[world_rank-1], vald_komunikatoriai[world_rank-1]);
	} else {
		vykdytiValdymoProcesa(world_rank, pagr_komunikatoriai, vald_komunikatoriai);
		cout << "********************************VALDYTOJAS EXIT*************************"<< endl;
	}
	

	return 0;
}int vykdytiSkaitymoProcesa(int world_rank, MPI_Comm pagr_komunikatorius, MPI_Comm vald_komunikatorius){	MPI_Status status;
	int fakultetuSkaicius;
	int varduMasyvuSkaicius;
	char *r = new char[sizeof(Vardai)];
	MPI_Recv(r, sizeof(Vardai), MPI_CHAR, 0, 1, pagr_komunikatorius, &status);
	Vardai *V = (Vardai *)r;
	MPI_Recv(&fakultetuSkaicius, 1, MPI_INT, 0, 1, pagr_komunikatorius, &status);
	MPI_Recv(&varduMasyvuSkaicius, 1, MPI_INT, 0, 1, pagr_komunikatorius, &status);
	int vardoNr;
	int elementasPasalintas;
	int rasymasBaigesi;
	int skaitymoPabaiga = 1;
	Vardas vardas;
	int rasymasbaigesi = 0;
	MPI_Request req;
	MPI_Irecv(&rasymasbaigesi, 1, MPI_INT, 0, RASYMO_PABAIGA_TAG, pagr_komunikatorius, &req);
	while(V->kiekis > 0){
		int niekoNepakeista = 0;
		for(int i=0; i<V->kiekis; i++)
		{
			vardas = V->vardai[i];
			GijuMasyvoElementas gijuMasyvoElementas;
			gijuMasyvoElementas.procesoNr = world_rank;
			gijuMasyvoElementas.kiekis = 1;
			strcpy_s(gijuMasyvoElementas.vardas, vardas.vardas);
			MPI_Send((char *) &gijuMasyvoElementas, sizeof(GijuMasyvoElementas), MPI_CHAR, 0, SKAITYTI_TAG, vald_komunikatorius);
			MPI_Recv(&elementasPasalintas, 1, MPI_INT, 0, SKAITYTI_TAG, vald_komunikatorius, &status);
			if(elementasPasalintas != -1) {
				mazintiVarduKieki(*V, i);
				niekoNepakeista = 0;
			} else {
				if(rasymasbaigesi == 1) {
					niekoNepakeista ++;
					if(niekoNepakeista >= V->kiekis) {
						V->kiekis = 0;
					}
				}
			}
		}
	}
	
	MPI_Send(&skaitymoPabaiga, 1, MPI_INT, 0, SKAITYMO_PABAIGA_TAG, pagr_komunikatorius);
	cout << "SKAITYMAS EXIT NR: " << world_rank << endl;	MPI_Finalize();	return 0;}int vykdytiRasymoProcesa(int world_rank, MPI_Comm pagr_komunikatorius, MPI_Comm vald_komunikatorius){	MPI_Status status;
	int fakultetuSkaicius;
	int varduMasyvuSkaicius;
	cout << "RASYMAS NR: " << world_rank << " PRASIDEDA"<< endl;
	char *r = new char[sizeof(Fakultetas)];
	MPI_Recv(r, sizeof(Fakultetas), MPI_CHAR, 0, 1, pagr_komunikatorius, &status);
	Fakultetas *F = (Fakultetas *)r;
	MPI_Recv(&fakultetuSkaicius, 1, MPI_INT, 0, 1, pagr_komunikatorius, &status);
	MPI_Recv(&varduMasyvuSkaicius, 1, MPI_INT, 0, 1, pagr_komunikatorius, &status);
	Studentas studentas;
	int rasymoPabaiga = 1;
	int elementasIterptas;
	while(F->studentuSkaicius > 0) {
		GijuMasyvoElementas gijuMasyvoElementas;
		gijuMasyvoElementas.kiekis = 1;
		gijuMasyvoElementas.procesoNr = world_rank;
		studentas = F->studentai[0];
		strcpy_s(gijuMasyvoElementas.vardas, studentas.vardas);
		cout << "RASYMAS NR: " << world_rank << " SENDING"<< endl;
		MPI_Send((char *) &gijuMasyvoElementas, sizeof(GijuMasyvoElementas), MPI_CHAR, 0, RASYTI_TAG, vald_komunikatorius);
		cout << "RASYMAS NR: " << world_rank << " SEND"<< endl;
		MPI_Recv(&elementasIterptas, 1, MPI_INT, 0, RASYTI_TAG, vald_komunikatorius, &status);
		cout << "RASYMAS NR: " << world_rank << " GET STATUS: "<< elementasIterptas << endl;
		if(elementasIterptas == 0){
			imtiStudenta(*F);
		}
	}
	
	MPI_Send(&rasymoPabaiga, 1, MPI_INT, 0, RASYMO_GIJA_DARBA_BAIGE_TAG, pagr_komunikatorius);
	cout << "RASYMAS EXIT NR: " << world_rank << endl;	MPI_Finalize();	return 0;}int vykdytiValdymoProcesa(int world_rank, MPI_Comm pagr_komunikatoriai[], MPI_Comm vald_komunikatoriai[]){	GijuMasyvoElementas bendrasGijuMasyvas[1000];
	bool vykdytiProcesa = 0;
	int nr, elementuSkaiciusBendramGijuMasyve = 0;
	MPI_Status stat;
	MPI_Request req[RASYMO_PROCESU_SKAICIUS+SKAITYMO_PROCESU_SKAICIUS+1];
	string R[RASYMO_PROCESU_SKAICIUS+SKAITYMO_PROCESU_SKAICIUS+1];
	char *r = new char[sizeof(GijuMasyvoElementas)];
	GijuMasyvoElementas *G = NULL ;
	for (int i = 0; i < (RASYMO_PROCESU_SKAICIUS+SKAITYMO_PROCESU_SKAICIUS); i++)
	{
		R[i] = new char[sizeof(GijuMasyvoElementas)];
		MPI_Irecv(&R[i], sizeof(GijuMasyvoElementas), MPI_CHAR, MPI_ANY_SOURCE, MPI_ANY_TAG, vald_komunikatoriai[i], &req[i]);
	}
	R[RASYMO_PROCESU_SKAICIUS+SKAITYMO_PROCESU_SKAICIUS] = new char[sizeof(GijuMasyvoElementas)];
	MPI_Irecv(&R[RASYMO_PROCESU_SKAICIUS+SKAITYMO_PROCESU_SKAICIUS], sizeof(GijuMasyvoElementas), MPI_CHAR, MPI_ANY_SOURCE, MPI_ANY_TAG, pagr_komunikatoriai[RASYMO_PROCESU_SKAICIUS+SKAITYMO_PROCESU_SKAICIUS], &req[RASYMO_PROCESU_SKAICIUS+SKAITYMO_PROCESU_SKAICIUS]);
	int flag;
	while(true){
		cout << "WAITING.......................................1" << endl;
		MPI_Waitany(RASYMO_PROCESU_SKAICIUS+SKAITYMO_PROCESU_SKAICIUS+1, req, &nr, &stat);
		cout << "WAITING.......................................2" << endl;
		G = (GijuMasyvoElementas *)&R[nr];
		if(stat.MPI_TAG == RASYTI_TAG)
		{
			cout << "Raso " << G->vardas << endl; 
			int elementasIterptas = iterptiElemetaBendramGijuMasyve(bendrasGijuMasyvas, *G, elementuSkaiciusBendramGijuMasyve);
			cout << "Busena " << elementasIterptas << endl; 
			MPI_Send(&elementasIterptas, 1, MPI_INT, 1, RASYTI_TAG, vald_komunikatoriai[nr]);
			MPI_Irecv(&R[nr], sizeof(GijuMasyvoElementas), MPI_CHAR, MPI_ANY_SOURCE, MPI_ANY_TAG, vald_komunikatoriai[nr], &req[nr]);
		}
		else if(stat.MPI_TAG == SKAITYTI_TAG)
		{
			cout << "Skaito " << G->vardas << endl; 
			int elementasPasalintas;
			elementasPasalintas =  imtiElementaIsBendroGijuMasyvo(bendrasGijuMasyvas, *G, elementuSkaiciusBendramGijuMasyve);
			cout << "Busena " << elementasPasalintas << endl; 
			MPI_Send(&elementasPasalintas, 1, MPI_INT, 1, SKAITYTI_TAG, vald_komunikatoriai[nr]);
			MPI_Irecv(&R[nr], sizeof(GijuMasyvoElementas), MPI_CHAR, MPI_ANY_SOURCE, MPI_ANY_TAG, vald_komunikatoriai[nr], &req[nr]);
		}
		else if(stat.MPI_TAG == PABAIGA_TAG)
		{
			break;
		}
		cout << "DONE! NR: " << nr << "    " << G->procesoNr << endl; 
	}
	cout << "**************************************************************************************" << endl;
	MPI_Send((char *) &bendrasGijuMasyvas, sizeof(GijuMasyvoElementas)*100, MPI_CHAR, 0, PABAIGA_TAG, pagr_komunikatoriai[RASYMO_PROCESU_SKAICIUS+SKAITYMO_PROCESU_SKAICIUS]);
	MPI_Send(&elementuSkaiciusBendramGijuMasyve, 1, MPI_INT, 0, PABAIGA_TAG, pagr_komunikatoriai[RASYMO_PROCESU_SKAICIUS+SKAITYMO_PROCESU_SKAICIUS]);
	
	MPI_Comm_free(&pagr_komunikatoriai[RASYMO_PROCESU_SKAICIUS+SKAITYMO_PROCESU_SKAICIUS]);
	cout << "VALDYTOJAS EXIT NR: " << world_rank << endl;
	MPI_Finalize();
	return 0;}int vykdytiPagrindiniProcesa(int world_rank, MPI_Comm pagr_komunikatoriai[]){	int rasymoGijaDarbaBaige;
	char *r = NULL;
	int skaitymoGijaDarbaBaige;
	MPI_Request req[SKAITYMO_PROCESU_SKAICIUS];
	MPI_Status stat[SKAITYMO_PROCESU_SKAICIUS];
	int fakultetuSkaicius = 0, varduMasyvuSkaicius = 0,
		elementuSkaiciusBendramGijuMasyve = 0;
	Fakultetas fakultetai[maksimalusFakultetuSkaicius];
	Vardai vardai[maksimalusFakultetuSkaicius];
	GijuMasyvoElementas bendrasGijuMasyvas[maksimalusGijuElementuSkaicius];
	Skaityti(duomenuFailas, fakultetuSkaicius, varduMasyvuSkaicius, vardai, fakultetai);
	ofstream fr(rezultatuFailas);
	fr.close();
	for(int i = 0; i < fakultetuSkaicius; i ++){
		rikiuotiFakultetoStudentus(fakultetai[i]);
		SpausdintiFakultetus(rezultatuFailas, fakultetai[i]);
	}
	for(int i = 0; i < varduMasyvuSkaicius; i ++){
		SpausdintiVardus(rezultatuFailas, vardai[i]);
	}
	for(int i = 1; i <= fakultetuSkaicius; i ++){
		MPI_Send((char *) &fakultetai[i-1], sizeof(Fakultetas), MPI_CHAR, 1, 1, pagr_komunikatoriai[i-1]);
		MPI_Send(&fakultetuSkaicius, 1, MPI_INT, 1, 1, pagr_komunikatoriai[i-1]);
		MPI_Send(&varduMasyvuSkaicius, 1, MPI_INT, 1, 1, pagr_komunikatoriai[i-1]);
		}
	for(int i = 1; i <= varduMasyvuSkaicius; i ++){
		MPI_Send((char *) &vardai[i-1], sizeof(Vardai), MPI_CHAR, 1, 1, pagr_komunikatoriai[i+fakultetuSkaicius-1]);
		MPI_Send(&varduMasyvuSkaicius, 1, MPI_INT, 1, 1, pagr_komunikatoriai[i+fakultetuSkaicius-1]);
		MPI_Send(&fakultetuSkaicius, 1, MPI_INT, 1, 1, pagr_komunikatoriai[i+fakultetuSkaicius-1]);
	}
	for(int i = 0; i < fakultetuSkaicius; i ++) {
		MPI_Recv(&rasymoGijaDarbaBaige, 1, MPI_INT, MPI_ANY_SOURCE, RASYMO_GIJA_DARBA_BAIGE_TAG, pagr_komunikatoriai[i], MPI_STATUS_IGNORE);
	}
	rasymoGijaDarbaBaige = 1;
	for(int i = fakultetuSkaicius+1; i <= varduMasyvuSkaicius+fakultetuSkaicius; i ++) {
		MPI_Isend(&rasymoGijaDarbaBaige, 1, MPI_INT, 1, RASYMO_PABAIGA_TAG, pagr_komunikatoriai[i-1], &(req[i-fakultetuSkaicius-1]));
	}
	cout << "****************************RASYMAS BAIGESI********************************" << endl;
	for(int i = 1; i <= varduMasyvuSkaicius; i ++) {
		MPI_Recv(&skaitymoGijaDarbaBaige, 1, MPI_INT, MPI_ANY_SOURCE, SKAITYMO_PABAIGA_TAG, pagr_komunikatoriai[fakultetuSkaicius+i-1], MPI_STATUS_IGNORE);
	}
	cout << "****************************SKAITYMAS BAIGESI********************************" << endl;
	skaitymoGijaDarbaBaige = 1;
	GijuMasyvoElementas gijuMasyvoElementas;
	gijuMasyvoElementas.kiekis = 0;
	gijuMasyvoElementas.procesoNr = world_rank;
	MPI_Send((char *) &gijuMasyvoElementas, sizeof(GijuMasyvoElementas), MPI_CHAR, 1, PABAIGA_TAG, pagr_komunikatoriai[fakultetuSkaicius+varduMasyvuSkaicius]);	
	MPI_Send(&skaitymoGijaDarbaBaige, 1, MPI_INT, 1, PABAIGA_TAG, MPI_COMM_WORLD);	r = new char[sizeof(GijuMasyvoElementas)*100];
	MPI_Recv(r, sizeof(GijuMasyvoElementas)*100, MPI_CHAR, 1, PABAIGA_TAG, pagr_komunikatoriai[fakultetuSkaicius+varduMasyvuSkaicius], stat);
	MPI_Recv(&elementuSkaiciusBendramGijuMasyve, 1, MPI_INT, 1, PABAIGA_TAG, pagr_komunikatoriai[fakultetuSkaicius+varduMasyvuSkaicius], stat);
	GijuMasyvoElementas *GML = (GijuMasyvoElementas *)r;
	SpausdintiGijuMasyva(rezultatuFailas, GML, elementuSkaiciusBendramGijuMasyve);
	cout << "PAGRINDINIS EXIT NR: " << world_rank << endl;	MPI_Finalize();	return 0;}Studentas imtiStudenta(Fakultetas &fakultetas)
{
	Studentas stud = fakultetas.studentai[0];
	fakultetas.studentuSkaicius --;
	for(int i = 0; i < fakultetas.studentuSkaicius; i ++){
		fakultetas.studentai[i] = fakultetas.studentai[i+1];
	}
	
	return stud;
}void rikiuotiFakultetoStudentus(Fakultetas &fakultetas)
{
	Studentas t;
	int nuo;
	for(int i = 0; i < fakultetas.studentuSkaicius - 1; i++) {
		nuo = i;
		for(int j = i+1; j < fakultetas.studentuSkaicius; j++)
			if (fakultetas.studentai[j].vardas > fakultetas.studentai[nuo].vardas) nuo = j;
		t = fakultetas.studentai[nuo];
		fakultetas.studentai[nuo] = fakultetas.studentai[i];
		fakultetas.studentai[i] = t;
	}
}void mazintiVardoKieki(Vardas &vardas)
{
	if(vardas.kiekis > 0){
		vardas.kiekis --;
	} else {
		vardas.kiekis = 0;
	}
}int mazintiVarduKieki(Vardai &vardai, int nr)
{
	mazintiVardoKieki(vardai.vardai[nr]);
	if(vardai.vardai[nr].kiekis == 0){
		vardai.kiekis --;
		for(int i = nr; i < vardai.kiekis; i ++){
			vardai.vardai[i] = vardai.vardai[i+1];
		}
		return 1;
	}

	return 0;
}void Skaityti(const char duomenuFailas[], int &fakultetuSkaicius, int &varduMasyvuSkaicius, Vardai vardai[], Fakultetas fakultetai[])
{
	 Studentas studentas;
	 Fakultetas fakultetas;
	 Vardas vardas_obj;
	 Vardai vardai_2;
	 string vardas, vardas_2;
	 double vidurkis;
	 bool fakultetuPabaiga = false;
	 int kursas;
	 int kiekis, kiekis_2;
	 ifstream fd(duomenuFailas);
	 while (!fd.eof()) {
		fd >> vardas >> kiekis;
		if(vardas == "-------------"){
			fd.ignore(80, '\n');
			fakultetuPabaiga = true;
			continue;
		}
		if(!fakultetuPabaiga){
			strcpy_s(fakultetas.pavadinimas, vardas.c_str());
			fakultetas.studentuSkaicius = 0;
			for(int i = 0; i < kiekis; i ++){
				fd >> vardas >> kursas >> vidurkis;
				strcpy_s(studentas.vardas, vardas.c_str());
				studentas.kursas = kursas;
				studentas.vidurkis = vidurkis;
				fakultetas.studentai[fakultetas.studentuSkaicius ++] = studentas;
			}
			fakultetai[fakultetuSkaicius ++] = fakultetas;
		} else {
			vardai_2.kiekis = 0;
			for(int i = 0; i < kiekis; i ++){
				fd >> vardas_2 >> kiekis_2;
				strcpy_s(vardas_obj.vardas, vardas_2.c_str());
				vardas_obj.kiekis = kiekis_2;
				vardai_2.vardai[vardai_2.kiekis ++] = vardas_obj;
			}
			vardai[varduMasyvuSkaicius ++] = vardai_2;
		}
	 }
	 fd.close();
}

void SpausdintiFakultetus(const char duomenuFailas[], Fakultetas fakultetas)
{
	Studentas studentas;
	Vardas vardas;
	ofstream fr(duomenuFailas, ios::app);
	fr << "********" << setw(15) <<  fakultetas.pavadinimas << "    ********" << endl;
	fr << "     Vardas   Kursas   Vidurkis   " << endl;
	for (int i = 0; i < fakultetas.studentuSkaicius; i ++)
	{
		studentas = fakultetas.studentai[i];
		fr  << right << setw(3) << i + 1 << ") "
			<< left << setw(10) << studentas.vardas << " "
			<< left << setw(9) << studentas.kursas << " "
			<< left << setw(9) << studentas.vidurkis << endl;
	}
	fr.close();
}void SpausdintiVardus(const char duomenuFailas[], Vardai vardai)
{
	Vardas vardas;
	ofstream fr(duomenuFailas, ios::app);
	fr << "************************************" << endl;
	fr << "     Rikiuojamas_laukas   Kiekis   " << endl;
	for (int i = 0; i < vardai.kiekis; i ++)
	{
		vardas = vardai.vardai[i];
		fr  << right << setw(3) << i + 1 << ") "
			<< left << setw(22) << vardas.vardas << " "
			<< left << setw(9) << vardas.kiekis << endl;
	}
	fr.close();
}void SpausdintiGijuMasyva(const char duomenuFailas[], GijuMasyvoElementas bendrasGijuMasyvas[], int elementuSkaiciusBendramGijuMasyve)
{
	GijuMasyvoElementas gijuMasyvoElementas;
	ofstream fr(duomenuFailas, ios::app);
	fr <<"--------------------------------"<<endl;
	fr <<"     Bendras Giju Masyvas       "<<endl;
	fr <<"--------------------------------"<<endl;
	fr <<"--------------------------------"<<endl;
	fr <<"     Rikiuojamas laukas   Kiekis"<<endl;
	fr <<"--------------------------------"<<endl;
	for (int i = 0; i < elementuSkaiciusBendramGijuMasyve; i ++){
		gijuMasyvoElementas = bendrasGijuMasyvas[i];
		fr  << right << setw(3) << i + 1 << ") "
			<< left << setw(22) << gijuMasyvoElementas.vardas << " "
			<< left << setw(9) << gijuMasyvoElementas.kiekis << endl;
	}
	fr.close();
}int rastiIterpimoVietaBendramGijuMasyve(GijuMasyvoElementas bendrasGijuMasyvas[], GijuMasyvoElementas elementas, int elementuSkaiciusBendramGijuMasyve)
{
	if(elementuSkaiciusBendramGijuMasyve == 0){
		return 0;
	}
	for(int i = 0; i < elementuSkaiciusBendramGijuMasyve; i ++){
		if(string(bendrasGijuMasyvas[i].vardas) >= string(elementas.vardas)){
			return i;
		}
	}

	return elementuSkaiciusBendramGijuMasyve;
}int iterptiElemetaBendramGijuMasyve(GijuMasyvoElementas bendrasGijuMasyvas[], GijuMasyvoElementas elementas, int &elementuSkaiciusBendramGijuMasyve)
{
	int iterpiamoElementoNr = rastiIterpimoVietaBendramGijuMasyve(bendrasGijuMasyvas, elementas, elementuSkaiciusBendramGijuMasyve);
	if(string(bendrasGijuMasyvas[iterpiamoElementoNr].vardas) == string(elementas.vardas)){
		strcpy_s(bendrasGijuMasyvas[iterpiamoElementoNr].vardas, elementas.vardas);
		bendrasGijuMasyvas[iterpiamoElementoNr].kiekis ++;
		return 0;
	}
	if(elementuSkaiciusBendramGijuMasyve+1 < maksimalusGijuElementuSkaicius){
		if(!elementuSkaiciusBendramGijuMasyve == 0){
			for(int i = elementuSkaiciusBendramGijuMasyve; i > iterpiamoElementoNr; i --){
				bendrasGijuMasyvas[i] = bendrasGijuMasyvas[i-1];
			}
		}
		bendrasGijuMasyvas[iterpiamoElementoNr] = elementas;
		elementuSkaiciusBendramGijuMasyve++;
		return 0;
	}

	return -1;
}

int rastiElementoVietaBendramGijuMasyve(GijuMasyvoElementas bendrasGijuMasyvas[], GijuMasyvoElementas elementas, int elementuSkaiciusBendramGijuMasyve)
{
	for(int i = 0; i < elementuSkaiciusBendramGijuMasyve; i ++){
		if(string(bendrasGijuMasyvas[i].vardas) == string(elementas.vardas)){
			return i;
		}
	}

	return -1;
}

int imtiElementaIsBendroGijuMasyvo(GijuMasyvoElementas bendrasGijuMasyvas[], GijuMasyvoElementas elementas, int &elementuSkaiciusBendramGijuMasyve)
{
	int ElementoNr = rastiElementoVietaBendramGijuMasyve(bendrasGijuMasyvas, elementas, elementuSkaiciusBendramGijuMasyve);
	
	if(ElementoNr == -1){
		return -1;
	}
	if(bendrasGijuMasyvas[ElementoNr].kiekis > 0){
		bendrasGijuMasyvas[ElementoNr].kiekis --;
	}
	if(bendrasGijuMasyvas[ElementoNr].kiekis == 0){
		elementuSkaiciusBendramGijuMasyve --;
		for(int i = ElementoNr; i < elementuSkaiciusBendramGijuMasyve; i ++){
			bendrasGijuMasyvas[i] = bendrasGijuMasyvas[i+1];
		}
		return 0;
	}

	return 1;
}
