/**
*	Kokia tvarka startuoja procesai?
*		 Tokia, kokia uþraðyti.
*	Kokia tvarka vykdomi procesai?
*		Atsitiktine.
*	Kiek iteracijø ið eilës padaro vienas procesas?
*		Visas.
*	Kokia tvarka to paties duomenø masyvo elementai suraðomi á rezultatø masyvà?
*		Atsitiktine.
*/
#include <iostream>
#include <fstream>
#include <iomanip>
#include <cmath>
#include <string>
#include <thread>
using namespace std;

/**
*	Duomenu failo vardas
*/
const char duomenuFailas[] = "SkamarakasL_L1a_dat.txt";

/**
*	Rezultatu failo vardas
*/
const char rezultatuFailas[] = "SkamarakasL_L1a_rez.txt";

/**
*	Maksimalus studentu skaicius masyve
*/
const int maksimalusStudentuSkaiciusFakultete = 100;

/**
*	Maksimalus fakultetu skaicius
*/
const int maksimalusFakultetuSkaicius = 10;

/**
*	Maksimalus elementu skaicius bendram giju masyve
*/
const int maksimalusGijuElementuSkaicius = 1000;

/**
*	Realus elementu skaicius bendram giju masyve
*/
int ElementuSkaiciusBendramGijuMasyve = 0;

/**
*	Studento klasë
*/
class Studentas
{
	/**
	*	Studento vardas
	*
	*	@param string
	*/
	string vardas;

	/**
	*	Studento kursas
	*
	*	@param int
	*/
	int kursas;

	/**
	*	Studento vidurkis
	*
	*	@param double
	*/
	double vidurkis;

public:

	/**
	*	Klases konstruktorius
	*/
	Studentas(string vardas, int kursas, double vidurkis): vardas(vardas), kursas(kursas), vidurkis(vidurkis)
	{}

	/**
	*	Klases konstruktorius
	*/
	Studentas(): vardas(""), kursas(0), vidurkis(0.0)
	{}

	/**
	*	Metodas iðvedantis studento vardà
	*
	*	@return string
	*/
	string iðvestiStudentoVarda()
	{
		return  this->vardas;
	}

	/**
	*	Metodas iðvedantis studento kursà
	*
	*	@return int
	*/
	int iðvestiStudentoKursa()
	{
		return  this->kursas;
	}

	/**
	*	Metodas iðvedantis studento vidurki
	*
	*	@return double
	*/
	double iðvestiStudentoVidurki()
	{
		return  this->vidurkis;
	}

};

	/**
	*	Fakulteto klase
	*/
class Fakultetas
{
	/**
	*	Fakulteto pavadinimas
	*
	*	@param string
	*/
	string pavadinimas;

	/**
	*	Fakulteto studentu skaicius
	*
	*	@param int
	*/
	int studentuSkaicius;

	/**
	*	Fakulteto studentu masyvas
	*
	*	@param array
	*/
	Studentas studentai[maksimalusStudentuSkaiciusFakultete];

public:

	/**
	*	Klases konstruktorius
	*/
	Fakultetas(string pavadinimas): pavadinimas(pavadinimas), studentuSkaicius(0)
	{}

	/**
	*	Klases konstruktorius
	*/
	Fakultetas(): pavadinimas(""), studentuSkaicius(0)
	{}

	/**
	*	Studento registracios metodas.
	*/
	void registruotiStudenta(Studentas studentas)
	{
		this->studentai[this->studentuSkaicius ++] = studentas;
	}

	/**
	*	Metodas iðvedantis fakulteto pavadinima
	*
	*	@return string
	*/
	string isvestiFakultetoPavadinima()
	{
		return this->pavadinimas;
	}

	/**
	*	Metodas iðvedantis fakulteto studentu skaiciu
	*
	*	@return int
	*/
	int isvestiStudentuSkaiciu()
	{
		return this->studentuSkaicius;
	}

	/**
	*	Metodas iðvedantis fakulteto studenta
	*
	*	@return Studentas
	*/
	Studentas gautiStudentoInfo(int studentoNr)
	{
		if(abs(studentoNr) < this->studentuSkaicius){
			return this->studentai[abs(studentoNr)];
		}

		return *new Studentas("", 0, 0.0);
	}
};

	/**
	*	Gijos klase
	*/
class Gija
{

	/**
	*	Gijos numeris
	*
	*	@param int
	*/
	int elementoNr;

	/**
	*	Gijos pavadinimas
	*
	*	@param string
	*/
	string gijosPavadinimas;

	/**
	*	Studento objektas
	*
	*	@param Studentas
	*/
	Studentas studentas;

public:

	/**
	*	Klases konstruktorius
	*/
	Gija(): elementoNr(0), gijosPavadinimas("")
	{}

	/**
	*	Klases konstruktorius
	*/
	Gija(string gijosPavadinimas, Studentas studentas, int elementoNr): gijosPavadinimas(gijosPavadinimas), studentas(studentas), elementoNr(elementoNr)
	{}

	/**
	*	Metodas iðvedantis gijos numeri
	*
	*	@return int
	*/
	int isvestiElementoNr()
	{
		return this->elementoNr;
	}

	/**
	*	Metodas iðvedantis gijos pavadinima
	*
	*	@return string
	*/
	string isvestiGijosPavadinima()
	{
		return this->gijosPavadinimas;
	}

	/**
	*	Metodas iðvedantis studento informacija
	*
	*	@return Studentas
	*/
	Studentas isvestiStudentoInfo()
	{
		return this->studentas;
	}
};

	/**
	*	Metodas skaitantis duomenis ið duomenu failo
	*
	*	@param char duomenuFailas[]
	*	@param int fakultetuSkaicius
	*   @param Fakultetas fakultetai[]
	*/
