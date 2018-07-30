#include <stdio.h>
#include <iostream>
#include <iomanip>
#include <fstream>
#include <string>
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>

using namespace std;

/* Konstantos */
const int N = 6;
const int K = 12;
const int PAVADINIMO_ILGIS_MAX = 15;

// Automobilio struktûra
struct Automobilis{
public:
	// N pavadinimø po PAVADINIMO_ILGIS_MAX raidþiø ir dar +1 eilutës pabaigos simboliui
	char pavadinimas[N * PAVADINIMO_ILGIS_MAX + 1];
	int metai;
	double litrai;

	/* Konstruktorius, priskiriantis struktûros kintamiesiems tuðèias reikðmes
	__host__ ir __device__ - destruktorius gali bûti kvieèiamas tiek ið CPU, tiek ið GPU */
	__host__ __device__ Automobilis() : metai(0), litrai(0.0){
		memset(pavadinimas, ' ', N * PAVADINIMO_ILGIS_MAX - 1); pavadinimas[N * PAVADINIMO_ILGIS_MAX] = '\0';
	};

	/* Destruktorius
	__host__ ir __device__ - destruktorius gali bûti kvieèiamas tiek ið CPU, tiek ið GPU*/
	__host__ __device__ ~Automobilis() {};

	/* Konstruktorius su parametrais
	__host__ ir __device__ - destruktorius gali bûti kvieèiamas tiek ið CPU, tiek ið GPU */
	__host__ __device__ Automobilis(char pavadinimas[], int metai, double litrai){
		for (int i = 0; i < N * PAVADINIMO_ILGIS_MAX; i++){
			this->pavadinimas[i] = pavadinimas[i];
		}
		this->metai = metai;
		this->litrai = litrai;
	}
};
/* Funkcija, sudedanti atitinkamø masyvø elementø laukø reikðmes 
	@param id - proceso identifikacinis numeris
	@param dev_iter_begin - GPU atmintyje esanèio proceso automobiliø vektoriaus iteratorius
	return Automobilis - gràþinamas Automobilio struktûros objektas */
Automobilis sudeti(int id, thrust::device_vector<Automobilis>::iterator dev_iter_begin);
/* Duomenø skaitymo funkcija
	@param &duomenys_masyvas - CPU atmintyje esanèiø duomenø vektoriaus adresas */
void skaityti(thrust::host_vector<Automobilis> &duomenys_masyvas);
/* Pradiniø duomenø spausdinimo funkcija 
	@param &automobiliai - CPU atmintyje esanèio automobiliø vektoriaus adresas */
void spausdintiDuomenis(thrust::host_vector<Automobilis> &automobiliai);
/* Rezultatø spausdinimo funkcija 
	@param &automobiliai - CPU atmintyje esanèio automobiliø vektoriaus adresas */
void spausdintiRezultatus(thrust::host_vector<Automobilis> &automobiliai);

// Pagrindinë programa
int main()
{
	// CPU atmintyje esantis duomenø vektorius
	thrust::host_vector<Automobilis> duomenys_masyvas;
	// CPU atmintyje esantis rezultatø vektorius
	thrust::host_vector<Automobilis> rezultatai;
	// GPU atmintyje esantis duomenø vektorius
	thrust::device_vector<Automobilis> dev_duomenys;
	// GPU atmintyje esantis rezultatø vektorius
	thrust::device_vector<Automobilis> dev_rezultatai(K);

	// Skaitomi duomenys á CPU vektoriø
	skaityti(duomenys_masyvas);

	// Vektorius perkopijuojamas ið CPU atminties á GPU (Thrust biblioteka tai leidþia daryti tiesiog priskiriant vektorius su operatoriumi = )
	dev_duomenys = duomenys_masyvas;

	// Sukuriamas GPU atmintyje esanèio duomenø vektoriaus pradþios iteratorius
	thrust::device_vector<Automobilis>::iterator dev_iter_begin = dev_duomenys.begin();

	// Sujungiami kiekvieno proceso duomenø laukai ir iðsaugomi atitinkamoje GPU rezultatø vektoriaus vietoje
	for (int i = 0; i < K; i++) dev_rezultatai[i] = sudeti(i, dev_iter_begin);
	
	// Rezultatø vektorius perkopijuojamas ið GPU á CPU atmintá
	rezultatai = dev_rezultatai;

	// Á rezultatø failà spausdinami pradiniai duomenys
	spausdintiDuomenis(duomenys_masyvas);
	// Á rezultatø failà spausdinami rezultatai
	spausdintiRezultatus(rezultatai);

	return 0;
}

