
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <iostream>
#include <iomanip>
#include <fstream>
#include <string>

using namespace std;

/* Konstantos */
/* Masyv� skai�ius*/
const int N = 6;
/* Automobili� (�ra��) skai�ius masyve */
const int K = 12;
/* Maksimalus automobilio pavadinimo ilgis */
const int PAVADINIMO_ILGIS_MAX = 15;

/* Automobilio strukt�ra */
struct Automobilis{
	public:
		// N pavadinim� po PAVADINIMO_ILGIS_MAX raid�i� ir dar +1 eilut�s pabaigos simboliui
		char pavadinimas[N * PAVADINIMO_ILGIS_MAX + 1];
		int metai;
		double litrai;

		/* Konstruktorius, priskiriantis strukt�ros kintamiesiems tu��ias reik�mes
		__host__ - konstruktorius gali b�ti kvie�iamas i� CPU */
		__host__ Automobilis() : metai(0), litrai(0.0){ 
			memset(pavadinimas, ' ', N * PAVADINIMO_ILGIS_MAX - 1); pavadinimas[N * PAVADINIMO_ILGIS_MAX] = '\0';
		};

		/* Destruktorius 
		__host__ ir __device__ - destruktorius gali b�ti kvie�iamas tiek i� CPU, tiek i� GPU*/
		__host__ __device__ ~Automobilis() {};

		/* Konstruktorius su parametrais 
		__device__ - konstruktorius gali b�ti kvie�iamas i� GPU*/
		__device__ Automobilis(char pavadinimas[], int metai, double litrai){
			for (int i = 0; i < N * PAVADINIMO_ILGIS_MAX; i++) this->pavadinimas[i] = pavadinimas[i];
			this->metai = metai;
			this->litrai = litrai;
		}	
};
/* Programos vykdymo funkcija, kurioje i�skiriama atmintis GPU, ten atliekami veiksmai, gr��inami rezultatai
	gr��ina funcijos status�, t.y., cudaSuccess, jei viskas pavyko gerai */
cudaError_t vykdyti(Automobilis **duomenys, Automobilis *rezultatai);
/* Funkcija, sudedanti atitinkam� masyv� element� lauk� reik�mes */
__global__ void sudeti(Automobilis *automobiliai, Automobilis *rezultatai);
/* Duomen� skaitymo funkcija */
void skaityti(Automobilis** automobiliai);
/* Pradini� duomen� spausdinimo funkcija */
void spausdintiDuomenis(Automobilis** automobiliai);
/* Rezultat� spausdinimo funkcija */
void spausdintiRezultatus(Automobilis *automobiliai);

int main()
{
	/* Automobili� duomen� dvimatis masyvas*/
	Automobilis** automobiliai = new Automobilis*[N];
	skaityti(automobiliai);
	
	/* Rezultat� masyvas */
	Automobilis *rezultatai = new Automobilis[K];

	cudaError_t cudaStatus = vykdyti(automobiliai, rezultatai);
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "vykdyti failed!");
        return 1;
    }

	/* � rezultat� fail� pausdinami pradiniai duomenys bei rezultatai*/
	spausdintiDuomenis(automobiliai);
	spausdintiRezultatus(rezultatai);

	/* Kodo dalis, reikalinga Nsight ir Visual Profiler �rankiams*/
    cudaStatus = cudaDeviceReset();
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaDeviceReset failed!");
        return 1;
    }

	/* Atlaisvinama dinami�kai i�skirta atmintis */
	delete[] automobiliai;
	delete[] rezultatai;
    return 0;
}

cudaError_t vykdyti(Automobilis **duomenys_matrica, Automobilis *rezultatai)
{
	/* CUDA statusas*/
	cudaError_t cudaStatus;

	/* GPU skirti kintamieji*/
	Automobilis *dev_rezultatai = new Automobilis[K];
	Automobilis *dev_duomenys = new Automobilis[K * N];

	/* Duomen� matrica i�skleid�iama � duomen� masyv� (vien� eilut�)*/
	Automobilis *duomenys_masyvas = new Automobilis[K * N];
	for (int i = 0; i < N; i++)
		for (int j = 0; j < K; j++)
			duomenys_masyvas[i * K + j] = duomenys_matrica[i][j];

    // Pasirenkama, kuriame GPU �renginyje leisti program�
    cudaStatus = cudaSetDevice(0);
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaSetDevice failed!  Do you have a CUDA-capable GPU installed?");
        goto Error;
    }

    // I�skiriama atmintis GPU �renginyje   .
    cudaStatus = cudaMalloc((void**)&dev_duomenys, N * K * sizeof(Automobilis));
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMalloc failed!");
        goto Error;
    }

    cudaStatus = cudaMalloc((void**)&dev_rezultatai, K * sizeof(Automobilis));
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMalloc failed!");
        goto Error;
    }

    // Nukopijuojami duomenys � GPU kintamuosius
    cudaStatus = cudaMemcpy(dev_duomenys, duomenys_masyvas, N * K * sizeof(Automobilis), cudaMemcpyHostToDevice);
    if (cudaStatus != cudaSuccess) {
		fprintf(stderr, "cudaMemcpy failed!");
        goto Error;
    }

    cudaStatus = cudaMemcpy(dev_rezultatai, rezultatai, K * sizeof(Automobilis), cudaMemcpyHostToDevice);
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMemcpy failed!");
        goto Error;
    }

    // Vykdoma programa lygiagre�iai 1 bloke, gij� skai�ius - K
	sudeti<< <1, K>> >(dev_duomenys, dev_rezultatai);

    // Tikrinama, ar lygiagretaus kodo vykdymo metu atsirado koki� klaid�
    cudaStatus = cudaGetLastError();
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "addKernel launch failed: %s\n", cudaGetErrorString(cudaStatus));
        goto Error;
    }
    
    // cudaDeviceSynchronize laukiama funkcijos vykdymo pabaigos
    cudaStatus = cudaDeviceSynchronize();
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaDeviceSynchronize returned error code %d after launching addKernel!\n", cudaStatus);
        goto Error;
    }

    // Kopijuojami rezultatai i� GPU � CPU
    cudaStatus = cudaMemcpy(rezultatai, dev_rezultatai, K * sizeof(Automobilis), cudaMemcpyDeviceToHost);
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMemcpy failed!");
        goto Error;
    }
