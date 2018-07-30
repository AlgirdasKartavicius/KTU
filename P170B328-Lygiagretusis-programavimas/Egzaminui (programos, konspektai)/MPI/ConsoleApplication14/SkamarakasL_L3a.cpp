/**
* Lygiagretus programavimas
* III laboratorinis darbas I dalis
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
int ElementuSkaiciusBendramGijuMasyve = 0;					// Elementu Skaicius Bendram Giju Masyve

struct Studentas		// Studento duomenu struktura
{
	string vardas;		// Studento vardas
	int kursas;			// Studento kursas
	double vidurkis;	// Studento vidurkis
};

struct Fakultetas												// Fakulteto duomenu struktura
{
	string pavadinimas;											// Fakulteto pavadinimas
	int studentuSkaicius;										// Studentu skaicius
	Studentas studentai[maksimalusStudentuSkaiciusFakultete];	// Studentu masyvas
};

struct GijuMasyvoElementas	// Bendro masyvo elementas
{
	int kiekis;				// Elemento kiekis
	string vardas;			// Rikiuoja masyvo reiksmë
	int procesoNr;			// Proceso numeris
};
struct Vardas				// Rikiuojamo elemento duomenu struktura
{
	string vardas;			// Rikiuojamo elemento reiksme
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
void SpausdintiGijuMasyva(const char duomenuFailas[], GijuMasyvoElementas bendrasGijuMasyvas[]);

/*
 * Metodas spausdinantis rikiuojamu elementu duomenis.
 */
void SpausdintiVardus(const char duomenuFailas[], Vardai vardai);

/*
 *  Metodas grazinantis iterpiamo elemento vieta bendram masyve.
 */
int rastiIterpimoVietaBendramGijuMasyve(GijuMasyvoElementas bendrasGijuMasyvas[], GijuMasyvoElementas elementas);

/*
 *  Metodas iterpiantis elementa i bendra giju masyva.
 */
int iterptiElemetaBendramGijuMasyve(GijuMasyvoElementas bendrasGijuMasyvas[], GijuMasyvoElementas elementas);

/*
 *  Metodas grazinantis elemento vieta bendram masyve.
 */
int rastiElementoVietaBendramGijuMasyve(GijuMasyvoElementas bendrasGijuMasyvas[], GijuMasyvoElementas elementas);

/*
 *  Metodas salinantis elementa is bendro giju masyvo.
 */
int imtiElementaIsBendroGijuMasyvo(GijuMasyvoElementas bendrasGijuMasyvas[], GijuMasyvoElementas elementas);

