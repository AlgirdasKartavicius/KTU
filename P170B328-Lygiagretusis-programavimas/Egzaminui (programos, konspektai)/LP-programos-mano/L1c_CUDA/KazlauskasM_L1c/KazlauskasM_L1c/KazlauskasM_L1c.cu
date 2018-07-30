/*
Laboratorinio darbo uþduotis: L1c
Mangirdas Kazlauskas IFF-4/1
Atsakymai á klausimus:
1) Visi vienu metu (tokio atsakymo varianto nëra, bet pagal teorijà yra taip)
2) Atsitiktine
3) Vienà pilnai
4) ? (neveikia atomicAdd, todël spausdina tik pirmàjá elementà)
5) Trumpiausias vienos gijos kodas buvo programoje 1b
6) Intel Core i7-3610QM 4 branduoliai 2.3GHz, OA - 12GB DDR3, OS - Microsoft Windows 10, NVIDIA - Geforce GT 635m 2gb 
*/
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <stdlib.h>
#include <string>

using namespace std;

#define MAX_SIZE 20
#define MAX_PAV_LENGTH 30

__device__ int dev_count;

 /*Rezultatø struktûra
 id - id
 pav - automobilio modelis
 metai - automobilio pagaminimo metai
 v - automobilio variklio tûris*/
struct Rez{
	int id;
	char pav[MAX_PAV_LENGTH];
	int metai;
	double v;
};

/* 
Duomenø skaitymo ið failo funkcija
@param S - automobiliø modeliø pavadinimø masyvas
@param I - automobiliø pagaminimo metø masyvas
@param D - automobilio variklio tûriø masyvas
@param n - nuskaitytø duomenø kiekis
*/
void Skaityti(char *S, int *I, double *D, int *n);
/*
Rezultatø spausdinimo funkcija
@param S - automobiliø modeliø pavadinimø masyvas
@param I - automobiliø pagaminimo metø masyvas
@param D - automobilio variklio tûriø masyvas
@param P - rezultatø struktûrø masyvas
@param n - nuskaitytø duomenø kiekis
*/
void Spausdinti(char *S, int *I, double *D, Rez *P, int *n);

/*
GPU lygiagreèiai vykdoma rezultatø masyvo pildymo funkcija
@param S - automobiliø modeliø pavadinimø masyvas
@param I - automobiliø pagaminimo metø masyvas
@param D - automobilio variklio tûriø masyvas
@param P - rezultatø struktûrø masyvas
@param n - nuskaitytø duomenø kiekis
*/
__global__ void Pildyti(const char *S, const int *I, const double *D, Rez *P, const int *n);

