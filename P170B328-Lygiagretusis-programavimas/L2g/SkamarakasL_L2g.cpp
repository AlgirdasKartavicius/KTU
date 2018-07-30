#include <omp.h>
#include <iostream>
#include <fstream>
#include <algorithm>
#include <iomanip>
#include <cmath>
#include <string>
#include <thread>
#include <future>
#include <chrono>
using namespace std;

int ISVEDIMU_SKAICIUS = 0;
int ArProcesasBaigeRasyma[3];
int ArProcesasBaigeSkaityma[2];

/**
*	Monitorius saugantis priejima prie kritines sekcijos
*/
omp_lock_t Monitor;

class omp_guard {
public:
    /** Konstruktorius su parametrais */
    omp_guard (omp_lock_t &lock);
    /** Metodas kritinės sekcijos užėmimui */
    void uzimtiKritineSekcija ();
    /** Metodas kritinės sekcijos perleidimui kitai gijai*/
    void paliktiKritineSekcija ();
    /** Klasės destruktorius */
    ~omp_guard ();

private:
    omp_lock_t *lock_;  // rodyklė į kritinės sekcijos užraktą
    bool owner_;   // kritinėje sekcijoje esantis objektas
    omp_guard (const omp_guard &);
    void operator= (const omp_guard &);
};

void VykdytiKonstruktoriausGija(int threadnr, string duomenys, string &eilute);
void VykdytiDestruktoriausGija(int threadnr, string &eilute);


int main()
{
	string eilute  = "*";
	string duomenys[3];
	duomenys[0] = "qwertyuiopasdfghjklzxcvbnm";
	duomenys[1] = "QWERTYUIOPASDFGHJKLZXCVBNM";
	duomenys[2] = "0123456789";

	omp_init_lock(&Monitor);
	#pragma omp parallel num_threads(5)
	{
		if(omp_get_thread_num() < 3){
			VykdytiKonstruktoriausGija(omp_get_thread_num(), duomenys[omp_get_thread_num()], eilute);
		} else {
			VykdytiDestruktoriausGija(omp_get_thread_num()+1, eilute);
		}
	}
	omp_destroy_lock(&Monitor);

	return 0;
}

omp_guard::omp_guard (omp_lock_t &lock) : lock_ (&lock), owner_ (false)
{
    uzimtiKritineSekcija ();
}

void omp_guard::uzimtiKritineSekcija ()
{
    omp_set_lock (lock_);
    owner_ = true;
}

void omp_guard::paliktiKritineSekcija ()
{
    if (owner_) {
        owner_ = false;
        omp_unset_lock (lock_);
    }
}

omp_guard::~omp_guard ()
{
    paliktiKritineSekcija ();
}\

void VykdytiKonstruktoriausGija(int threadnr, string duomenys, string &eilute)
{
	while(duomenys.length() > 0 && ISVEDIMU_SKAICIUS < 15){
		{
			omp_guard my_guard(Monitor);
			eilute += duomenys[0];
			// Irasytos reiksmes salinimas
			duomenys.erase(0, 1);
			if (duomenys.length() == 0){
				ArProcesasBaigeRasyma[threadnr] = 1;
			}
			my_guard.~omp_guard();
		}
	}
}

void VykdytiDestruktoriausGija(int threadnr, string &eilute)
{
	while(ISVEDIMU_SKAICIUS < 15){
		{
			omp_guard my_guard(Monitor);
			if(eilute.length() > 0){
				cout << "Gija nr: " << threadnr << " nuskaite simboli: " << eilute[0] << endl;
				// Nuskaitytos reiksmes salinimas
				eilute.erase(0, 1);
				ISVEDIMU_SKAICIUS ++;
				if (ArProcesasBaigeRasyma[0] == 1 && ArProcesasBaigeRasyma[1] == 1 && ArProcesasBaigeRasyma[2] == 1){
					ArProcesasBaigeRasyma[threadnr-4] = 1;
				}
				if(ArProcesasBaigeRasyma[0] == 1 && ArProcesasBaigeRasyma[1] == 1){
					ISVEDIMU_SKAICIUS = 15;
				}
			}
			my_guard.~omp_guard();
		}
	}
}