int main(int argc, char *argv[])
{
	MPI_Init(&argc, &argv);
	Fakultetas fakultetai[maksimalusFakultetuSkaicius];
	int ElementuSkaiciusBendramGijuMasyve = 0;
	int varduMasyvuSkaicius = 0;
	int fakultetuSkaicius = 0;
	Vardai vardai[maksimalusFakultetuSkaicius];
	GijuMasyvoElementas bendrasGijuMasyvas[maksimalusGijuElementuSkaicius];
    int world_rank;
    MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);
	if(world_rank == 0){
		int rasymoGijaDarbaBaige;
		int skaitymoGijaDarbaBaige;
		MPI_Request req[SKAITYMO_PROCESU_SKAICIUS];
		MPI_Status stat[SKAITYMO_PROCESU_SKAICIUS];
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
			MPI_Send((char *) &fakultetai[i-1], sizeof(Fakultetas), MPI_CHAR, i, 1, MPI_COMM_WORLD);
			MPI_Send(&fakultetuSkaicius, 1, MPI_INT, i, 1, MPI_COMM_WORLD);
			MPI_Send(&varduMasyvuSkaicius, 1, MPI_INT, i, 1, MPI_COMM_WORLD);
		}
		for(int i = 1; i <= varduMasyvuSkaicius; i ++){
			MPI_Send((char *) &vardai[i-1], sizeof(Vardai), MPI_CHAR, i+fakultetuSkaicius, 11, MPI_COMM_WORLD);
			MPI_Send(&varduMasyvuSkaicius, 1, MPI_INT, i+fakultetuSkaicius, 1, MPI_COMM_WORLD);
			MPI_Send(&fakultetuSkaicius, 1, MPI_INT, i+fakultetuSkaicius, 1, MPI_COMM_WORLD);
		}
		for(int i = 0; i < fakultetuSkaicius; i ++) {
			MPI_Recv(&rasymoGijaDarbaBaige, 1, MPI_INT, MPI_ANY_SOURCE, RASYMO_GIJA_DARBA_BAIGE_TAG, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
		}
		rasymoGijaDarbaBaige = 1;
		for(int i = fakultetuSkaicius+1; i <= varduMasyvuSkaicius+fakultetuSkaicius; i ++) {
			MPI_Isend(&rasymoGijaDarbaBaige, 1, MPI_INT, i, RASYMO_PABAIGA_TAG, MPI_COMM_WORLD, &(req[i-fakultetuSkaicius-1]));
		}
		MPI_Waitall(varduMasyvuSkaicius, req, stat);
		for(int i = 1; i <= varduMasyvuSkaicius; i ++) {
			MPI_Recv(&skaitymoGijaDarbaBaige, 1, MPI_INT, MPI_ANY_SOURCE, SKAITYMO_PABAIGA_TAG, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
		}
		skaitymoGijaDarbaBaige = 1;
		GijuMasyvoElementas gijuMasyvoElementas;
		gijuMasyvoElementas.kiekis = 0;
		gijuMasyvoElementas.procesoNr = world_rank;
		MPI_Send((char *) &gijuMasyvoElementas, sizeof(GijuMasyvoElementas), MPI_CHAR, varduMasyvuSkaicius+fakultetuSkaicius+1, PABAIGA_TAG, MPI_COMM_WORLD);		
		MPI_Send(&skaitymoGijaDarbaBaige, 1, MPI_INT, 1, PABAIGA_TAG, MPI_COMM_WORLD);		char *r = new char[sizeof(GijuMasyvoElementas)*1000];
		MPI_Recv(r, sizeof(GijuMasyvoElementas)*1000, MPI_CHAR, varduMasyvuSkaicius+fakultetuSkaicius+1, PABAIGA_TAG, MPI_COMM_WORLD, stat);
		MPI_Recv(&ElementuSkaiciusBendramGijuMasyve, 1, MPI_INT, varduMasyvuSkaicius+fakultetuSkaicius+1, PABAIGA_TAG, MPI_COMM_WORLD, stat);
		GijuMasyvoElementas *GML = (GijuMasyvoElementas *)r;
		SpausdintiGijuMasyva(rezultatuFailas, GML);
	} else if (world_rank > 0 && world_rank <= 5) {
		MPI_Status status;
		int fakultetuSkaicius;
		int varduMasyvuSkaicius;
		char *r = new char[sizeof(Fakultetas)];
		MPI_Recv(r, sizeof(Fakultetas), MPI_CHAR, 0, 1, MPI_COMM_WORLD, &status);
		Fakultetas *F = (Fakultetas *)r;
		MPI_Recv(&fakultetuSkaicius, 1, MPI_INT, 0, 1, MPI_COMM_WORLD, &status);
		MPI_Recv(&varduMasyvuSkaicius, 1, MPI_INT, 0, 1, MPI_COMM_WORLD, &status);
		Studentas studentas;
		int rasymoPabaiga = 1;
		int elementasIterptas;
		while(F->studentuSkaicius > 0) {
			GijuMasyvoElementas gijuMasyvoElementas;
			gijuMasyvoElementas.kiekis = 1;
			gijuMasyvoElementas.procesoNr = world_rank;
			studentas = F->studentai[0];
			gijuMasyvoElementas.vardas = studentas.vardas;
			MPI_Send((char *) &gijuMasyvoElementas, sizeof(GijuMasyvoElementas), MPI_CHAR, varduMasyvuSkaicius+fakultetuSkaicius+1, RASYTI_TAG, MPI_COMM_WORLD);		
			MPI_Recv(&elementasIterptas, 1, MPI_INT, varduMasyvuSkaicius+fakultetuSkaicius+1, RASYTI_TAG, MPI_COMM_WORLD, &status);
			if(elementasIterptas == 0){
				imtiStudenta(*F);
			}
		}
		MPI_Send(&rasymoPabaiga, 1, MPI_INT, 0, RASYMO_GIJA_DARBA_BAIGE_TAG, MPI_COMM_WORLD);
	} else if (world_rank > 5 && world_rank <= 10) {
		MPI_Status status;
		int fakultetuSkaicius;
		int varduMasyvuSkaicius;
		char *r = new char[sizeof(Vardai)];
		MPI_Recv(r, sizeof(Vardai), MPI_CHAR, 0, 11, MPI_COMM_WORLD, &status);
		Vardai *V = (Vardai *)r;
		MPI_Recv(&fakultetuSkaicius, 1, MPI_INT, 0, 1, MPI_COMM_WORLD, &status);
		MPI_Recv(&varduMasyvuSkaicius, 1, MPI_INT, 0, 1, MPI_COMM_WORLD, &status);
		int vardoNr;
		int elementasPasalintas;
		int rasymasBaigesi;
		int skaitymoPabaiga = 1;
		Vardas vardas;
		int rasymasbaigesi = 0;
		int flag = 0;
		MPI_Irecv(&rasymasbaigesi, 1, MPI_INT, 0, RASYMO_PABAIGA_TAG, MPI_COMM_WORLD, &flag);
		while(V->kiekis > 0){
			int niekoNepakeista = 0;
			for(int i=0; i<V->kiekis; i++)
			{
				vardas = V->vardai[i];
				GijuMasyvoElementas gijuMasyvoElementas;
				gijuMasyvoElementas.procesoNr = world_rank;
				gijuMasyvoElementas.kiekis = 1;
				gijuMasyvoElementas.vardas = vardas.vardas;
				MPI_Send((char *) &gijuMasyvoElementas, sizeof(GijuMasyvoElementas), MPI_CHAR, varduMasyvuSkaicius+fakultetuSkaicius+1, SKAITYTI_TAG, MPI_COMM_WORLD);
				MPI_Recv(&elementasPasalintas, 1, MPI_INT, varduMasyvuSkaicius+fakultetuSkaicius+1, SKAITYTI_TAG, MPI_COMM_WORLD, &status);
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
		MPI_Send(&skaitymoPabaiga, 1, MPI_INT, 0, SKAITYMO_PABAIGA_TAG, MPI_COMM_WORLD);
	} else {
		GijuMasyvoElementas bendrasGijuMasyvas[1000];
		bool vykdytiProcesa = 0;
		MPI_Status stat;
		MPI_Request req;
		char *r = new char[sizeof(GijuMasyvoElementas)];
		GijuMasyvoElementas *G ;
		while(true){
			MPI_Recv(r, sizeof(GijuMasyvoElementas), MPI_CHAR, MPI_ANY_SOURCE, MPI_ANY_TAG, MPI_COMM_WORLD, &stat);
			if(stat.MPI_TAG == RASYTI_TAG)
			{
				G = (GijuMasyvoElementas *)r;
				int elementasIterptas = iterptiElemetaBendramGijuMasyve(bendrasGijuMasyvas, *G);
				MPI_Send(&elementasIterptas, 1, MPI_INT, G->procesoNr, RASYTI_TAG, MPI_COMM_WORLD);
			}
			else if(stat.MPI_TAG == SKAITYTI_TAG)
			{
				int elementasPasalintas;
				elementasPasalintas =  imtiElementaIsBendroGijuMasyvo(bendrasGijuMasyvas, *G);
				MPI_Send(&elementasPasalintas, 1, MPI_INT, G->procesoNr, SKAITYTI_TAG, MPI_COMM_WORLD);
			}
			else if(stat.MPI_TAG == PABAIGA_TAG)
			{
				break;
			}	
		}
		MPI_Send((char *) &bendrasGijuMasyvas, sizeof(GijuMasyvoElementas)*1000, MPI_CHAR, 0, PABAIGA_TAG, MPI_COMM_WORLD);
		MPI_Send(&ElementuSkaiciusBendramGijuMasyve, 1, MPI_INT, 0, PABAIGA_TAG, MPI_COMM_WORLD);
	}
	MPI_Barrier(MPI_COMM_WORLD);
	MPI_Finalize();

	return 0;
}Studentas imtiStudenta(Fakultetas &fakultetas)
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
			fakultetas.pavadinimas = vardas;
			fakultetas.studentuSkaicius = 0;
			for(int i = 0; i < kiekis; i ++){
				fd >> vardas >> kursas >> vidurkis;
				studentas.vardas = vardas;
				studentas.kursas = kursas;
				studentas.vidurkis = vidurkis;
				fakultetas.studentai[fakultetas.studentuSkaicius ++] = studentas;
			}
			fakultetai[fakultetuSkaicius ++] = fakultetas;
		} else {
			vardai_2.kiekis = 0;
			for(int i = 0; i < kiekis; i ++){
				fd >> vardas_2 >> kiekis_2;
				vardas_obj.vardas = vardas_2;
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
}void SpausdintiGijuMasyva(const char duomenuFailas[], GijuMasyvoElementas bendrasGijuMasyvas[])
{
	GijuMasyvoElementas gijuMasyvoElementas;
	ofstream fr(duomenuFailas, ios::app);
	fr <<"--------------------------------"<<endl;
	fr <<"     Bendras Giju Masyvas       "<<endl;
	fr <<"--------------------------------"<<endl;
	fr <<"--------------------------------"<<endl;
	fr <<"     Rikiuojamas laukas   Kiekis"<<endl;
	fr <<"--------------------------------"<<endl;
	for (int i = 0; i < ElementuSkaiciusBendramGijuMasyve; i ++){
		gijuMasyvoElementas = bendrasGijuMasyvas[i];
		fr  << right << setw(3) << i + 1 << ") "
			<< left << setw(22) << gijuMasyvoElementas.vardas << " "
			<< left << setw(9) << gijuMasyvoElementas.kiekis << endl;
	}
	fr.close();
}int rastiIterpimoVietaBendramGijuMasyve(GijuMasyvoElementas bendrasGijuMasyvas[], GijuMasyvoElementas elementas)
{
	if(ElementuSkaiciusBendramGijuMasyve == 0){
		return 0;
	}
	for(int i = 0; i < ElementuSkaiciusBendramGijuMasyve; i ++){
		if(bendrasGijuMasyvas[i].vardas >= elementas.vardas){
			return i;
		}
	}

	return ElementuSkaiciusBendramGijuMasyve;
}int iterptiElemetaBendramGijuMasyve(GijuMasyvoElementas bendrasGijuMasyvas[], GijuMasyvoElementas elementas)
{
	int iterpiamoElementoNr = rastiIterpimoVietaBendramGijuMasyve(bendrasGijuMasyvas, elementas);
	if(bendrasGijuMasyvas[iterpiamoElementoNr].vardas == elementas.vardas){
		bendrasGijuMasyvas[iterpiamoElementoNr].vardas = elementas.vardas;
		bendrasGijuMasyvas[iterpiamoElementoNr].kiekis ++;
		return 0;
	}
	if(ElementuSkaiciusBendramGijuMasyve+1 < maksimalusGijuElementuSkaicius){
		if(!ElementuSkaiciusBendramGijuMasyve == 0){
			for(int i = ElementuSkaiciusBendramGijuMasyve; i > iterpiamoElementoNr; i --){
				bendrasGijuMasyvas[i] = bendrasGijuMasyvas[i-1];
			}
		}
		bendrasGijuMasyvas[iterpiamoElementoNr] = elementas;
		ElementuSkaiciusBendramGijuMasyve++;
		return 0;
	}

	return -1;
}

int rastiElementoVietaBendramGijuMasyve(GijuMasyvoElementas bendrasGijuMasyvas[], GijuMasyvoElementas elementas)
{
	for(int i = 0; i < ElementuSkaiciusBendramGijuMasyve; i ++){
		if(bendrasGijuMasyvas[i].vardas == elementas.vardas){
			return i;
		}
	}

	return -1;
}

int imtiElementaIsBendroGijuMasyvo(GijuMasyvoElementas bendrasGijuMasyvas[], GijuMasyvoElementas elementas)
{
	int ElementoNr = rastiElementoVietaBendramGijuMasyve(bendrasGijuMasyvas, elementas);
	
	if(ElementoNr == -1){
		return -1;
	}
	if(bendrasGijuMasyvas[ElementoNr].kiekis > 0){
		bendrasGijuMasyvas[ElementoNr].kiekis --;
	}
	if(bendrasGijuMasyvas[ElementoNr].kiekis == 0){
		ElementuSkaiciusBendramGijuMasyve --;
		for(int i = ElementoNr; i < ElementuSkaiciusBendramGijuMasyve; i ++){
			bendrasGijuMasyvas[i] = bendrasGijuMasyvas[i+1];
		}
		return 0;
	}

	return 1;
}