int main()
{
	char *S;
	int *I;
	double *D;
	int *n;
	int count = 0;

	S = (char *)malloc(MAX_SIZE * MAX_PAV_LENGTH * sizeof(char*));
	I = (int *)malloc(MAX_SIZE * sizeof(int));
	D = (double *)malloc(MAX_SIZE * sizeof(double));
	n = (int *)malloc(MAX_SIZE * sizeof(int));

	(*n) = 0;

	// rezultatø masyvo inicijavimas
	Rez *P = new Rez[MAX_SIZE];
	for (int i = 0; i < MAX_SIZE; i++){
		strcpy(P[i].pav, "xxx");
		P[i].id = -1;
		P[i].metai = -1;
		P[i].v = -1.1;
	}

	Skaityti(S, I, D, n);

	// GPU kintamøjø sukûrimas
	char *dev_S;
	int *dev_I;
	double *dev_D;
	Rez *dev_P;
	int *dev_n;
	cudaError_t cudaStatus;


	// Pasirenkamas GPU (jei kompiuteryje yra daugiau nei vienas)
	cudaStatus = cudaSetDevice(0);
	if (cudaStatus != cudaSuccess) {
		fprintf(stderr, "cudaSetDevice failed!  Do you have a CUDA-capable GPU installed?");
		goto Error;
	}

	// Atminties iðskyrimas
	cudaStatus = cudaMalloc((void **)&dev_S, MAX_SIZE * MAX_PAV_LENGTH * sizeof(char));
	if (cudaStatus != cudaSuccess) {
		fprintf(stderr, "cudaMalloc failed!");
		goto Error;
	}

	cudaStatus = cudaMalloc((void **)&dev_I, MAX_SIZE * sizeof(int));
	if (cudaStatus != cudaSuccess) {
		fprintf(stderr, "cudaMalloc failed!");
		goto Error;
	}

	cudaStatus = cudaMalloc((void **)&dev_D, MAX_SIZE * sizeof(double));
	if (cudaStatus != cudaSuccess) {
		fprintf(stderr, "cudaMalloc failed!");
		goto Error;
	}

	cudaStatus = cudaMalloc((void **)&dev_P, MAX_SIZE * sizeof(Rez));
	if (cudaStatus != cudaSuccess) {
		fprintf(stderr, "cudaMalloc failed!");
		goto Error;
	}

	cudaStatus = cudaMalloc((void **)&dev_n, sizeof(int));
	if (cudaStatus != cudaSuccess) {
		fprintf(stderr, "cudaMalloc failed!");
		goto Error;
	}

	// Kopijuoja duomenis ið CPU á GPU
	cudaStatus = cudaMemcpy(dev_S, S, MAX_SIZE * MAX_PAV_LENGTH * sizeof(char), cudaMemcpyHostToDevice);
	if (cudaStatus != cudaSuccess) {
		fprintf(stderr, "cudaMemcpy failed!");
		goto Error;
	}

	cudaStatus = cudaMemcpy(dev_I, I, MAX_SIZE * sizeof(int), cudaMemcpyHostToDevice);
	if (cudaStatus != cudaSuccess) {
		fprintf(stderr, "cudaMemcpy failed!");
		goto Error;
	}

	cudaStatus = cudaMemcpy(dev_D, D, MAX_SIZE * sizeof(double), cudaMemcpyHostToDevice);
	if (cudaStatus != cudaSuccess) {
		fprintf(stderr, "cudaMemcpy failed!");
		goto Error;
	}

	cudaStatus = cudaMemcpy(dev_P, P, MAX_SIZE * sizeof(Rez), cudaMemcpyHostToDevice);
	if (cudaStatus != cudaSuccess) {
		fprintf(stderr, "cudaMemcpy failed!");
		goto Error;
	}

	cudaStatus = cudaMemcpy(dev_n, n, sizeof(int), cudaMemcpyHostToDevice);
	if (cudaStatus != cudaSuccess) {
		fprintf(stderr, "cudaMemcpy failed!");
		goto Error;
	}

	cudaStatus = cudaMemcpyToSymbol(dev_count, &count, sizeof(int), 0, cudaMemcpyHostToDevice);
	if (cudaStatus != cudaSuccess) {
		fprintf(stderr, "__global__ cudaMemcpy failed!");
		goto Error;
	}

	// Funkcija vykdoma lygiagreèiai
	Pildyti << <1, (*n)>> >(dev_S, dev_I, dev_D, dev_P, dev_n);

	cudaThreadSynchronize();

	// Tikrinama dël klaidø branduolyje
	cudaStatus = cudaGetLastError();
	if (cudaStatus != cudaSuccess) {
		fprintf(stderr, "Pildyti launch failed: %s\n", cudaGetErrorString(cudaStatus));
		goto Error;
	}

	// cudaDeviceSynchronize laukia, kol branduolys baigs darbà, tikrina dël klaidø
	cudaStatus = cudaDeviceSynchronize();
	if (cudaStatus != cudaSuccess) {
		fprintf(stderr, "cudaDeviceSynchronize returned error code %d after launching Pildyti!\n", cudaStatus);
		goto Error;
	}

	// Kopijuojamami rezultatai ið GPU á CPU
	cudaStatus = cudaMemcpy(P, dev_P, MAX_SIZE * sizeof(Rez), cudaMemcpyDeviceToHost);
	if (cudaStatus != cudaSuccess) {
		fprintf(stderr, "cudaMemcpy failed!");
		goto Error;
	}

	cudaMemcpyFromSymbol(&count, &dev_count, sizeof(int), cudaMemcpyDeviceToHost);

	// Jei programos vykdymo metu atsirado klaidø, programa nukreipiama èia
Error:
	cudaFree(dev_S);
	cudaFree(dev_I);
	cudaFree(dev_D);
	cudaFree(dev_P);
	cudaFree(dev_n);

    cudaStatus = cudaDeviceReset();
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaDeviceReset failed!\n");
        return 1;
    }

	Spausdinti(S, I, D, P, n);

    return 0;
}