Automobilis sudeti(int id, thrust::device_vector<Automobilis>::iterator dev_iter_begin)
{
	// Pradþiosi iteratoriui priskiriama atitinkamas vektoriaus elementas, nuo kurio pradedami sudëti atitinkami duomenø laukai
	thrust::device_vector<Automobilis>::iterator iter = dev_iter_begin + id;
	int metai = 0;
	double litrai = 0.0;
	char pavadinimai[N * PAVADINIMO_ILGIS_MAX];
	for (int i = 0; i < N; i++){
		// Paimamas Automobilio struktûros objektas (á kurá rodo iteratorius)
		Automobilis temp = (static_cast<Automobilis>(*iter));
		// Sumuojamos laukø reikðmës
		metai += temp.metai;
		litrai += temp.litrai;
		for (int j = 0; j < PAVADINIMO_ILGIS_MAX; j++) pavadinimai[PAVADINIMO_ILGIS_MAX * i + j] = temp.pavadinimas[j];
		// Iteratorius perðoka prie kitos eilutës, esanèios uþ K pozicijø
		// taip iteruojama per skirtingø duomenø masyvø tas paèias eilutes
		iter += K;
	}
	// Gràþinamas susumuotø duomenø laukø Automobilio struktûros objektas
	return Automobilis(pavadinimai, metai, litrai);
}

void skaityti(thrust::host_vector<Automobilis> &duomenys_masyvas){
	ifstream F("KazlauskasM_L4.txt");
	string pavadinimas;
	for (int i = 0; i < N; i++){
		Automobilis automobiliai_temp = Automobilis();
		F.ignore();
		for (int j = 0; j < K; j++){
			F >> pavadinimas;
			for (unsigned int k = 0; k < pavadinimas.length(); k++) automobiliai_temp.pavadinimas[k] = pavadinimas[k];
			F >> automobiliai_temp.metai >> automobiliai_temp.litrai;
			// Nuskaityti duomenys ádedami á vektoriu (prijungiami prie jo pabaigos)
			duomenys_masyvas.push_back(automobiliai_temp);
			F.ignore();
		}
	}
	F.close();
}
void spausdintiDuomenis(thrust::host_vector<Automobilis> &automobiliai){
	ofstream R("KazlauskasM_L4b_rez.txt");
	int masyvo_nr = 1;
	for (int i = 0; i < N; i++){
		int lineNr = 1;
		R << "****** Automobiliø masyvas Nr. " << masyvo_nr++ << " ******" << endl;
		R << "   |" << string(PAVADINIMO_ILGIS_MAX, '-') << "|" << string(12, '-') << "|" << string(9, '-') << "|" << endl;
		R << "   |" << setw(PAVADINIMO_ILGIS_MAX) << left << "Pavadinimas" << setw(13) << left << "|Metai" << setw(9) << left << "|Litrai   |" << endl;
		R << "   |" << string(PAVADINIMO_ILGIS_MAX, '-') << "|" << string(12, '-') << "|" << string(9, '-') << "|" << endl;
		for (int j = 0; j < K; j++){
			R << setw(3) << left << lineNr++ << "|";
			for (int k = 0; k < PAVADINIMO_ILGIS_MAX; k++) R << automobiliai[i * K + j].pavadinimas[k];
			R << "|" << setw(12) << left << automobiliai[i * K + j].metai << "|";
			R << setw(9) << left << fixed << setprecision(2) << automobiliai[i * K + j].litrai << "|" << endl;
		}
		R << "   |" << string(PAVADINIMO_ILGIS_MAX, '-') << "|" << string(12, '-') << "|" << string(9, '-') << "|" << endl;
		R << endl;
	}
}
void spausdintiRezultatus(thrust::host_vector<Automobilis> &automobiliai){
	ofstream R("KazlauskasM_L4b_rez.txt", ios::app);
	int lineNr = 1;
	R << "*******************************************" << endl;
	R << "Rezultatai" << endl;
	R << "*******************************************" << endl;
	R << "   |" << string((N * PAVADINIMO_ILGIS_MAX), '-') << "|" << string(12, '-') << "|" << string(9, '-') << "|" << endl;
	R << "   |" << setw(N * PAVADINIMO_ILGIS_MAX) << left << "Sujungti pavadinimai" << setw(13) << left << "|Metai" << setw(9) << left << "|Litrai   |" << endl;
	R << "   |" << string((N * PAVADINIMO_ILGIS_MAX), '-') << "|" << string(12, '-') << "|" << string(9, '-') << "|" << endl;
	for (int i = 0; i < K; i++){
		R << setw(3) << left << lineNr++ << "|";
		for (int j = 0; j < N*PAVADINIMO_ILGIS_MAX; j++){
			R << automobiliai[i].pavadinimas[j];
		}
		R << "|" << setw(12) << left << automobiliai[i].metai << "|";
		R << setw(9) << left << fixed << setprecision(2) << automobiliai[i].litrai << "|" << endl;
	}
	R << "   |" << string((N * PAVADINIMO_ILGIS_MAX), '-') << "|" << string(12, '-') << "|" << string(9, '-') << "|" << endl;
	R.close();
}
