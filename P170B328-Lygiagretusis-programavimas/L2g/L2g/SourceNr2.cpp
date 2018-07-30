#include <iostream>
#include <iomanip>
#include <fstream>
#include <string>
#include <omp.h>

using namespace std;

class Monitorius {
private:
	int M[100];
	int kiekis = 0;
public:
	Monitorius() {
		for (int i = 0; i < 100; i++)
			M[i] = 0;
	}

	~Monitorius() {}

	void iterpti(int id){
		if (!darSalinti()){
			return;
		}
#pragma omp critical
		{
			for (int i = 100; i > id; i--){
				M[i] = M[i - 1];
			}
			M[id] = id;
		}
	}

	void salinti(int id){
		while (M[id] == 0 && darSalinti()){}
		if (!darSalinti() || M[id] == 0){
			return;
		}
#pragma omp critical
		{
			if (M[id] != 0){
				for (int i = id; i < 99; i++)
					M[i] = M[i + 1];
				kiekis++;
			}
		}
	}

	void spausdinti(int id){
#pragma omp critical
		{
			cout << id << " gija: ";
			for (int i = 0; i < 100; i++)
				cout << M[i] << " ";
			cout << endl;
		}

	}

	bool darSalinti(){
		bool salinti = false;
#pragma omp critical
		{
			if (kiekis < 20)
				salinti = true;
		}
		return salinti;
	}
};

void paleistiGijas(Monitorius *monitorius);

int main() {

	// Monitoriaus suk?rimas bei gij¸ paleidimas
	Monitorius *monitorius = new Monitorius();

	// Pradedamas gij¸ darbas
	paleistiGijas(monitorius);

	// Atlaisvinama atmintis
	delete(monitorius);
	return 0;
}

void paleistiGijas(Monitorius *monitorius){
#pragma omp parallel num_threads(5)
	{
		while (monitorius->darSalinti()){
			int id = omp_get_thread_num();
			if (id < 3){
				monitorius->iterpti(id + 1);
			}
			else{
				monitorius->salinti(id + 1);
				monitorius->spausdinti(id + 1);
			}
		}
	}
}