//#include <iostream>
//#include <iomanip>
//#include <fstream>
//#include <string>
//#include <omp.h>
//
//using namespace std;
//
//class Monitorius {
//private:
//	int a = 100;
//	int b = 0;
//
//	bool perskaite[3];
//public:
//	Monitorius() {
//		for (int i = 0; i < 3; i++) {
//			perskaite[i] = false;
//		}
//	}
//
//	~Monitorius() {}
//
//	void keistiReiksmes(){
//		while (!visiPerskaite() && skirtumasDidesnis()){}
//		if (!skirtumasDidesnis()){
//			return;
//		}
//		#pragma omp critical
//		{
//			a -= 10;
//			b += 10;
//			for (int i = 0; i < 3; i++){
//				perskaite[i] = false;
//			}
//		}
//	}
//
//	void skaitytiIrSpausdinti(int id){
//		while (visiPerskaite()){}
//		#pragma omp critical
//		{
//			if (!vienasPerskaite()){
//				cout << id << " " << a << " " << b << endl;
//			}
//			perskaite[id - 3] = true;
//		}
//	}
//
//	int skirtumasDidesnis(){
//		bool temp;
//		#pragma omp critical
//		{
//			 temp = abs(a - b) > 20;
//		}
//		return temp;
//	}
//
//	bool visiPerskaite(){
//		for (int i = 0; i < 3; i++)
//			if (!perskaite[i])
//				return false;
//		return true;
//	}
//
//	bool vienasPerskaite(){
//		for (int i = 0; i < 3; i++)
//			if (perskaite[i])
//				return true;
//		return false;
//	}
//};
//
//void paleistiGijas(Monitorius *monitorius);
//
//int main() {
//
//	// Monitoriaus sukûrimas bei gijø paleidimas
//	Monitorius *monitorius = new Monitorius();
//
//	// Pradedamas gijø darbas
//	paleistiGijas(monitorius);
//
//	// Atlaisvinama atmintis
//	delete(monitorius);
//	return 0;
//}
//
//void paleistiGijas(Monitorius *monitorius){
//	#pragma omp parallel num_threads(5)
//	{
//		while (monitorius->skirtumasDidesnis()){
//			int id = omp_get_thread_num();
//			if (id < 2){
//				monitorius->keistiReiksmes();
//			}
//			else{
//				monitorius->skaitytiIrSpausdinti(id + 1);
//			}
//		}
//	}
//}