void Skaityti(const char duomenuFailas[], int &fakultetuSkaicius, Fakultetas fakultetai[]);

	/**
	*	Metodas spausdinantis rezultatus i rezultatu faila
	*
	*	@param char duomenuFailas[]
	*	@param int fakultetuSkaicius
	*/
void Spausdinti(const char duomenuFailas[], Fakultetas *fakultetas);

	/**
	*	Metodas vykdomas kiekvienos gijos
	*
	*	@param string gijosPavadinimas
	*	@param Fakultetas fakultetas
	*	@param Gija bendrasGijuMasyvas
	*/
void VykdytiGija(string gijosPavadinimas, Fakultetas *fakultetas, Gija bendrasGijuMasyvas[]);

	/**
	*	Metodas spausdinantis bendro giju masyvo duomenis i rezultatu faila
	*
	*	@param char duomenuFailas[]
	*	@param Gija bendrasGijuMasyvas
	*/
void SpausdintiGijuMasyva(const char duomenuFailas[], Gija bendrasGijuMasyvas[]);

int main()
{
	Fakultetas fakultetai[maksimalusFakultetuSkaicius];
	thread *gijos[maksimalusFakultetuSkaicius];
	int fakultetuSkaicius = 0;
	Gija bendrasGijuMasyvas[maksimalusGijuElementuSkaicius];

	Skaityti(duomenuFailas, fakultetuSkaicius, fakultetai);

	ofstream fr(rezultatuFailas);
	fr.close();
	for(int i = 0; i < fakultetuSkaicius; i ++){
		Spausdinti(rezultatuFailas, &fakultetai[i]);
	}

	for(int i = 0; i < fakultetuSkaicius; i ++){
		string gijosPavadinimas = "gija_" + to_string(i + 1);
		gijos[i] = new thread(VykdytiGija, gijosPavadinimas, &fakultetai[i], bendrasGijuMasyvas);
	}

	for(int i = 0; i < fakultetuSkaicius; i ++){
		gijos[i]->join();
	}

	SpausdintiGijuMasyva(rezultatuFailas, bendrasGijuMasyvas);
}

void Skaityti(const char duomenuFailas[], int &fakultetuSkaicius, Fakultetas fakultetai[])
{
	 Studentas *studentas;
	 Fakultetas *fakultetas;
	 string vardas;
	 double vidurkis;
	 int kursas;
	 int kiekis;
	 ifstream fd(duomenuFailas);
	 while (!fd.eof()) {
		fd >> vardas >> kiekis;
		fakultetas = new Fakultetas(vardas);
		for(int i = 0; i < kiekis; i ++){
			fd >> vardas >> kursas >> vidurkis;
			studentas = new Studentas(vardas, kursas, vidurkis);
			fakultetas->registruotiStudenta(*studentas);
		}
		fakultetai[fakultetuSkaicius ++] = *fakultetas;
	 }
	 fd.close();
}

void Spausdinti(const char duomenuFailas[], Fakultetas *fakultetas)
{
	Studentas studentas;
	ofstream fr(duomenuFailas, ios::app);
	fr << "********" << setw(15) <<  fakultetas->isvestiFakultetoPavadinima() << "    ********" << endl;
	fr << "     Vardas   Kursas   Vidurkis   " << endl;
	for (int i = 0; i < fakultetas->isvestiStudentuSkaiciu(); i ++)
	{
		studentas = fakultetas->gautiStudentoInfo(i);
		fr  << right << setw(3) << i + 1 << ") "
			<< left << setw(10) << studentas.iðvestiStudentoVarda() << " "
			<< left << setw(9) << studentas.iðvestiStudentoKursa() << " "
			<< left << setw(9) << studentas.iðvestiStudentoVidurki() << endl;
	}
	fr.close();
}

void SpausdintiGijuMasyva(const char duomenuFailas[], Gija bendrasGijuMasyvas[])
{
	Studentas studentas;
	ofstream fr(duomenuFailas, ios::app);
	fr <<"-----------------------------------------------------------------------------------------------"<<endl;
	fr <<"Gijos pavadinimas     Elemento nr     Studento vardas     Studento kursas     Studento vidurkis"<<endl;
	fr <<"-----------------------------------------------------------------------------------------------"<<endl;
	for (int i = 0; i < ElementuSkaiciusBendramGijuMasyve; i ++){
		Gija gija = bendrasGijuMasyvas[i];
		studentas = gija.isvestiStudentoInfo();
		fr  << left << setw(21) << gija.isvestiGijosPavadinima() << " "
			<< left << setw(15) << gija.isvestiElementoNr() << " "
			<< left << setw(19) << studentas.iðvestiStudentoVarda() << " "
			<< left << setw(19) << studentas.iðvestiStudentoKursa() << " "
			<< left << setw(9) << studentas.iðvestiStudentoVidurki() << endl;
	}
	fr.close();
}

void VykdytiGija(string gijosPavadinimas, Fakultetas *fakultetas, Gija bendrasGijuMasyvas[])
{
	Studentas studentas;
	Gija gija;
	int masyvoElementoNr;

	for (int i = 0; i < fakultetas->isvestiStudentuSkaiciu(); i ++)
	{
		studentas = fakultetas->gautiStudentoInfo(i);
		masyvoElementoNr = ElementuSkaiciusBendramGijuMasyve;
		for(int j = 0; j < 1000; j++){
			cout << gijosPavadinimas << endl;
		}
		ElementuSkaiciusBendramGijuMasyve ++;
		gija = *new Gija(gijosPavadinimas, studentas, masyvoElementoNr);
		bendrasGijuMasyvas[masyvoElementoNr] = gija;
	}
}