void Skaityti(char *S, int *I, double *D, int *n){
	FILE *file = fopen("KazlauskasM_L1c_dat.txt", "r");
	char buferis[MAX_PAV_LENGTH];
	// Skaito, kol nepasiekiama failo pabaiga
	while (!feof(file)){
		int pozicija = (*n) * MAX_PAV_LENGTH;

		// Skaito ið failo iki pirmo rasto tarpo (modelis)
		fscanf(file, "%s", buferis);

		for (int i = pozicija; i < pozicija + MAX_PAV_LENGTH; i++){
			S[i] = buferis[i - pozicija];
		}

		S[pozicija + MAX_PAV_LENGTH - 1] = '\0';

		// Skaito ið failo iki pirmo rasto tarpo (metai)
		fscanf(file, "%s", buferis);
		sscanf(buferis, "%d", &I[(*n)]);

		// Skaito ið failo iki pirmo rasto tarpo (variklio tûris)
		fscanf(file, "%s", buferis);
		sscanf(buferis, "%lf", &D[(*n)]);

		// skaitys kitoje eilutëje
		(*n)++;
	}
	fclose(file);
}

void Spausdinti(char *S, int *I, double *D, Rez *P, int *n) {
	FILE *file = fopen("KazlauskasM_L1c_rez.txt", "w");
	int iter;
	char temp[MAX_PAV_LENGTH];

	fprintf(file, "Duomenø rinkinys\n");
	fprintf(file, "-----------------------------------\n");
	fprintf(file, "    Modelis     Metai Variklio tûris\n");
	for (int i = 0; i < (*n); i++) {
		if (i < 9) {
			fprintf(file, "0%d) ", i + 1);
		}
		else {
			fprintf(file, "%d) ", i + 1);
		}

		iter = i * MAX_PAV_LENGTH;
		for (int j = iter; j < iter + MAX_PAV_LENGTH; j++) {
			temp[j - iter] = S[j];
		}
		fprintf(file, "%-12s %-3d %6.2f\n", temp, I[i], D[i]);
	}
	fprintf(file, "-----------------------------------\n");
	fprintf(file, "Rezultatai\n");
	fprintf(file, "-----------------------------------\n");
	fprintf(file, "    Modelis     Metai Variklio tûris\n");
	for (int i = 0; i < (*n); i++) {
		if (i < 9) {
			fprintf(file, "0%d) ", i + 1);
		}
		else {
			fprintf(file, "%d) ", i + 1);
		}
		fprintf(file, "%-12s %-3d %6.2f\n", P[i].pav, P[i].metai, P[i].v);
	}

	fclose(file);
}

__global__ void Pildyti(const char *S, const int *I, const double *D, Rez *P, const int *n){
	int id = threadIdx.x;
	if (id < 10)
		// Papildomas darbas
		for (int i = 0; i < 500000; i++){
			double x = 1000 * 20000 / i + i;
		}
	if (id < n[0]){
		int pozicija = id * 30;
		for (int i = pozicija; i < pozicija + 30; i++) P[dev_count].pav[i - pozicija] = S[i];
		P[dev_count].id = id;
		P[dev_count].metai = I[id];
		P[dev_count].v = D[id];
	}
	atomicAdd(&dev_count, 1);
}