Error:
	/* Atlaisvinama atmintis */
	delete[] duomenys_masyvas;
    cudaFree(dev_duomenys);
    cudaFree(dev_rezultatai);
    
    return cudaStatus;
}

__global__ void sudeti(Automobilis *automobiliai, Automobilis *rezultatai)
{
	/* Paimamas gijos indeksas (kadangi masyvas - vienmatis, imama x koordinat�)*/
	int id = threadIdx.x;
	int metai = 0;
	double litrai = 0.0;
	char pavadinimai[N * PAVADINIMO_ILGIS_MAX];
	/* Einama per vis� masyv� */
	for (int i = 0; i < N; i++){
		/* Kadangi matrica buvo i�reik�ta eilute, tai jei matricoje �ra�o koordinat�s buvo
			automobiliai[i][j], kur i - eilut�, j - stulpelis, masyve �ias koordinates atitinka
			automobiliai[i * K + j], kur K - �ra�� kiekis viename masyve arba �ra�� kiekis
			buvusioje matricos eilut�je */
		metai += automobiliai[i * K + id].metai;
		litrai += automobiliai[i * K + id].litrai;
		for (int j = 0; j < PAVADINIMO_ILGIS_MAX; j++) pavadinimai[PAVADINIMO_ILGIS_MAX * i + j] = automobiliai[i * K + id].pavadinimas[j];
	}
	rezultatai[id] = Automobilis(pavadinimai, metai, litrai);
}

void skaityti(Automobilis** automobiliai){
	ifstream F("KazlauskasM_L4.txt");
	string pavadinimas;
	for (int i = 0; i < N; i++){
		Automobilis *automobiliai_temp = new Automobilis[K];
		F.ignore();
		for (int j = 0; j < K; j++){
			F >> pavadinimas;
			for (unsigned int k = 0; k < pavadinimas.length(); k++) automobiliai_temp[j].pavadinimas[k] = pavadinimas[k];
			F >> automobiliai_temp[j].metai >> automobiliai_temp[j].litrai;
			F.ignore();
		}
		automobiliai[i] = automobiliai_temp;
	}
	F.close();
}
void spausdintiDuomenis(Automobilis** automobiliai){
	ofstream R("KazlauskasM_L4a_rez.txt");
	int masyvo_nr = 1;
	for (int i = 0; i < N; i++){
		int lineNr = 1;
		R << "****** Automobili� masyvas Nr. " << masyvo_nr++ << " ******" << endl;
		R << "   |" << string(PAVADINIMO_ILGIS_MAX, '-') << "|" << string(12, '-') << "|" << string(9, '-') << "|" << endl;
		R << "   |" << setw(PAVADINIMO_ILGIS_MAX) << left << "Pavadinimas" << setw(13) << left << "|Metai" << setw(9) << left << "|Litrai   |" << endl;
		R << "   |" << string(PAVADINIMO_ILGIS_MAX, '-') << "|" << string(12, '-') << "|" << string(9, '-') << "|" << endl;
		for (int j = 0; j < K; j++){
			R << setw(3) << left << lineNr++ << "|";
			for (int k = 0; k < PAVADINIMO_ILGIS_MAX; k++) R << automobiliai[i][j].pavadinimas[k];
			R << "|" << setw(12) << left << automobiliai[i][j].metai << "|";
			R << setw(9) << left << fixed << setprecision(2) << automobiliai[i][j].litrai << "|" << endl;
		}
		R << "   |" << string(PAVADINIMO_ILGIS_MAX, '-') << "|" << string(12, '-') << "|" << string(9, '-') << "|" << endl;
		R << endl;
	}
}
void spausdintiRezultatus(Automobilis *automobiliai){
	ofstream R("KazlauskasM_L4a_rez.txt", ios::app);
	int lineNr = 1;
	R << "*******************************************" << endl;
	R << "Rezultatai" << endl;
	R << "*******************************************" << endl;
	R << "   |" << string((N * PAVADINIMO_ILGIS_MAX), '-') << "|" << string(12, '-') << "|" << string(9, '-') << "|" << endl;
	R << "   |" << setw(N * PAVADINIMO_ILGIS_MAX) << left << "Sujungti pavadinimai" << setw(13) << left << "|Metai" << setw(9) << left << "|Litrai   |" << endl;
	R << "   |" << string((N * PAVADINIMO_ILGIS_MAX), '-') << "|" << string(12, '-') << "|" << string(9, '-') << "|" << endl;
	for (int i = 0; i < K; i++){
		R << setw(3) << left << lineNr++ << "|" << setw(N * PAVADINIMO_ILGIS_MAX) << left << automobiliai[i].pavadinimas;
		R << "|" << setw(12) << left << automobiliai[i].metai << "|";
		R << setw(9) << left << fixed << setprecision(2) << automobiliai[i].litrai << "|" << endl;
	}
	R << "   |" << string((N * PAVADINIMO_ILGIS_MAX), '-') << "|" << string(12, '-') << "|" << string(9, '-') << "|" << endl;
	R.close();
}
